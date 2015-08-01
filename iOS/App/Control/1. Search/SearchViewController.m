//
//  SearchViewController.m
//  CarTrawler
//
//

#import "SearchViewController.h"
#import "CTLocation.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+CSVParser.h"
#import "LocationListViewController.h"
#import "CTCountry.h"
#import "CTCurrency.h"
#import "SearchResultsViewController.h"

#import "RentalSession.h"
#import "CarTrawlerAppDelegate.h"
#import "VehAvailRSCore.h"
#import "MapSearchViewController.h"
#import "UIColor-Expanded.h"
#import "CTCountry.h"
#import "CTSearchDefaults.h"

#define SectionHeaderHeight 20

#define placeholderTextColor [UIColor colorWithWhite:0.7 alpha:1.0]
#define fieldTextColor [UIColor colorWithWhite:0.0 alpha:1.0]

@interface SearchViewController()

@property (nonatomic, strong) LocationListViewController *llvc;
@property (nonatomic, assign) BOOL isSelectingByMap;
@property (nonatomic, assign) BOOL searchingAlternateDropOffLocationFromMapView;
@property (nonatomic, strong) UILabel *countryLabel;
@property (nonatomic, strong) UIDatePicker *timePicker;

@end

@implementation SearchViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
        CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
		self.preloadedCountryList = appDelegate.preloadedCountryList;
		self.preloadedCurrencyList = appDelegate.preloadedCurrencyList;
    }
    return self;
}

#pragma mark -
#pragma mark Table Scrolling

- (void) resetTableOffset {
	[self.searchTable setContentOffset:CGPointMake(0, -3) animated:YES];
	
	[self.searchTable setScrollEnabled:YES];
}

#pragma mark -
#pragma mark UIView Annimations

- (void) resetListView {
	DLog(@"Resetting list to hidden = YES");
	[self.selectLocationView setHidden:YES];
	[self.llvc.filteredResults removeAllObjects];
}

- (void) fadeViewIn {
	DLog(@"Showing List View");
	self.dismissLocationPopUpButton.hidden = NO;
	self.searchTable.scrollEnabled = NO;
	[self.selectLocationView setAlpha:0.0];
	[self.selectLocationView setHidden:NO];
	
	[UIView beginAnimations:@"moveViewIn" context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	[self.selectLocationView setAlpha:1.0];
	
	[UIView commitAnimations];
	
	[self.view bringSubviewToFront:self.selectLocationView];
}
	
- (void) fadeViewOut {
	DLog(@"Hiding List View");
	self.dismissLocationPopUpButton.hidden = YES;
	self.searchTable.scrollEnabled = YES;
	[UIView beginAnimations:@"moveViewOut" context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDidStopSelector:@selector(resetListView)];
	
	[self.selectLocationView setAlpha:0.0];
	[self.llvc.filteredResults removeAllObjects];
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark UITextField & UILabel Creation

- (UITextField *) newTextField {
	
	CGRect frame = CGRectMake(kLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight);
	UITextField *textField = [[UITextField alloc] initWithFrame:frame];
	
	textField.borderStyle = UITextBorderStyleNone;
	textField.font = [UIFont systemFontOfSize:17.0];
	textField.backgroundColor = [UIColor clearColor];
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.opaque = NO;
	
	textField.keyboardType = UIKeyboardTypeDefault;	
	textField.returnKeyType = UIReturnKeyDone;
	
	textField.delegate = self;
	
	[textField setAccessibilityLabel:NSLocalizedString(@"Text Field", @"")];
	
	return textField;
}

- (UILabel *) newLabel {
	CGRect frame = CGRectMake(kLeftInset, 2, kInputItemWidth, kTextFieldHeight);	// The Y offset here is to compenate for UILabels auto text positioning in the middle, unlike the textbox.
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	
	label.textColor = [UIColor grayColor];
	label.font = [UIFont systemFontOfSize:17.0];
	label.backgroundColor = [UIColor clearColor];
	label.opaque = NO;
	
	return label;
}

#pragma mark -
#pragma mark API Calls

- (void) springAlert:(NSString *)title message:(NSString *)msg {
	[self.session printSession];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alert show];
	//[alert release];
}

CTHudViewController *hud;

- (void) requestFinishedWithVehAvailsCoreRS:(ASIHTTPRequest *) request {
	SearchResultsViewController *srvc = [[SearchResultsViewController alloc] initWithNibName:@"SearchResultsViewController" bundle:nil];
	
	NSString *responseString = [request responseString];
	NSDictionary *responseDict = [responseString JSONValue];
	
	if (kShowResponse) {
		DLog(@"Response is \n\n\n%@\n\n\n", responseString);
	}
	
	[hud hide];
	//[hud autorelease];
	hud = nil;
	
	if ([[CTHelper validateResponse:responseDict] isKindOfClass:[NSMutableArray class]]) 
	{
		// We have errors
		NSMutableArray *temp = (NSMutableArray *)[CTHelper validateResponse:responseDict];
		for (CTError *er in temp) 
		{
			if ([er.errorShortTxt isEqualToString:@"Search returned no records"]) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No results found" message:@"Try changing the search criteria and try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
				[alert show];
				//[alert release];
			} else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:er.errorShortTxt delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
				[alert show];
				//[alert release];
			}
		}
	} else if ([[CTHelper validateResponse:responseDict] isKindOfClass:[VehAvailRSCore class]])
	{
		srvc.resultsCore = [CTHelper validateResponse:responseDict];
		srvc.session = self.session;
		
		[self.navigationController pushViewController:srvc animated:YES];
	}
	else 
	{
		// No response
	}
}

- (void) makeRequest {
	self.session.numPassengers = @"1";
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// The following few lines detect the locale code should it either not have been set or discovered by the app.
	// If the pref is there but not hooked up, put it in. Otherwise, it means it hasn't and is hasn't been explicitly set by the user
	// (the key wouldn't be nil if it was) so detect and insert. If all that fails, pop the message and tell the user to set your home country.
    
	if ([prefs objectForKey:@"ctCountry.isoCountryCode"]) {
		self.session.homeCountry = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	} else {
		self.session.homeCountry = [CTHelper getLocaleCode];
	}
    
	[self saveUserPrefs];
	
	if (self.session.puLocationCode == NULL) {
		[self springAlert:@"Pickup location not set" message:@"Please set a pickup location."];
	} else if (self.session.puDateTime == NULL) {
		[self springAlert:@"Pickup time not set" message:@"Please set the time you wish to pickup your vehicle."];
	} else if (self.session.doLocationCode == NULL) {
		[self springAlert:@"Drop off location not set" message:@"Please set a drop off location."];
	} else if (self.session.doDateTime == NULL) {
		[self springAlert:@"Dropoff time not set" message:@"Please set the time when you would like to drop off your vehicle."];
	} else if (self.session.driverAge == NULL) {
		[self springAlert:@"Driver Age not set" message:@"Please set the driver's age."];
	} else if (self.session.homeCountry == NULL) {
		[self springAlert:@"Home Country not set." message:@"Please set your country from the home screen."];
	} else if (![self.ageTextField.text isEqualToString:self.session.driverAge]) {
		
		// This test is here in case a user has an age already set but the text box has been left blank by accident.
		
		self.session.driverAge = nil;
		[self springAlert:@"Driver Age not set" message:@"Please set the driver's age."];
		
		// Do we want to nuke the age key in prefs also at this point?
		
	} else {
		hud = [[CTHudViewController alloc] initWithTitle:@"Searching"];
		[hud show];
		[self.session printSession];
        
		NSString *requestString = [CTRQBuilder OTA_VehAvailRateRQ:self.session.puDateTime returnDateTime:self.session.doDateTime pickUpLocationCode:self.session.puLocationCode returnLocationCode:self.session.doLocationCode driverAge:self.session.driverAge  passengerQty:self.session.numPassengers homeCountryCode:self.session.homeCountry];
		
		ASIHTTPRequest *request = [CTHelper makeRequest:kOTA_VehAvailRateRQ tail:requestString];
		[request setDelegate:self];
		[request setTimeOutSeconds:30];
		[request setDidFinishSelector:@selector(requestFinishedWithVehAvailsCoreRS:)];
		[request startAsynchronous];
		//[request setNumberOfTimesToRetryOnTimeout:1];
		
        //	[FlurryAPI logEvent:@"Step 1: Made Search."];
		
		//rjh NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        //	[NSString stringWithFormat:@"(%@) %@", session.puLocationCode, session.puLocationNameString], @"Pickup location.",
        //	session.puDateTime, @"Pickup time.",
        //	[NSString stringWithFormat:@"(%@) %@", session.doLocationCode, session.doLocationNameString], @"Dropoff location",
        //	session.doDateTime, @"Dropoff time",
        //	session.driverAge, @"Driver age.",
        //	session.homeCountry, @"Country of Residence",
        //	nil];
		
        //	[FlurryAPI logEvent:@"Step 1: Search Submitted." withParameters:dictionary];
		
        //	[FlurryAPI logEvent:@"Session." timed:YES];
	}
}

- (void) makeSecureRequest {
	self.session.numPassengers = @"1";
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// The following few lines detect the locale code should it either not have been set or discovered by the app.
	// If the pref is there but not hooked up, put it in. Otherwise, it means it hasn't and is hasn't been explicitly set by the user
	// (the key wouldn't be nil if it was) so detect and insert. If all that fails, pop the message and tell the user to set your home country.
    
	if ([prefs objectForKey:@"ctCountry.isoCountryCode"]) {
		self.session.homeCountry = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	} else {
		self.session.homeCountry = [CTHelper getLocaleCode];
	}
    
	[self saveUserPrefs];
	
	if (self.session.puLocationCode == NULL) {
		[self springAlert:@"Pickup location not set" message:@"Please set a pickup location."];
	} else if (self.session.puDateTime == NULL) {
		[self springAlert:@"Pickup time not set" message:@"Please set the time you wish to pickup your vehicle."];
	} else if (self.session.doLocationCode == NULL) {
		[self springAlert:@"Drop off location not set" message:@"Please set a drop off location."];
	} else if (self.session.doDateTime == NULL) {
		[self springAlert:@"Dropoff time not set" message:@"Please set the time when you would like to drop off your vehicle."];
	} else if (self.session.driverAge == NULL) {
		[self springAlert:@"Driver Age not set" message:@"Please set the driver's age."];
	} else if (self.session.homeCountry == NULL) {
		[self springAlert:@"Home Country not set." message:@"Please set your country from the home screen."];
	} else if (![self.ageTextField.text isEqualToString:self.session.driverAge]) {
		
		// This test is here in case a user has an age already set but the text box has been left blank by accident.
		
		self.session.driverAge = nil;
		[self springAlert:@"Driver Age not set" message:@"Please set the driver's age."];
		
		// Do we want to nuke the age key in prefs also at this point?
		
	} else {
		hud = [[CTHudViewController alloc] initWithTitle:@"Searching"];
		[hud show];
		[self.session printSession];
        
		NSString *requestString = [CTRQBuilder OTA_VehAvailRateRQ:self.session.puDateTime returnDateTime:self.session.doDateTime pickUpLocationCode:self.session.puLocationCode returnLocationCode:self.session.doLocationCode driverAge:self.session.driverAge  passengerQty:self.session.numPassengers homeCountryCode:self.session.homeCountry];
		
		ASIHTTPRequest *request = [CTHelper makeRequest:kOTA_VehAvailRateRQ tail:requestString];
		[request setDelegate:self];
		[request setTimeOutSeconds:30];
		[request setDidFinishSelector:@selector(requestFinishedWithVehAvailsCoreRS:)];
		[request startAsynchronous];
		//[request setNumberOfTimesToRetryOnTimeout:1];
		
        //	[FlurryAPI logEvent:@"Step 1: Made Search."];
		
		//rjh NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        //	[NSString stringWithFormat:@"(%@) %@", session.puLocationCode, session.puLocationNameString], @"Pickup location.",
        //	session.puDateTime, @"Pickup time.",
        //	[NSString stringWithFormat:@"(%@) %@", session.doLocationCode, session.doLocationNameString], @"Dropoff location",
        //	session.doDateTime, @"Dropoff time",
        //	session.driverAge, @"Driver age.",
        //	session.homeCountry, @"Country of Residence",
        //	nil];
		
        //	[FlurryAPI logEvent:@"Step 1: Search Submitted." withParameters:dictionary];
		
        //	[FlurryAPI logEvent:@"Session." timed:YES];
	}
}

- (void) requestFailed:(ASIHTTPRequest *) request {
	NSError *error = [request error];
	Error(@"%@", error);
	[hud hide];
	//[hud autorelease];
	hud = nil;
} 

#pragma mark -
#pragma mark Predictive Location API Calls

- (void) makePartialLocationRequest:(NSString *)partial {
	[self.llvc.spinner setHidden:NO];
	[self.llvc.spinner startAnimating];

	NSString *requestString = [CTRQBuilder CT_VehLocSearchRQ_Partial:partial];
	if (kShowRequest) {
		DLog(@"\n%@\n", requestString);
	}
	ASIHTTPRequest *request = [CTHelper makeRequestWithoutBuiltInHeader:kCT_VehLocSearchRQ tail:requestString];
	
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(partialLocationRequestFinished:)];
	[request setDidFailSelector:@selector(partialLocationRequestFailed:)];
	[request startAsynchronous];
}

- (void) partialLocationRequestFinished:(ASIHTTPRequest *) request {
	NSString *responseString = [request responseString];
	if (kShowResponse) {
		DLog(@"\n%@\n", responseString);
	}
	NSDictionary *responseDict = [responseString JSONValue];
	[self.llvc updateResults:[CTHelper validatePredictiveLocationsResponse:responseDict]];
	[self.llvc.spinner stopAnimating];
	[self.llvc.spinner setHidden:YES];
}

- (void) partialLocationRequestFailed:(ASIHTTPRequest *) request {
	DLog(@"Pre-fetch request failed");
	[self.llvc.spinner stopAnimating];
	[self.llvc.spinner setHidden:YES];
}

#pragma mark -
#pragma mark Notification Consumption

- (void) ctLocationSelected:(NSNotification *)notify {
	id ndict = [notify userInfo];
	if ([ndict objectForKey:@"selectedLocation"]) {
		CTLocation *loc = [ndict objectForKey:@"selectedLocation"];
		if(!self.isSelectingByMap) {
			
			[self fadeViewOut];
			
		} else {
			[self dismissViewControllerAnimated:YES completion:nil];
			self.isSelectingByMap = NO;
		}
		
		if (self.isSettingDropoffLocation) {
			self.dropoffTextField.text = [loc.locationName capitalizedString];
			
			// Set the strings for the search parameter.
			self.dropOffLocationName = [NSString stringWithString:[loc.locationName capitalizedString]];
			self.returnLocationCode = [NSString stringWithString:loc.locationCode];
			
			[self.session setDoLocationCode:[NSString stringWithString:loc.locationCode]];
			[self.session setDoLocationNameString:loc.locationName];
			[self.session setDoLocation:loc];
			[self.dropoffTextField resignFirstResponder];
			self.dropoffLocationSet = YES;
			self.isSettingDropoffLocation = NO;
			
		} else {
			
			if (self.searchingAlternateDropOffLocationFromMapView) {
				
				self.searchingAlternateDropOffLocationFromMapView = NO;
				self.dropoffTextField.text = [loc.locationName capitalizedString];
				DLog(@"setting alternate drop off loc only;"); 
				
				// Set the strings for the search parameter.
				
				self.dropOffLocationName = [NSString stringWithString:[loc.locationName capitalizedString]];
				self.returnLocationCode = [NSString stringWithString:loc.locationCode];
				
				[self.session setDoLocationCode:[NSString stringWithString:loc.locationCode]];
				[self.session setDoLocationNameString:loc.locationName];
				[self.session setDoLocation:loc];
				[self.pickupTextField resignFirstResponder];// dnt think this is needed
				[self.dropoffTextField resignFirstResponder];
				
			} else {
				
				self.pickupTextField.text = [loc.locationName capitalizedString];
				[self.pickupTextField setTextColor:[UIColor redColor]];
				
				// Set the strings for the search parameter.
				self.pickUpLocationName = [NSString stringWithString:[loc.locationName capitalizedString]];
				self.pickUpLocationCode = [NSString stringWithString:loc.locationCode];
				
				[self.session setPuLocationCode:[NSString stringWithString:loc.locationCode]];
				[self.session setPuLocationNameString:loc.locationName];
				[self.session setPuLocation:loc];
				
				if (!self.dropoffLocationSet){
					//if not set, use pickup for droppoff
					self.dropoffTextField.text = [loc.locationName capitalizedString];
					self.dropOffLocationName = [NSString stringWithString:[loc.locationName capitalizedString]];
					self.returnLocationCode = [NSString stringWithString:loc.locationCode];
					
					self.session.doLocationCode = loc.locationCode;
					[self.session setDoLocationNameString:loc.locationName];
					[self.session setDoLocation:loc];
				}
				
				[self.pickupTextField resignFirstResponder];
				self.pickupLocationSet = YES;
			}
		}
		
		[self resetTableOffset];
		[self updateFieldColors];
	} else {
		
	}
	
}

#pragma mark -
#pragma mark Set CTLocation Info from Map

- (void) setLocationFromMap {
	self.pickUpLocationCode = self.selectedNearbyLocation.locationCode;
	self.pickUpLocationName = self.selectedNearbyLocation.locationName;
	[self.session setPuLocationNameString:self.selectedNearbyLocation.locationName];
	[self.session setPuLocation:self.selectedNearbyLocation];
	
	self.dropOffLocationName = self.selectedNearbyLocation.locationName;
	self.returnLocationCode = self.selectedNearbyLocation.locationCode;
	[self.session setDoLocationNameString:self.selectedNearbyLocation.locationName];
	[self.session setDoLocation:self.selectedNearbyLocation];
	
	self.pickupTextField.text = self.selectedNearbyLocation.locationName;
	self.dropoffTextField.text = self.selectedNearbyLocation.locationName;
	
	self.session.puLocationCode = self.selectedNearbyLocation.locationCode;
	self.session.doLocationCode = self.selectedNearbyLocation.locationCode;
}

#pragma mark -
#pragma mark viewDidLoad

- (void) dismissLocationPopup {
	[self fadeViewOut];
}


- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
	// This is important;
	// It is possible to jump between views and change what the UI says your Country & Currency are and what they are actually stored as.  Since these
	// are two critical bits of info for API requests, when the view appears we always get what's been saved.
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	self.session.homeCountry = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	self.session.activeCurrency = [prefs objectForKey:@"ctCountry.currencyCode"];
}

- (void) viewDidLoad {
    
    CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationItem.rightBarButtonItem.tintColor = appDelegate.governingTintColor;
    
	if (self.session) {
		self.session = nil;
	}
	self.session = [[RentalSession alloc] init];
	
    
	// We still need to specify the title for the next navcontroller's back button.
	self.title = NSLocalizedString(@"Search", nil);
	self.navigationItem.titleView = [CTHelper getNavBarLabelWithTitle:NSLocalizedString(@"Search", nil)];
	
	[self.searchTable setContentInset:UIEdgeInsetsMake(3,0,0,0)];
	
	self.dismissLocationPopUpButton = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 200.0)];
	self.dismissLocationPopUpButton.hidden = YES;
	[self.dismissLocationPopUpButton addTarget:self action:@selector(dismissLocationPopup) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.dismissLocationPopUpButton];
	//[self.dismissLocationPopUpButton release];
	
	self.preloadedCountryList = appDelegate.preloadedCountryList;
	
	self.ctCountry = [[CTCountry alloc] init];
	
	UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleDone target:self action:@selector(clearData:)];
	self.navigationItem.rightBarButtonItem = resetButton;
	//[resetButton	release];
	
	self.driverAge = @"";
	self.passengerQty = @"";
	
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ctLocationSelected:) name:@"CTLocationSelected" object:nil];
	
	self.searchTable.backgroundColor = [UIColor clearColor];
    self.searchTable.backgroundView = nil;
	
	self.frontViewIsVisible = YES;
	
	[self.containerView setHidden:YES];
	[self.selectLocationView setHidden:YES];
	[self.countryPickerView setHidden:YES];
	[self.currencyPickerView setHidden:YES];
	
	self.llvc = [[LocationListViewController alloc] initWithNibName:@"LocationListViewController" bundle:nil];
	[self.selectLocationView addSubview:self.llvc.view];
	
	self.canShowList = YES;
	self.showListNow = NO;
	
	self.pickupTextField = [self newTextField];
	self.pickupTextField.placeholder = kPickUpTextPlaceHolder;
	[self.pickupTextField setTextColor:placeholderTextColor];

	self.dropoffTextField = [self newTextField];
	self.dropoffTextField.placeholder = kDropOffTextPlaceHolder;
	[self.dropoffTextField setTextColor:placeholderTextColor];
	
	self.pickupDateLabel = [self newLabel];
	self.pickupDateLabel.text = kPickupLabelPlaceHolder;
	[self.pickupDateLabel setTextColor:placeholderTextColor];
	
	self.dropoffDateLabel = [self newLabel];
	self.dropoffDateLabel.text = kDropOffLabelPlaceHolder;
	[self.dropoffDateLabel setTextColor:placeholderTextColor];
	
	self.countryLabel = [self newLabel];
	self.countryLabel.text = @"Country of residence";
	
	self.ageTextField = [self newTextField];
	self.ageTextField.placeholder = kAgeTextPlaceHolder;
	[self.ageTextField setTextColor:placeholderTextColor];
	
	self.numberOfPassengersTextField = [self newTextField];
	self.numberOfPassengersTextField.text = kNumberOfPassengersTextHolder;
	
	self.alternateDrop = YES;
	self.isSettingDropoffLocation = NO;
	
	//[self checkCurrentMode];
	[self loadHomeCountryFromMemory];
	[self loadUserPrefs];
	
	if (self.setFromLocations) {
		// This has been set from the Locations map. It will populate the selected CTLocation into the location fields.
		[self setLocationFromMap];
		[self updateFieldColors];
	}
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	DLog(@"Memory Warning?");
}

#pragma mark -
#pragma mark Save View States or Values

- (void) processSelectedDates {
    NSLocale *          enUSPOSIXLocale;
    enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    assert(enUSPOSIXLocale != nil);
    
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"EEE dd/MM/yy"];
	//[dateFormat setDateStyle:NSDateFormatterMediumStyle];
	//[dateFormat setTimeStyle:NSDateFormatterNoStyle];
	
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setLocale:enUSPOSIXLocale];
	[timeFormat setDateStyle:NSDateFormatterNoStyle];
	[timeFormat setTimeStyle:NSDateFormatterShortStyle];
    
	NSDateFormatter *USdateFormat = [[NSDateFormatter alloc] init];
	[USdateFormat setDateFormat:@"dd/MM/yyyy"]; 
	
	NSDateFormatter *UStimeFormat = [[NSDateFormatter alloc] init];
    [UStimeFormat setLocale:enUSPOSIXLocale];
	[UStimeFormat setDateStyle:NSDateFormatterNoStyle];
	[UStimeFormat setTimeStyle:NSDateFormatterNoStyle];
	[UStimeFormat setDateFormat:@"HH:mm"]; 
	
	NSDateFormatter *apiFormat = [[NSDateFormatter alloc] init];
	[apiFormat setDateFormat:@"yyyy-MM-dd"];
	
	if (self.isSettingPickup) 
	{
		self.formattedPickupString = [NSString stringWithFormat:@"%@T%@:00", [apiFormat stringFromDate:self.timePicker.date], [UStimeFormat stringFromDate:self.timePicker.date]];
		[self.session setPuDateTime:self.formattedPickupString];
		
		[self.pickupDateLabel setText:[NSString stringWithFormat:@"%@ %@", [dateFormat stringFromDate:self.timePicker.date], [timeFormat stringFromDate:self.timePicker.date]]];
		[self.session setReadablePuDateTimeString:self.pickupDateLabel.text];
		
		if (self.isSettingPickup && !self.dropoffDateSet)
		{
			NSTimeInterval selectedDate = [self.timePicker.date timeIntervalSince1970];
			//double secondsSinceMidnight = fmod(selectedDate, 86400); //number of seconds since midnight today
			double secondsInADay = 24*60*60;
            
			//double secondsFromMidnightToTenAM = 10*60*60;
			//NSDate *earliestDropoffDate = [NSDate dateWithTimeIntervalSinceReferenceDate:(selectedDate - secondsSinceMidnight + secondsInADay + secondsFromMidnightToTenAM)];
			NSDate *earliestDropoffDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)((double)selectedDate + (double)secondsInADay) ];

			self.session.endDate = earliestDropoffDate;
			[self.dropoffDateLabel setText:[NSString stringWithFormat:@"%@ %@", [dateFormat stringFromDate:earliestDropoffDate], [timeFormat stringFromDate:earliestDropoffDate]]];
			[self.session setDoDateTime:[NSString stringWithFormat:@"%@T%@:00", [apiFormat stringFromDate:earliestDropoffDate], [UStimeFormat stringFromDate:earliestDropoffDate]]];
			[self.session setReadableDoDateTimeString:self.dropoffDateLabel.text];
		}
		self.session.startDate = self.timePicker.date;
	}
	if (self.isSettingDropoff)
	{
		self.formattedDropoffString = [NSString stringWithFormat:@"%@T%@:00", [apiFormat stringFromDate:self.timePicker.date], [UStimeFormat stringFromDate:self.timePicker.date]];

		[self.session setDoDateTime:self.formattedDropoffString];
		
		[self.dropoffDateLabel setText:[NSString stringWithFormat:@"%@ %@", [dateFormat stringFromDate:self.timePicker.date], [timeFormat stringFromDate:self.timePicker.date]]];
		self.session.endDate = self.timePicker.date;
		
		[self.session setReadableDoDateTimeString:self.dropoffDateLabel.text];
	}
	/*
	[apiFormat release];
	[timeFormat release];
	[dateFormat release];
	[USdateFormat release];
	[UStimeFormat release];
     */
}

- (void) changeDateInLabel:(id)sender {	
	[self processSelectedDates];
}

- (void) saveDateAndTime {
	
	[self processSelectedDates];
	if (self.isSettingPickup){
		self.pickupDateSet = YES;
		self.isSettingPickup = NO;
	}
	if (self.isSettingDropoff){
		self.dropoffDateSet = YES;
		self.isSettingDropoff = NO;
	}

	[self.containerView setHidden:YES];
	self.frontViewIsVisible =! self.frontViewIsVisible;
	[self resetTableOffset];
	[self updateFieldColors];
}

#pragma mark -
#pragma mark Show Views or View Controllers

- (void) myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	// re-enable user interaction when the flip is completed.
	//self.containerView.userInteractionEnabled = YES;
	//flipIndicatorButton.userInteractionEnabled = YES;
}

- (void) flipCurrentView {
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"HH:mm"]; 
	NSDate *now = [NSDate date];
	


	if ((self.theDateFromPicker == nil) && (self.frontViewIsVisible) )
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please try again" message:@"In order to search for available cars, please choose a date in the future." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		//[alertView release];
		return;
	}
	else if ([self.theDateFromPicker compare:now] == NSOrderedDescending) 
	{
		self.theDateFromPicker = nil;
	} 
	else if (self.frontViewIsVisible)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please try again" message:@"In order to search for available cars, please choose a date in the future." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		//[alertView release];
		return;
	}

	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.50];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];
	
	// swap the views and transition
    if (self.frontViewIsVisible) 
	{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.containerView cache:YES];
        [self.calendarView removeFromSuperview];
        [self.containerView addSubview:self.pickerView];
    } 
	else 
	{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.containerView cache:YES];
        [self.pickerView removeFromSuperview];
        [self.containerView addSubview:self.calendarView];
    }
	[UIView commitAnimations];
	
	self.frontViewIsVisible =! self.frontViewIsVisible;
}

- (void) showCalendarAndTimePickerViews {
	// Calendar View
	[self.ageTextField resignFirstResponder];
	[self.numberOfPassengersTextField resignFirstResponder];
	[self.pickupTextField resignFirstResponder];
	[self.dropoffTextField resignFirstResponder];
	
	// Time Picker View
	
	self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(2.0, 0.0, 312.0, 280.0)];
	self.pickerView.clipsToBounds = YES;
	
	if (self.timePicker == nil) {
		self.timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 60, 312, 216)];
	}

	self.timePicker.datePickerMode = UIDatePickerModeDateAndTime;
	self.timePicker.minuteInterval = 15;

	NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
	double secondsSinceMidnight = fmod(now, 86400); //number of seconds since midnight today
	double secondsInADay = 24*60*60;
	double secondsFromMidnightToTenAM = 10*60*60;
	NSDate *earliestPickupDate = [NSDate dateWithTimeIntervalSinceReferenceDate:(now - secondsSinceMidnight + secondsInADay + secondsFromMidnightToTenAM)];

	NSDate *earliestDropoffDate;
	
	if (self.pickupDateSet){
		NSTimeInterval pickupDateInterval = [self.session.startDate timeIntervalSinceReferenceDate];
		secondsSinceMidnight = fmod(pickupDateInterval, 86400);
		earliestDropoffDate = [NSDate dateWithTimeIntervalSinceReferenceDate:(pickupDateInterval + secondsInADay * 1)];
	}
	else {
		earliestDropoffDate = [NSDate dateWithTimeIntervalSinceReferenceDate:(now - secondsSinceMidnight + secondsInADay * 2)];
	}
		

	[self.timePicker removeTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];

	if (self.isSettingPickup){
		if (!self.pickupDateSet) {
			[self.timePicker setDate:earliestPickupDate];
		}
		[self.timePicker setMinimumDate:earliestPickupDate];
	}
	if (self.isSettingDropoff){
		if (!self.dropoffDateSet) {
			[self.timePicker setDate:earliestDropoffDate];
		}
		[self.timePicker setMinimumDate:earliestDropoffDate];
	}
	
	[self.pickerView addSubview:self.timePicker];
	[self.timePicker addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
    [self.timePicker setBackgroundColor:[UIColor whiteColor]];
	
	UIImageView *pickerOutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerPopOver.png"]];
	[self.pickerView addSubview:pickerOutline];
	[self.pickerView bringSubviewToFront:pickerOutline];
    [self.pickerView setBackgroundColor:[UIColor clearColor]];
	
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(255, 25, 50, 30);
    [doneButton addTarget:self action:@selector(saveDateAndTime) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerView addSubview:doneButton];
	
	[self.containerView addSubview:self.pickerView];
	[self.containerView setHidden:NO];
}

#pragma mark -
#pragma mark IBActions

- (void) dismissCalendarAndPickerViews {
	[self.containerView setHidden:YES];
	self.frontViewIsVisible = YES;
	[self resetTableOffset];
}

- (IBAction) clearData:(id)sender {
	
	[self dismissCalendarAndPickerViews];
	[self.pickupTextField resignFirstResponder];
	[self.dropoffTextField resignFirstResponder];
	[self.ageTextField resignFirstResponder];
	
	self.pickupTextField.placeholder = kPickUpTextPlaceHolder;
	self.pickupTextField.text = @"";
	self.dropoffTextField.placeholder = kDropOffTextPlaceHolder;
	self.dropoffTextField.text = @"";
	self.pickupDateLabel.text = kPickupLabelPlaceHolder;
	self.dropoffDateLabel.text = kDropOffLabelPlaceHolder;
	self.countryLabel.text = @"Country of residence";
	self.ageTextField.placeholder = kAgeTextPlaceHolder;
	self.ageTextField.text = kAgeTextPlaceHolder;
	self.numberOfPassengersTextField.text = kNumberOfPassengersTextHolder;
	
	self.alternateDrop = YES;
	self.searchingAlternateDropOffLocationFromMapView = NO;
	self.isSettingDropoffLocation = NO;
	self.pickupLocationSet = NO;
	self.dropoffLocationSet = NO;
	self.pickupDateSet = NO;
	self.dropoffDateSet = NO;

	self.theDateFromPicker = nil;
	self.pickUpDateTime = nil;
	self.returnDateTime = nil;
	self.pickUpLocationCode = nil;
	self.pickUpLocationName = nil;
	self.dropOffLocationName = nil;
	self.returnLocationCode = nil;
	self.driverAge = nil;
	self.passengerQty = nil;
	self.homeCountryCode = nil;
	self.formattedPickupString = nil;
	self.formattedDropoffString = nil;
	
	self.session.puDateTime = nil;
	self.session.doDateTime = nil;
	self.session.puLocationCode = nil;
	self.session.doLocationCode = nil;
	self.session.homeCountry = nil;	
	self.session.driverAge = nil;
	self.session.numPassengers = nil;
	
	self.session.theCar = nil;
	self.session.theVendor = nil;
	
	[self loadHomeCountryFromMemory];
	[self updateFieldColors];
	[self fadeViewOut];

}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void) searchLocationsByString:(NSString *)searchString {
	[self makePartialLocationRequest:[NSString stringWithFormat:@"%@",searchString]];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
	if (textField == self.pickupTextField) {
		
		self.searchingAlternateDropOffLocationFromMapView = NO;
		self.pickupTextField.text = @"";
		[self.searchTable setContentOffset:CGPointMake(0, 30) animated:YES];
		[self.searchTable setScrollEnabled:NO];
		self.canShowList = YES;
		
	} else if (textField == self.dropoffTextField) {
		
		self.searchingAlternateDropOffLocationFromMapView= NO;
		self.isSettingDropoffLocation = YES;
		self.dropoffTextField.text = @"";
		[self.searchTable setContentOffset:CGPointMake(0, 130) animated:YES];
		[self.searchTable setScrollEnabled:NO];
		self.canShowList = YES;
		
	} else if (textField == self.numberOfPassengersTextField) {
		
		self.numberOfPassengersTextField.text = @"";
		[self.searchTable setContentOffset:CGPointMake(0, 186) animated:YES];
		
	} else if (textField == self.ageTextField) {
		self.ageTextField.text = @"";
		if (self.alternateDrop ) {
			[self.searchTable setContentOffset:CGPointMake(0, 130) animated:YES];
		} else {
			[self.searchTable setContentOffset:CGPointMake(0, 130) animated:YES];
		}
	} 
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered {
	if (textField == self.pickupTextField) {
		self.isSelectingByMap = NO;
		NSString *searchTerm = [NSString stringWithFormat:@"%@%@", self.pickupTextField.text, textEntered];
		if ([searchTerm length] >= 3) {
			
			[self searchLocationsByString:searchTerm];

			if (self.canShowList) {
				[self fadeViewIn];
			}
			self.canShowList = NO;
			
		} else if ([searchTerm length] < 3) {
			self.canShowList = YES;
			[self fadeViewOut];
		}
	}
	if (textField == self.dropoffTextField) {
		NSString *searchTerm = [NSString stringWithFormat:@"%@%@", self.dropoffTextField.text, textEntered];
		if ([searchTerm length] > 2) {
			[self searchLocationsByString:searchTerm];
			if (self.canShowList) {
				[self fadeViewIn];
			}
			self.canShowList = NO;
			
		} else if ([searchTerm length] == 2) {
			[self searchLocationsByString:searchTerm];
			self.canShowList = YES;
			[self fadeViewOut];
		} else if ([searchTerm length] < 2) {
			self.canShowList = YES;
			[self fadeViewOut];
		}
	}
	if (textField == self.ageTextField) {
		NSString *combinedString = [NSString stringWithFormat:@"%@%@", self.ageTextField.text, textEntered];
		if ([combinedString length] >= 2) {
			
			if ( [combinedString intValue] < 18)
			{
				DLog(@"Age is less than 18");
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please try again" message:@"In order to search for available cars, please enter an age above 17." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alertView setTag:1];
				[alertView show];
				//[alertView release];
				return YES;
			}

			[self.ageTextField setText:combinedString];
			
			self.driverAge = [NSString stringWithString:combinedString];
			[self.session setDriverAge:self.driverAge];
			[self.ageTextField resignFirstResponder];
			[self resetTableOffset];
			[self updateFieldColors];
		}
	}
	if (textField == self.numberOfPassengersTextField) {
		NSString *combinedString = [NSString stringWithFormat:@"%@%@", self.numberOfPassengersTextField.text, textEntered];
		if ([combinedString length] == 1) {
			[self.numberOfPassengersTextField setText:combinedString];
			
			self.passengerQty = [NSString stringWithString:combinedString];
			[self.session setNumPassengers:self.passengerQty];
			[self.numberOfPassengersTextField resignFirstResponder];
		}
	}
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	if (textField == self.pickupTextField || textField == self.dropoffTextField || textField == self.ageTextField) {
		[textField resignFirstResponder];
		[self fadeViewOut];
		[self resetTableOffset];
		
		// This takes either the pickup or dropoff textfields and will dump the map button from the accessory view when the editing 
		// stops in that textfield.
		
		UITableViewCell *cell;
		if (textField == self.pickupTextField) {
			cell = [self.searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];	
		} else {
			cell = [self.searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
		}
		cell.accessoryView = nil;
		
		if (textField == self.dropoffTextField && self.pickupLocationSet) {
			self.dropoffTextField.text = self.pickupTextField.text;
			
			[self.session setDoLocationCode:self.session.puLocationCode];
			[self.session setDoLocationNameString:self.session.puLocationNameString];
			[self.session setDoLocation:self.session.puLocation];
			
			[self updateFieldColors];
		}
	}
	return YES;
}

- (void) didTapLocationButton:(id) sender {
	DLog(@"Did tap location button")
	self.searchingAlternateDropOffLocationFromMapView = NO;
	MapSearchViewController *mvc = [[MapSearchViewController alloc] init];
	self.isSelectingByMap = YES;
	[self presentViewController:mvc animated:YES completion:nil];
	//[mvc release];
}

- (void) didTapAlternateLocationButton:(id) sender {
	DLog(@"Did tap Alternate location button")
	self.searchingAlternateDropOffLocationFromMapView = YES;
	MapSearchViewController *mvc = [[MapSearchViewController alloc] init];
	self.isSelectingByMap = YES;
	[self presentViewController:mvc animated:YES completion:nil];
	//[mvc release];
}

- (void) didTapCalendarButton:(id) sender {
	[self showCalendarAndTimePickerViews];
}

#pragma mark -
#pragma mark UITableView Stuff

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	CGRect rect = CGRectMake(0,0,292,40);
	
	UIView *view = [[UIView alloc] initWithFrame:rect];
	[view setContentMode:UIViewContentModeScaleToFill];
	[view setClipsToBounds:YES];
	[view setOpaque:NO];
	
	UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
	UIImage *image = [UIImage imageNamed:@"table_middle.png"];
	[imageview setImage:image];
	[view addSubview:imageview];
	
	//[imageview release];
	
	[cell insertSubview:view belowSubview:[cell backgroundView]];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 33;
	} else {
		return SectionHeaderHeight;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 2) {
		return 100.0;
	} else {
		return 10;
	}
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
	UILabel *label = [[UILabel alloc] init];
	if (section == 0) {
		
		label.frame = CGRectMake(20, 3, 300, 33);
        
		CGRect rect = CGRectMake(0,0,292,33);

       /* if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		
            rect = CGRectMake(-1,0,292,33);
            
        }*/
        
		UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
		UIImage *image = [UIImage imageNamed:@"table_header.png"];
		[imageview setImage:image];
		[view addSubview:imageview];
	} else {
		
		label.frame = CGRectMake(20, -10, 300, 30);
		
		CGRect rect = CGRectMake(0,-10,292,30);
        
        /*if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            
            rect = CGRectMake(-1,-10,292,30);
            
        }*/
		UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
		UIImage *image = [UIImage imageNamed:@"table_middle.png"];
		[imageview setImage:image];
		[view setContentMode:UIViewContentModeScaleToFill];
		[view addSubview:imageview];
	}


    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
	
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor colorWithRed:0.059 green:0.325 blue:0.569 alpha:1.000];
	label.font = [UIFont boldSystemFontOfSize:16];
	label.text = sectionTitle;
	
	[view addSubview:label];
	
	return view;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
	if (section == 2) {
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
        
        CGRect rect = CGRectMake(0,0,292,70);
        
        /*if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            rect = CGRectMake(-1,0,292,70);
        }*/
        
		UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
		UIImage *image = [UIImage imageNamed:@"table_button_footer.png"];
		[imageview setImage:image];
		[view addSubview:imageview];
		
		UIButton *searchBtn = [CTHelper getGreenUIButtonWithTitle:NSLocalizedString(@"Search", nil)];
		[searchBtn addTarget:self action:@selector(makeRequest) forControlEvents:UIControlEventTouchUpInside];
		
		[view addSubview:searchBtn];
		return view;
	} else {
		return nil;
	}
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) 
	{
		return 2;
	} 
	else if (section == 1) 
	{
		if (self.alternateDrop)
		{
			return 2;
		}
		else 
		{
			return 1;	
		}
	} 
	else 
	{
		return 1;
	}
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *sectionHeader = nil;
	if(section == 0) {
		sectionHeader = @"Pick up";
	}
	else if (section == 1){
		sectionHeader = @"Drop off";
	}  else {
		sectionHeader = @"Drivers age";
	}

	return sectionHeader; 
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 39;
}

- (void) realignFieldInCell:(UIView*)field {
//	CGRect frame = field.frame;
//	if (frame.origin.y==12.0){
//		CGRect realignedFrame = CGRectMake(frame.origin.x-2.0,frame.origin.y+3.0, frame.size.width, 14.0);
//		[field setFrame:realignedFrame];
//	}
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SearchItemCell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)  {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	//[cell setFont:[UIFont boldSystemFontOfSize:14]];
	[cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.tag = indexPath.row; // i.e. one of the SearchMenuItem enum items
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];

	if (section == 0) {
		if (row == 0) {
			self.pickupTextField.placeholder = @"Pickup Location";
			
			if (self.pickupTextField.text==nil) {
				[self realignFieldInCell:self.pickupTextField];
			}
			
			[self.pickupTextField setKeyboardType:UIKeyboardTypeDefault];
			[cell.contentView addSubview:self.pickupTextField];
			
			if (self.setFromLocations) {
				[self showAccessoryTickForCell:cell withValue:self.session.puLocationCode enabled:self.pickupLocationSet];
			}
			
			[self.showMapButton addTarget:self action:@selector(showMapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[self.showMapButton setTag:0];
			[self.showMapButton setFrame:CGRectMake(4, 2, self.showMapButton.bounds.size.width, self.showMapButton.bounds.size.height)];
			[cell.contentView addSubview:self.showMapButton];
			
		} else {
			[cell setFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, 10.0)];
			[cell.contentView addSubview:self.pickupDateLabel];
			
			UIImageView *calIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cal_icon.png"]];
			[calIcon setFrame:CGRectMake(10, 5, calIcon.bounds.size.width, calIcon.bounds.size.height)];
			[cell.contentView addSubview:calIcon];
			//[calIcon release];
		} 

	} else if (section == 1) {
		if (row == 0) {
			self.dropoffTextField.enabled = YES;
			self.dropoffTextField.placeholder = @"Dropoff Location";
			
			if (self.dropoffTextField.text == nil) {
				[self realignFieldInCell:self.dropoffTextField];
			}
				
			[cell.contentView addSubview:self.dropoffTextField];
			
			if (self.setFromLocations) {
				[self showAccessoryTickForCell:cell withValue:self.session.doLocationCode enabled:self.dropoffLocationSet];
			}
			
			[self.showDOMapButton addTarget:self action:@selector(showMapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[self.showDOMapButton setTag:1];
			[self.showDOMapButton setFrame:CGRectMake(4, 0, self.showDOMapButton.bounds.size.width, self.showDOMapButton.bounds.size.height)];
			[cell.contentView addSubview:self.showDOMapButton];
		} else {
			[cell setFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, 10.0)];
			[cell.contentView addSubview:self.dropoffDateLabel];
			
			UIImageView *calIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cal_icon.png"]];
			[calIcon setFrame:CGRectMake(10, 5, calIcon.bounds.size.width, calIcon.bounds.size.height)];
			[cell.contentView addSubview:calIcon];
			//[calIcon release];
		}
	} else {
		self.ageTextField.placeholder = @"Driver Age";
		
		if (self.ageTextField.text == nil){
			[self realignFieldInCell:self.ageTextField];
		}
			
		[self.ageTextField setKeyboardType:UIKeyboardTypeNumberPad];
		[cell.contentView addSubview:self.ageTextField];
		UIImageView *calIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"age_icon.png"]];
		[calIcon setFrame:CGRectMake(10, 6, calIcon.bounds.size.width, calIcon.bounds.size.height)];
		[cell.contentView addSubview:calIcon];
		//[calIcon release];
	}	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	
	
	if (indexPath.section == 0) {
		
		if (indexPath.row == 0) {
			[self.pickupTextField becomeFirstResponder];
			[self.countryPickerView setHidden:YES];
		} else {
			[self.pickupTextField resignFirstResponder];
			
			[self.searchTable setScrollEnabled:NO];
			[self.countryPickerView setHidden:YES];
			
			self.isSettingDropoff = NO;
			self.isSettingPickup = YES;
			
			[self.searchTable setContentOffset:CGPointMake(0, 68) animated:YES];	
			[self didTapCalendarButton:self];
		} 
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			if (self.alternateDrop ) {
				[self.dropoffTextField becomeFirstResponder];
			 [self.countryPickerView setHidden:YES];
			} else {
				self.isSettingDropoffLocation = YES;
				[self.pickupTextField resignFirstResponder];
				[self.countryPickerView setHidden:YES];
				[self.searchTable setScrollEnabled:NO];
				
				self.isSettingDropoff = YES;
				self.isSettingPickup = NO;
				[self.searchTable setContentOffset:CGPointMake(0, 115) animated:YES];
				[self didTapCalendarButton:self];
			}
		}
		else {
			self.isSettingDropoffLocation = YES;
			[self.pickupTextField resignFirstResponder];
			[self.countryPickerView setHidden:YES];
			[self.searchTable setScrollEnabled:NO];
			
			self.isSettingDropoff = YES;
			self.isSettingPickup = NO;
			[self.searchTable setContentOffset:CGPointMake(0, 180) animated:YES];
			[self didTapCalendarButton:self];
		}
	} else {
		if (indexPath.row == 0) {
			[self.countryPickerView setHidden:YES];
			[self.ageTextField becomeFirstResponder];
		}
	}
}

#pragma mark -
#pragma mark UIPickerViews

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	if (thePickerView == self.countryPicker) {
		return [self.preloadedCountryList count];
	} 
	else {
		return [self.preloadedCurrencyList count];
	}
}

- (NSString *) pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (thePickerView == self.countryPicker) {
		CTCountry *country = (CTCountry *)[self.preloadedCountryList objectAtIndex:row];
		return country.isoCountryName;
	} 
	else {
		CTCurrency *currency = (CTCurrency *)[self.preloadedCurrencyList objectAtIndex:row];
		return currency.currencyDisplayString;
	}
}

- (void) loadHomeCountryFromMemory { // call when reset is called or when SearchViewController starts
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];	
	NSString* isoCountryName = [prefs objectForKey:@"ctCountry.isoCountryName"];
	NSString* isoCountryCode = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	NSString* isoDialingCode = [prefs objectForKey:@"ctCountry.isoDialingCode"];
	
	self.ctCountry = [[CTCountry alloc] initWithIsoCountryName:isoCountryName isoCountryCode:isoCountryCode andIsoDialingCode:isoDialingCode];
	
	self.session.homeCountry = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	
	if (self.ctCountry.isoCountryName != nil) {
		[self.countryLabel setText:self.ctCountry.isoCountryName];
		self.homeCountryCode = self.ctCountry.isoCountryCode;
		[self.session setHomeCountry:self.ctCountry.isoCountryCode];
	}
}

- (void) updateFieldColors{
	[self.pickupTextField setTextColor:placeholderTextColor];
	[self.dropoffTextField setTextColor:placeholderTextColor];
	[self.pickupDateLabel setTextColor:placeholderTextColor];
	[self.dropoffDateLabel setTextColor:placeholderTextColor];
	[self.ageTextField setTextColor:placeholderTextColor];
	
	if (self.session.puLocationCode!=nil)
		[self.pickupTextField setTextColor:fieldTextColor];
	if (self.session.doLocationCode!=nil)
		[self.dropoffTextField setTextColor:fieldTextColor];
	if (self.session.puDateTime!=nil && self.pickupDateSet)
		[self.pickupDateLabel setTextColor:fieldTextColor];
	if (self.session.doDateTime!=nil && self.dropoffDateSet)
		[self.dropoffDateLabel setTextColor:fieldTextColor];
	if (self.session.driverAge!=nil)
		[self.ageTextField setTextColor:fieldTextColor];
	
	[self updateAccessoryViewsInTableView];
}

- (void) saveUserPrefs {
	if (self.ctSearchDefaults!=nil){
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

		self.ctSearchDefaults.lastPickupLocation = self.pickupTextField.text;
		self.ctSearchDefaults.lastDropoffLocation = self.dropoffTextField.text;
		self.ctSearchDefaults.lastPickupDate = self.session.puDateTime;
		self.ctSearchDefaults.lastDropoffDate = self.session.doDateTime;
		self.ctSearchDefaults.lastAge = self.session.driverAge;
		
		[prefs setObject:self.ctSearchDefaults.lastPickupLocation forKey:@"ctSearchDefaults.lastPickupLocation"];
		[prefs setObject:self.ctSearchDefaults.lastDropoffLocation forKey:@"ctSearchDefaults.lastDropoffLocation"];
		[prefs setObject:self.ctSearchDefaults.lastPickupDate forKey:@"ctSearchDefaults.lastPickupDate"];
		[prefs setObject:self.ctSearchDefaults.lastDropoffDate forKey:@"ctSearchDefaults.lastDropoffDate"];
		[prefs setObject:self.ctSearchDefaults.lastAge forKey:@"ctSearchDefaults.lastAge"];
		
		[prefs synchronize];
	}
}

- (void) loadUserPrefs {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	self.ctSearchDefaults = [[CTSearchDefaults alloc] init];
	self.ctSearchDefaults.lastAge = [prefs objectForKey:@"ctSearchDefaults.lastAge"];	

	self.session.homeCountry = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	if (self.ctSearchDefaults.lastAge!=nil){
		self.ageTextField.text = self.ctSearchDefaults.lastAge;
		self.session.driverAge = self.ctSearchDefaults.lastAge;
	}
	
	self.session.activeCurrency = [prefs objectForKey:@"ctCountry.currencyCode"];
	//[c release];
	
	[self updateFieldColors];
}

- (void) showAccessoryTickForCell:(UITableViewCell*)cell withValue:(NSString*)value enabled:(BOOL)enabled {
	UIImage *tickImage = [UIImage imageNamed:@"includedIcon.png"];
	UIImage *graytickImage = [UIImage imageNamed:@"grayIncludedIcon.png"];
	if ([value isEqualToString:@"button"]) {
		DLog(@"You can haz button");
		[self.showMapButton addTarget:self action:@selector(showMapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self.showMapButton setTag:cell.tag];
		cell.accessoryView = self.showMapButton;
	} else {
		if (value!=nil){
			if(enabled)
				cell.accessoryView = [[UIImageView alloc] initWithImage:tickImage];
			else
				cell.accessoryView = [[UIImageView alloc] initWithImage:graytickImage];
			[cell.accessoryView popIn:0.5f delegate:self];	
		} else {
			cell.accessoryView = nil;
		}
	}
}

- (void) updateAccessoryViewsInTableView {
	
	UITableViewCell *cell;
	
	cell = [self.searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:self.session.puLocationCode enabled:self.pickupLocationSet];
	cell = [self.searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:self.session.puDateTime enabled:self.pickupDateSet];
	cell = [self.searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	[self showAccessoryTickForCell:cell withValue:self.session.doLocationCode enabled:self.dropoffLocationSet];
	cell = [self.searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
	[self showAccessoryTickForCell:cell withValue:self.session.doDateTime enabled:self.dropoffDateSet];
	cell = [self.searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
	[self showAccessoryTickForCell:cell withValue:self.session.driverAge enabled:YES];
	
}

#pragma mark -
#pragma mark showMapButtonPressed

- (void) showMapButtonPressed:(id)sender {
	UIButton *btn = (UIButton *)sender;
	DLog(@"Tag is %li", (long)btn.tag);
	[self.pickupTextField resignFirstResponder];
	[self.dropoffTextField resignFirstResponder];
	
	MapSearchViewController *msvc = [[MapSearchViewController alloc] init];
	[msvc setModalMode:YES];
	[msvc setReferringFieldValue:btn.tag];
	if (btn.tag == 0) {
		// Pick up
	} else {
		// Drop off
		self.searchingAlternateDropOffLocationFromMapView = YES;
		self.isSelectingByMap = YES;
	}

	[self presentViewController:msvc animated:YES  completion:nil];
	//[msvc release];
	
}

@end
