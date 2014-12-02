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

@implementation SearchViewController

@synthesize showDOMapButton;
@synthesize showMapButton;
@synthesize setFromLocations;
@synthesize ctSearchDefaults;
@synthesize ctCountry;
@synthesize isSettingDropoffLocation;
@synthesize selectedNearbyLocation;
@synthesize session;
@synthesize isFromNearbySearch;
@synthesize isFromCitySearch;
@synthesize isFromAirportSearch;
@synthesize formattedPickupString;
@synthesize formattedDropoffString;
@synthesize isSettingPickup;
@synthesize isSettingDropoff;
@synthesize pickUpLocationName;
@synthesize dropOffLocationName;
@synthesize pickUpDateTime;
@synthesize returnDateTime;
@synthesize pickUpLocationCode;
@synthesize returnLocationCode;
@synthesize driverAge;
@synthesize passengerQty;
@synthesize homeCountryCode;
@synthesize footerView;
@synthesize countryPickerView;
@synthesize currencyPickerView;
@synthesize preloadedCurrencyList;
@synthesize countryPicker;
@synthesize currencyPicker;
@synthesize headerView;
@synthesize pickupDateSet;
@synthesize dropoffDateSet;
@synthesize pickupLocationSet;
@synthesize dropoffLocationSet;
@synthesize pickupDateLabel;
@synthesize dropoffDateLabel;
@synthesize calendarView;
@synthesize showListNow;
@synthesize canShowList;
@synthesize selectLocationView;
@synthesize preloadedLocations;
@synthesize preloadedCountryList;
@synthesize alternateLocationFooterView;
@synthesize alternativeBtn;
@synthesize alternateDrop;
@synthesize dateDisplayLabel;
@synthesize pickerModeLabel;
@synthesize timePicker;
@synthesize pickerView;
@synthesize containerView;
@synthesize pickupTextField;
@synthesize dropoffTextField;
@synthesize ageTextField;
@synthesize searchTable;
@synthesize frontViewIsVisible;
@synthesize numberOfPassengersTextField;
@synthesize theDateFromPicker;
@synthesize dismissLocationPopUpButton;

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
	[searchTable setContentOffset:CGPointMake(0, -3) animated:YES];
	
	[searchTable setScrollEnabled:YES];
}

#pragma mark -
#pragma mark Create Views

- (void) viewDidUnload {
	self.selectedNearbyLocation = nil;
	self.session = nil;
	self.formattedPickupString = nil;
	self.formattedDropoffString = nil;
	self.pickUpLocationName = nil;
	self.dropOffLocationName = nil;
	self.pickUpDateTime = nil;
	self.returnDateTime = nil;
	self.pickUpLocationCode = nil;
	self.returnLocationCode = nil;
	self.driverAge = nil;
	self.passengerQty = nil;
	self.homeCountryCode = nil;
	self.footerView = nil;
	self.countryPickerView = nil;
	self.currencyPickerView = nil;
	self.preloadedCurrencyList = nil;
	self.countryPicker = nil;
	self.currencyPicker = nil;
	self.headerView = nil;
	self.pickupDateLabel = nil;
	self.dropoffDateLabel = nil;
	self.calendarView = nil;
	self.selectLocationView = nil;
	self.preloadedLocations = nil;
	self.preloadedCountryList = nil;
	self.alternateLocationFooterView = nil;
	self.alternativeBtn = nil;
	self.dateDisplayLabel = nil;
	self.pickerModeLabel = nil;
	self.timePicker = nil;
	self.pickerView = nil;
	self.containerView = nil;
	self.searchTable = nil;
	self.pickupTextField = nil;
	self.dropoffTextField = nil;
	self.ageTextField = nil;
	self.numberOfPassengersTextField = nil;
	[super viewDidUnload];
}

#pragma mark -
#pragma mark UIView Annimations

- (void) resetListView {
	DLog(@"Resetting list to hidden = YES");
	[selectLocationView setHidden:YES];
	[llvc.filteredResults removeAllObjects];
}

- (void) fadeViewIn {
	DLog(@"Showing List View");
	dismissLocationPopUpButton.hidden = NO;
	searchTable.scrollEnabled = NO;
	[selectLocationView setAlpha:0.0];
	[selectLocationView setHidden:NO];
	
	[UIView beginAnimations:@"moveViewIn" context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	[selectLocationView setAlpha:1.0];
	
	[UIView commitAnimations];
	
	[self.view bringSubviewToFront:selectLocationView];
}
	
- (void) fadeViewOut {
	DLog(@"Hiding List View");
	dismissLocationPopUpButton.hidden = YES;
	searchTable.scrollEnabled = YES;
	[UIView beginAnimations:@"moveViewOut" context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDidStopSelector:@selector(resetListView)];
	
	[selectLocationView setAlpha:0.0];
	[llvc.filteredResults removeAllObjects];
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
	[session printSession];
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
		srvc.session = session;
		
		[self.navigationController pushViewController:srvc animated:YES];
	}
	else 
	{
		// No response
	}
}

- (void) makeRequest {
	session.numPassengers = @"1";
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// The following few lines detect the locale code should it either not have been set or discovered by the app.
	// If the pref is there but not hooked up, put it in. Otherwise, it means it hasn't and is hasn't been explicitly set by the user
	// (the key wouldn't be nil if it was) so detect and insert. If all that fails, pop the message and tell the user to set your home country.
    
	if ([prefs objectForKey:@"ctCountry.isoCountryCode"]) {
		session.homeCountry = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	} else {
		session.homeCountry = [CTHelper getLocaleCode];
	}
    
	[self saveUserPrefs];
	
	if (session.puLocationCode == NULL) {
		[self springAlert:@"Pickup location not set" message:@"Please set a pickup location."];
	} else if (session.puDateTime == NULL) {
		[self springAlert:@"Pickup time not set" message:@"Please set the time you wish to pickup your vehicle."];
	} else if (session.doLocationCode == NULL) {
		[self springAlert:@"Drop off location not set" message:@"Please set a drop off location."];
	} else if (session.doDateTime == NULL) {
		[self springAlert:@"Dropoff time not set" message:@"Please set the time when you would like to drop off your vehicle."];
	} else if (session.driverAge == NULL) {
		[self springAlert:@"Driver Age not set" message:@"Please set the driver's age."];
	} else if (session.homeCountry == NULL) {
		[self springAlert:@"Home Country not set." message:@"Please set your country from the home screen."];
	} else if (![ageTextField.text isEqualToString:session.driverAge]) {
		
		// This test is here in case a user has an age already set but the text box has been left blank by accident.
		
		session.driverAge = nil;
		[self springAlert:@"Driver Age not set" message:@"Please set the driver's age."];
		
		// Do we want to nuke the age key in prefs also at this point?
		
	} else {
		hud = [[CTHudViewController alloc] initWithTitle:@"Searching"];
		[hud show];
		[session printSession];
        
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
	session.numPassengers = @"1";
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// The following few lines detect the locale code should it either not have been set or discovered by the app.
	// If the pref is there but not hooked up, put it in. Otherwise, it means it hasn't and is hasn't been explicitly set by the user
	// (the key wouldn't be nil if it was) so detect and insert. If all that fails, pop the message and tell the user to set your home country.
    
	if ([prefs objectForKey:@"ctCountry.isoCountryCode"]) {
		session.homeCountry = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	} else {
		session.homeCountry = [CTHelper getLocaleCode];
	}
    
	[self saveUserPrefs];
	
	if (session.puLocationCode == NULL) {
		[self springAlert:@"Pickup location not set" message:@"Please set a pickup location."];
	} else if (session.puDateTime == NULL) {
		[self springAlert:@"Pickup time not set" message:@"Please set the time you wish to pickup your vehicle."];
	} else if (session.doLocationCode == NULL) {
		[self springAlert:@"Drop off location not set" message:@"Please set a drop off location."];
	} else if (session.doDateTime == NULL) {
		[self springAlert:@"Dropoff time not set" message:@"Please set the time when you would like to drop off your vehicle."];
	} else if (session.driverAge == NULL) {
		[self springAlert:@"Driver Age not set" message:@"Please set the driver's age."];
	} else if (session.homeCountry == NULL) {
		[self springAlert:@"Home Country not set." message:@"Please set your country from the home screen."];
	} else if (![ageTextField.text isEqualToString:session.driverAge]) {
		
		// This test is here in case a user has an age already set but the text box has been left blank by accident.
		
		session.driverAge = nil;
		[self springAlert:@"Driver Age not set" message:@"Please set the driver's age."];
		
		// Do we want to nuke the age key in prefs also at this point?
		
	} else {
		hud = [[CTHudViewController alloc] initWithTitle:@"Searching"];
		[hud show];
		[session printSession];
        
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
	[llvc.spinner setHidden:NO];
	[llvc.spinner startAnimating];

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
	[llvc updateResults:[CTHelper validatePredictiveLocationsResponse:responseDict]];
	[llvc.spinner stopAnimating];
	[llvc.spinner setHidden:YES];
}

- (void) partialLocationRequestFailed:(ASIHTTPRequest *) request {
	DLog(@"Pre-fetch request failed");
	[llvc.spinner stopAnimating];
	[llvc.spinner setHidden:YES];
}

#pragma mark -
#pragma mark Notification Consumption

- (void) ctLocationSelected:(NSNotification *)notify {
	id ndict = [notify userInfo];
	if ([ndict objectForKey:@"selectedLocation"]) {
		CTLocation *loc = [ndict objectForKey:@"selectedLocation"];
		if(!isSelectingByMap) {
			
			[self fadeViewOut];
			
		} else {
			[self dismissViewControllerAnimated:YES completion:nil];
			isSelectingByMap = NO;
		}
		
		if (isSettingDropoffLocation) {
			dropoffTextField.text = [loc.locationName capitalizedString];
			
			// Set the strings for the search parameter.
			self.dropOffLocationName = [NSString stringWithString:[loc.locationName capitalizedString]];
			self.returnLocationCode = [NSString stringWithString:loc.locationCode];
			
			[self.session setDoLocationCode:[NSString stringWithString:loc.locationCode]];
			[self.session setDoLocationNameString:loc.locationName];
			[self.session setDoLocation:loc];
			[dropoffTextField resignFirstResponder];
			dropoffLocationSet = YES;
			isSettingDropoffLocation = NO;
			
		} else {
			
			if (searchingAlternateDropOffLocationFromMapView) {
				
				searchingAlternateDropOffLocationFromMapView = NO;
				dropoffTextField.text = [loc.locationName capitalizedString];
				DLog(@"setting alternate drop off loc only;"); 
				
				// Set the strings for the search parameter.
				
				self.dropOffLocationName = [NSString stringWithString:[loc.locationName capitalizedString]];
				self.returnLocationCode = [NSString stringWithString:loc.locationCode];
				
				[self.session setDoLocationCode:[NSString stringWithString:loc.locationCode]];
				[self.session setDoLocationNameString:loc.locationName];
				[self.session setDoLocation:loc];
				[pickupTextField resignFirstResponder];// dnt think this is needed
				[dropoffTextField resignFirstResponder];
				
			} else {
				
				pickupTextField.text = [loc.locationName capitalizedString];
				[pickupTextField setTextColor:[UIColor redColor]];
				
				// Set the strings for the search parameter.
				self.pickUpLocationName = [NSString stringWithString:[loc.locationName capitalizedString]];
				self.pickUpLocationCode = [NSString stringWithString:loc.locationCode];
				
				[self.session setPuLocationCode:[NSString stringWithString:loc.locationCode]];
				[self.session setPuLocationNameString:loc.locationName];
				[self.session setPuLocation:loc];
				
				if (!dropoffLocationSet){
					//if not set, use pickup for droppoff
					dropoffTextField.text = [loc.locationName capitalizedString];
					self.dropOffLocationName = [NSString stringWithString:[loc.locationName capitalizedString]];
					self.returnLocationCode = [NSString stringWithString:loc.locationCode];
					
					self.session.doLocationCode = loc.locationCode;
					[self.session setDoLocationNameString:loc.locationName];
					[self.session setDoLocation:loc];
				}
				
				[pickupTextField resignFirstResponder];
				pickupLocationSet = YES;
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
	self.pickUpLocationCode = selectedNearbyLocation.locationCode;
	self.pickUpLocationName = selectedNearbyLocation.locationName;
	[self.session setPuLocationNameString:selectedNearbyLocation.locationName];
	[self.session setPuLocation:selectedNearbyLocation];
	
	self.dropOffLocationName = selectedNearbyLocation.locationName;
	self.returnLocationCode = selectedNearbyLocation.locationCode;
	[self.session setDoLocationNameString:selectedNearbyLocation.locationName];
	[self.session setDoLocation:selectedNearbyLocation];
	
	pickupTextField.text = selectedNearbyLocation.locationName;
	dropoffTextField.text = selectedNearbyLocation.locationName;
	
	session.puLocationCode = selectedNearbyLocation.locationCode;
	session.doLocationCode = selectedNearbyLocation.locationCode;
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
	session.homeCountry = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	self.session.activeCurrency = [prefs objectForKey:@"ctCountry.currencyCode"];
}

- (void) viewDidLoad {
    
    CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationItem.rightBarButtonItem.tintColor = appDelegate.governingTintColor;
    
	if (session) {
		self.session = nil;
	}
	self.session = [[RentalSession alloc] init];
	
    
	// We still need to specify the title for the next navcontroller's back button.
	self.title = NSLocalizedString(@"Search", nil);
	self.navigationItem.titleView = [CTHelper getNavBarLabelWithTitle:NSLocalizedString(@"Search", nil)];
	
	[searchTable setContentInset:UIEdgeInsetsMake(3,0,0,0)];
	
	dismissLocationPopUpButton = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 200.0)];
	dismissLocationPopUpButton.hidden = YES;
	[dismissLocationPopUpButton addTarget:self action:@selector(dismissLocationPopup) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:dismissLocationPopUpButton];
	//[dismissLocationPopUpButton release];
	
	self.preloadedCountryList = appDelegate.preloadedCountryList;
	
	ctCountry = [[CTCountry alloc] init];
	
	UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleDone target:self action:@selector(clearData:)];
	self.navigationItem.rightBarButtonItem = resetButton;
	//[resetButton	release];
	
	driverAge = [[NSString alloc] init];
	passengerQty = [[NSString alloc] init];
	
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ctLocationSelected:) name:@"CTLocationSelected" object:nil];
	
	self.searchTable.backgroundColor = [UIColor clearColor];
    self.searchTable.backgroundView = nil;
	
	self.frontViewIsVisible = YES;
	
	[containerView setHidden:YES];
	[selectLocationView setHidden:YES];
	[countryPickerView setHidden:YES];
	[currencyPickerView setHidden:YES];
	
	llvc = [[LocationListViewController alloc] initWithNibName:@"LocationListViewController" bundle:nil];
	[selectLocationView addSubview:llvc.view];
	
	canShowList = YES;
	showListNow = NO;
	
	pickupTextField = [self newTextField];
	pickupTextField.placeholder = kPickUpTextPlaceHolder;
	[pickupTextField setTextColor:placeholderTextColor];

	dropoffTextField = [self newTextField];
	dropoffTextField.placeholder = kDropOffTextPlaceHolder;
	[dropoffTextField setTextColor:placeholderTextColor];
	
	pickupDateLabel = [self newLabel];
	pickupDateLabel.text = kPickupLabelPlaceHolder;
	[pickupDateLabel setTextColor:placeholderTextColor];
	
	dropoffDateLabel = [self newLabel];
	dropoffDateLabel.text = kDropOffLabelPlaceHolder;
	[dropoffDateLabel setTextColor:placeholderTextColor];
	
	countryLabel = [self newLabel];
	countryLabel.text = @"Country of residence";
	
	ageTextField = [self newTextField];
	ageTextField.placeholder = kAgeTextPlaceHolder;
	[ageTextField setTextColor:placeholderTextColor];
	
	numberOfPassengersTextField = [self newTextField];
	numberOfPassengersTextField.text = kNumberOfPassengersTextHolder;
	
	alternateDrop = YES;
	isSettingDropoffLocation = NO;
	
	//[self checkCurrentMode];
	[self loadHomeCountryFromMemory];
	[self loadUserPrefs];
	
	if (setFromLocations) {
		// This has been set from the Locations map. It will populate the selected CTLocation into the location fields.
		[self setLocationFromMap];
		[self updateFieldColors];
	}
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	DLog(@"Memory Warning?");
}

- (void) dealloc {
    /*
	[llvc release];
	[searchTable release];
	[pickupTextField release];
	[dropoffTextField release];
	[ageTextField release];
	[containerView release];
	[pickerView release];
	[timePicker release];
	[dateDisplayLabel release];
	[pickerModeLabel release];
	[alternativeBtn release];
	[alternateLocationFooterView release];
	[preloadedLocations release];
	[preloadedCountryList release];
	[selectLocationView release];
	[calendarView release];
	[pickupDateLabel release];
	[dropoffDateLabel release];
	[headerView release];
	[countryPicker release];
	[currencyPicker release];
	[preloadedCurrencyList release];
	[countryPickerView release];
	[currencyPickerView release];
	[footerView release];
	[pickUpDateTime release];
	[returnDateTime release];
	[pickUpLocationCode release];
	[returnLocationCode release];
	[driverAge release];
	[passengerQty release];
	[homeCountryCode release];
	[numberOfPassengersTextField release];
	[pickUpLocationName release];
	[dropOffLocationName release];
	[formattedPickupString release];
	[formattedDropoffString release];


	[session release];
	[selectedNearbyLocation release];

	[showMapButton release];
	showMapButton = nil;

	[showDOMapButton release];
	showDOMapButton = nil;

    [super dealloc]; */
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
	
	if (isSettingPickup) 
	{
		self.formattedPickupString = [NSString stringWithFormat:@"%@T%@:00", [apiFormat stringFromDate:timePicker.date], [UStimeFormat stringFromDate:timePicker.date]];
		[self.session setPuDateTime:formattedPickupString];
		
		[pickupDateLabel setText:[NSString stringWithFormat:@"%@ %@", [dateFormat stringFromDate:timePicker.date], [timeFormat stringFromDate:timePicker.date]]];
		[self.session setReadablePuDateTimeString:pickupDateLabel.text];
		
		if (isSettingPickup && !dropoffDateSet)
		{
			NSTimeInterval selectedDate = [timePicker.date timeIntervalSince1970];
			//double secondsSinceMidnight = fmod(selectedDate, 86400); //number of seconds since midnight today
			double secondsInADay = 24*60*60;
            
			//double secondsFromMidnightToTenAM = 10*60*60;
			//NSDate *earliestDropoffDate = [NSDate dateWithTimeIntervalSinceReferenceDate:(selectedDate - secondsSinceMidnight + secondsInADay + secondsFromMidnightToTenAM)];
			NSDate *earliestDropoffDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)((double)selectedDate + (double)secondsInADay) ];

			session.endDate = earliestDropoffDate;
			[dropoffDateLabel setText:[NSString stringWithFormat:@"%@ %@", [dateFormat stringFromDate:earliestDropoffDate], [timeFormat stringFromDate:earliestDropoffDate]]];
			[self.session setDoDateTime:[NSString stringWithFormat:@"%@T%@:00", [apiFormat stringFromDate:earliestDropoffDate], [UStimeFormat stringFromDate:earliestDropoffDate]]];
			[self.session setReadableDoDateTimeString:dropoffDateLabel.text];
		}
		session.startDate = timePicker.date;
	}
	if (isSettingDropoff) 
	{
		self.formattedDropoffString = [NSString stringWithFormat:@"%@T%@:00", [apiFormat stringFromDate:timePicker.date], [UStimeFormat stringFromDate:timePicker.date]];

		[self.session setDoDateTime:formattedDropoffString];
		
		[dropoffDateLabel setText:[NSString stringWithFormat:@"%@ %@", [dateFormat stringFromDate:timePicker.date], [timeFormat stringFromDate:timePicker.date]]];
		session.endDate = timePicker.date;
		
		[self.session setReadableDoDateTimeString:dropoffDateLabel.text];
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
	if (isSettingPickup){
		pickupDateSet = YES;
		isSettingPickup = NO;
	}
	if (isSettingDropoff){
		dropoffDateSet = YES;
		isSettingDropoff = NO;
	}

	[containerView setHidden:YES];
	frontViewIsVisible =! frontViewIsVisible;
	[self resetTableOffset];
	[self updateFieldColors];
}

#pragma mark -
#pragma mark Show Views or View Controllers

- (void) myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	// re-enable user interaction when the flip is completed.
	//containerView.userInteractionEnabled = YES;
	//flipIndicatorButton.userInteractionEnabled = YES;
}

- (void) flipCurrentView {
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"HH:mm"]; 
	NSDate *now = [NSDate date];
	


	if ((theDateFromPicker == nil) && (frontViewIsVisible) )
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please try again" message:@"In order to search for available cars, please choose a date in the future." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		//[alertView release];
		return;
	}
	else if ([theDateFromPicker compare:now] == NSOrderedDescending) 
	{
		theDateFromPicker = nil;
	} 
	else if (frontViewIsVisible)
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
    if (frontViewIsVisible) 
	{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];
        [calendarView removeFromSuperview];
        [containerView addSubview:pickerView];
    } 
	else 
	{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];
        [pickerView removeFromSuperview];
        [containerView addSubview:calendarView];
    }
	[UIView commitAnimations];
	
	frontViewIsVisible =! frontViewIsVisible;
}

- (void) showCalendarAndTimePickerViews {
	// Calendar View
	[ageTextField resignFirstResponder];
	[numberOfPassengersTextField resignFirstResponder];
	[pickupTextField resignFirstResponder];
	[dropoffTextField resignFirstResponder];
	
	// Time Picker View
	
	pickerView = [[UIView alloc] initWithFrame:CGRectMake(2.0, 0.0, 312.0, 280.0)];
	pickerView.clipsToBounds = YES;
	timePicker.frame = CGRectMake(0, 60, 312, 216);

	timePicker.datePickerMode = UIDatePickerModeDateAndTime;
	timePicker.minuteInterval = 15;

	NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
	double secondsSinceMidnight = fmod(now, 86400); //number of seconds since midnight today
	double secondsInADay = 24*60*60;
	double secondsFromMidnightToTenAM = 10*60*60;
	NSDate *earliestPickupDate = [NSDate dateWithTimeIntervalSinceReferenceDate:(now - secondsSinceMidnight + secondsInADay + secondsFromMidnightToTenAM)];

	NSDate *earliestDropoffDate;
	
	if (pickupDateSet){
		NSTimeInterval pickupDateInterval = [session.startDate timeIntervalSinceReferenceDate];
		secondsSinceMidnight = fmod(pickupDateInterval, 86400);
		earliestDropoffDate = [NSDate dateWithTimeIntervalSinceReferenceDate:(pickupDateInterval + secondsInADay * 1)];
	}
	else {
		earliestDropoffDate = [NSDate dateWithTimeIntervalSinceReferenceDate:(now - secondsSinceMidnight + secondsInADay * 2)];
	}
		

	[timePicker removeTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];

	if (isSettingPickup){
		if (!pickupDateSet) {
			[timePicker setDate:earliestPickupDate];
		}
		[timePicker setMinimumDate:earliestPickupDate];
	}
	if (isSettingDropoff){
		if (!dropoffDateSet) {
			[timePicker setDate:earliestDropoffDate];
		}
		[timePicker setMinimumDate:earliestDropoffDate];
	}
	
	[pickerView addSubview:timePicker];
	[timePicker addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
    [timePicker setBackgroundColor:[UIColor whiteColor]];
	
	UIImageView *pickerOutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerPopOver.png"]];
	[pickerView addSubview:pickerOutline];
	[pickerView bringSubviewToFront:pickerOutline];
    [pickerView setBackgroundColor:[UIColor clearColor]];
	
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(255, 25, 50, 30);
    [doneButton addTarget:self action:@selector(saveDateAndTime) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:doneButton];
	
	[containerView addSubview:pickerView];
	[containerView setHidden:NO];
}

#pragma mark -
#pragma mark IBActions

- (void) dismissCalendarAndPickerViews {
	[containerView setHidden:YES];
	frontViewIsVisible = YES;
	[self resetTableOffset];
}

- (IBAction) clearData:(id)sender {
	
	[self dismissCalendarAndPickerViews];
	[pickupTextField resignFirstResponder];
	[dropoffTextField resignFirstResponder];
	[ageTextField resignFirstResponder];
	
	pickupTextField.placeholder = kPickUpTextPlaceHolder;
	pickupTextField.text = @"";
	dropoffTextField.placeholder = kDropOffTextPlaceHolder;
	dropoffTextField.text = @"";
	pickupDateLabel.text = kPickupLabelPlaceHolder;
	dropoffDateLabel.text = kDropOffLabelPlaceHolder;
	countryLabel.text = @"Country of residence";
	ageTextField.placeholder = kAgeTextPlaceHolder;
	ageTextField.text = kAgeTextPlaceHolder;
	numberOfPassengersTextField.text = kNumberOfPassengersTextHolder;
	
	alternateDrop = YES;
	searchingAlternateDropOffLocationFromMapView = NO;
	isSettingDropoffLocation = NO;
	pickupLocationSet = NO;
	dropoffLocationSet = NO;
	pickupDateSet = NO;
	dropoffDateSet = NO;

	theDateFromPicker = nil;
	pickUpDateTime = nil;
	returnDateTime = nil;
	pickUpLocationCode = nil;
	pickUpLocationName = nil;
	dropOffLocationName = nil;
	returnLocationCode = nil;
	driverAge = nil;
	passengerQty = nil;
	homeCountryCode = nil;
	formattedPickupString = nil;
	formattedDropoffString = nil;
	
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
	if (textField == pickupTextField) {
		
		searchingAlternateDropOffLocationFromMapView = NO;
		pickupTextField.text = @"";
		[searchTable setContentOffset:CGPointMake(0, 30) animated:YES];
		[searchTable setScrollEnabled:NO];
		canShowList = YES;
		
	} else if (textField == dropoffTextField) {
		
		searchingAlternateDropOffLocationFromMapView= NO;
		isSettingDropoffLocation = YES;
		dropoffTextField.text = @"";
		[searchTable setContentOffset:CGPointMake(0, 130) animated:YES];
		[searchTable setScrollEnabled:NO];
		canShowList = YES;
		
	} else if (textField == numberOfPassengersTextField) {
		
		numberOfPassengersTextField.text = @"";
		[searchTable setContentOffset:CGPointMake(0, 186) animated:YES];
		
	} else if (textField == ageTextField) {
		ageTextField.text = @"";
		if (alternateDrop ) {
			[searchTable setContentOffset:CGPointMake(0, 130) animated:YES];
		} else {
			[searchTable setContentOffset:CGPointMake(0, 130) animated:YES];
		}
	} 
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered {
	if (textField == pickupTextField) {
		isSelectingByMap = NO;
		NSString *searchTerm = [NSString stringWithFormat:@"%@%@", pickupTextField.text, textEntered];
		if ([searchTerm length] >= 3) {
			
			[self searchLocationsByString:searchTerm];

			if (canShowList) {
				[self fadeViewIn];
			}
			canShowList = NO;
			
		} else if ([searchTerm length] < 3) {
			canShowList = YES;
			[self fadeViewOut];
		}
	}
	if (textField == dropoffTextField) {
		NSString *searchTerm = [NSString stringWithFormat:@"%@%@", dropoffTextField.text, textEntered];
		if ([searchTerm length] > 2) {
			[self searchLocationsByString:searchTerm];
			if (canShowList) {
				[self fadeViewIn];
			}
			canShowList = NO;
			
		} else if ([searchTerm length] == 2) {
			[self searchLocationsByString:searchTerm];
			canShowList = YES;
			[self fadeViewOut];
		} else if ([searchTerm length] < 2) {
			canShowList = YES;
			[self fadeViewOut];
		}
	}
	if (textField == ageTextField) {
		NSString *combinedString = [NSString stringWithFormat:@"%@%@", ageTextField.text, textEntered];
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

			[ageTextField setText:combinedString];
			
			self.driverAge = [NSString stringWithString:combinedString];
			[self.session setDriverAge:driverAge];
			[ageTextField resignFirstResponder];
			[self resetTableOffset];
			[self updateFieldColors];
		}
	}
	if (textField == numberOfPassengersTextField) {
		NSString *combinedString = [NSString stringWithFormat:@"%@%@", numberOfPassengersTextField.text, textEntered];
		if ([combinedString length] == 1) {
			[numberOfPassengersTextField setText:combinedString];
			
			self.passengerQty = [NSString stringWithString:combinedString];
			[self.session setNumPassengers:passengerQty];
			[numberOfPassengersTextField resignFirstResponder];
		}
	}
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	if (textField == pickupTextField || textField == dropoffTextField || textField == ageTextField) {
		[textField resignFirstResponder];
		[self fadeViewOut];
		[self resetTableOffset];
		
		// This takes either the pickup or dropoff textfields and will dump the map button from the accessory view when the editing 
		// stops in that textfield.
		
		UITableViewCell *cell;
		if (textField == pickupTextField) {
			cell = [searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];	
		} else {
			cell = [searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
		}
		cell.accessoryView = nil;
		
		if (textField == dropoffTextField && pickupLocationSet) {
			dropoffTextField.text = pickupTextField.text;
			
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
	searchingAlternateDropOffLocationFromMapView = NO;
	MapSearchViewController *mvc = [[MapSearchViewController alloc] init];
	isSelectingByMap = YES;
	[self presentViewController:mvc animated:YES completion:nil];
	//[mvc release];
}

- (void) didTapAlternateLocationButton:(id) sender {
	DLog(@"Did tap Alternate location button")
	searchingAlternateDropOffLocationFromMapView = YES;
	MapSearchViewController *mvc = [[MapSearchViewController alloc] init];
	isSelectingByMap = YES;
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
		if (alternateDrop)
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
			pickupTextField.placeholder = @"Pickup Location";
			
			if (pickupTextField.text==nil) {
				[self realignFieldInCell:pickupTextField];
			}
			
			[pickupTextField setKeyboardType:UIKeyboardTypeDefault];
			[cell.contentView addSubview:pickupTextField];
			
			if (setFromLocations) {
				[self showAccessoryTickForCell:cell withValue:self.session.puLocationCode enabled:pickupLocationSet];
			}
			
			[showMapButton addTarget:self action:@selector(showMapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[showMapButton setTag:0];
			[showMapButton setFrame:CGRectMake(4, 2, showMapButton.bounds.size.width, showMapButton.bounds.size.height)];
			[cell.contentView addSubview:showMapButton];
			
		} else {
			[cell setFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, 10.0)];
			[cell.contentView addSubview:pickupDateLabel];
			
			UIImageView *calIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cal_icon.png"]];
			[calIcon setFrame:CGRectMake(10, 5, calIcon.bounds.size.width, calIcon.bounds.size.height)];
			[cell.contentView addSubview:calIcon];
			//[calIcon release];
		} 

	} else if (section == 1) {
		if (row == 0) {
			dropoffTextField.enabled = YES;
			dropoffTextField.placeholder = @"Dropoff Location";
			
			if (dropoffTextField.text == nil) {
				[self realignFieldInCell:dropoffTextField];
			}
				
			[cell.contentView addSubview:dropoffTextField];
			
			if (setFromLocations) {
				[self showAccessoryTickForCell:cell withValue:self.session.doLocationCode enabled:dropoffLocationSet];
			}
			
			[showDOMapButton addTarget:self action:@selector(showMapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[showDOMapButton setTag:1];
			[showDOMapButton setFrame:CGRectMake(4, 0, showDOMapButton.bounds.size.width, showDOMapButton.bounds.size.height)];
			[cell.contentView addSubview:showDOMapButton];
		} else {
			[cell setFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, 10.0)];
			[cell.contentView addSubview:dropoffDateLabel];
			
			UIImageView *calIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cal_icon.png"]];
			[calIcon setFrame:CGRectMake(10, 5, calIcon.bounds.size.width, calIcon.bounds.size.height)];
			[cell.contentView addSubview:calIcon];
			//[calIcon release];
		}
	} else {
		ageTextField.placeholder = @"Driver Age";
		
		if (ageTextField.text == nil){
			[self realignFieldInCell:ageTextField];
		}
			
		[ageTextField setKeyboardType:UIKeyboardTypeNumberPad];
		[cell.contentView addSubview:ageTextField];
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
			[pickupTextField becomeFirstResponder];
			[countryPickerView setHidden:YES];
		} else {
			[pickupTextField resignFirstResponder];
			
			[searchTable setScrollEnabled:NO];
			[countryPickerView setHidden:YES];
			
			isSettingDropoff = NO;
			isSettingPickup = YES;
			
			[searchTable setContentOffset:CGPointMake(0, 68) animated:YES];	
			[self didTapCalendarButton:self];
		} 
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			if (alternateDrop ) {
				[dropoffTextField becomeFirstResponder];
			 [countryPickerView setHidden:YES];
			} else {
				isSettingDropoffLocation = YES;
				[pickupTextField resignFirstResponder];
				[countryPickerView setHidden:YES];
				[searchTable setScrollEnabled:NO];
				
				isSettingDropoff = YES;
				isSettingPickup = NO;
				[searchTable setContentOffset:CGPointMake(0, 115) animated:YES];
				[self didTapCalendarButton:self];
			}
		}
		else {
			isSettingDropoffLocation = YES;
			[pickupTextField resignFirstResponder];
			[countryPickerView setHidden:YES];
			[searchTable setScrollEnabled:NO];
			
			isSettingDropoff = YES;
			isSettingPickup = NO;
			[searchTable setContentOffset:CGPointMake(0, 180) animated:YES];
			[self didTapCalendarButton:self];
		}
	} else {
		if (indexPath.row == 0) {
			[countryPickerView setHidden:YES];
			[ageTextField becomeFirstResponder];
		}
	}
}

#pragma mark -
#pragma mark UIPickerViews

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	if (thePickerView == countryPicker) {
		return [preloadedCountryList count];
	} 
	else {
		return [preloadedCurrencyList count];
	}
}

- (NSString *) pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (thePickerView == countryPicker) {
		CTCountry *country = (CTCountry *)[preloadedCountryList objectAtIndex:row];
		return country.isoCountryName;
	} 
	else {
		CTCurrency *currency = (CTCurrency *)[preloadedCurrencyList objectAtIndex:row];
		return currency.currencyDisplayString;
	}
}

- (void) loadHomeCountryFromMemory { // call when reset is called or when SearchViewController starts
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];	
	ctCountry.isoCountryName = [prefs objectForKey:@"ctCountry.isoCountryName"];
	ctCountry.isoCountryCode = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	ctCountry.isoDialingCode = [prefs objectForKey:@"ctCountry.isoDialingCode"];
	
	self.session.homeCountry = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	
	if (ctCountry.isoCountryName != nil) {
		[countryLabel setText:ctCountry.isoCountryName];
		self.homeCountryCode = ctCountry.isoCountryCode;
		[self.session setHomeCountry:ctCountry.isoCountryCode];
	}
}

- (void) updateFieldColors{
	[pickupTextField setTextColor:placeholderTextColor];
	[dropoffTextField setTextColor:placeholderTextColor];
	[pickupDateLabel setTextColor:placeholderTextColor];
	[dropoffDateLabel setTextColor:placeholderTextColor];
	[ageTextField setTextColor:placeholderTextColor];
	
	if (session.puLocationCode!=nil)
		[pickupTextField setTextColor:fieldTextColor];
	if (session.doLocationCode!=nil)
		[dropoffTextField setTextColor:fieldTextColor];
	if (session.puDateTime!=nil && pickupDateSet)
		[pickupDateLabel setTextColor:fieldTextColor];
	if (session.doDateTime!=nil && dropoffDateSet)
		[dropoffDateLabel setTextColor:fieldTextColor];
	if (session.driverAge!=nil)
		[ageTextField setTextColor:fieldTextColor];
	
	[self updateAccessoryViewsInTableView];
}

- (void) saveUserPrefs {
	if (ctSearchDefaults!=nil){
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

		ctSearchDefaults.lastPickupLocation = pickupTextField.text;
		ctSearchDefaults.lastDropoffLocation = dropoffTextField.text;
		ctSearchDefaults.lastPickupDate = session.puDateTime;
		ctSearchDefaults.lastDropoffDate = session.doDateTime;
		ctSearchDefaults.lastAge = session.driverAge;
		
		[prefs setObject:ctSearchDefaults.lastPickupLocation forKey:@"ctSearchDefaults.lastPickupLocation"];
		[prefs setObject:ctSearchDefaults.lastDropoffLocation forKey:@"ctSearchDefaults.lastDropoffLocation"];
		[prefs setObject:ctSearchDefaults.lastPickupDate forKey:@"ctSearchDefaults.lastPickupDate"];
		[prefs setObject:ctSearchDefaults.lastDropoffDate forKey:@"ctSearchDefaults.lastDropoffDate"];
		[prefs setObject:ctSearchDefaults.lastAge forKey:@"ctSearchDefaults.lastAge"];
		
		[prefs synchronize];
	}
}

- (void) loadUserPrefs {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	ctSearchDefaults = [[CTSearchDefaults alloc] init];
	ctSearchDefaults.lastAge = [prefs objectForKey:@"ctSearchDefaults.lastAge"];	

	session.homeCountry = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	if (ctSearchDefaults.lastAge!=nil){
		ageTextField.text = ctSearchDefaults.lastAge;
		session.driverAge = ctSearchDefaults.lastAge;
	}
	
	CTCountry *c = [[CTCountry alloc] init];
	c.currencyCode = [prefs objectForKey:@"ctCountry.currencyCode"];
	self.session.activeCurrency = c.currencyCode;
	//[c release];
	
	[self updateFieldColors];
}

- (void) showAccessoryTickForCell:(UITableViewCell*)cell withValue:(NSString*)value enabled:(BOOL)enabled {
	UIImage *tickImage = [UIImage imageNamed:@"includedIcon.png"];
	UIImage *graytickImage = [UIImage imageNamed:@"grayIncludedIcon.png"];
	if ([value isEqualToString:@"button"]) {
		DLog(@"You can haz button");
		[showMapButton addTarget:self action:@selector(showMapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[showMapButton setTag:cell.tag];
		cell.accessoryView = showMapButton;
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
	
	cell = [searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:self.session.puLocationCode enabled:pickupLocationSet];
	cell = [searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:self.session.puDateTime enabled:pickupDateSet];
	cell = [searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	[self showAccessoryTickForCell:cell withValue:self.session.doLocationCode enabled:dropoffLocationSet];
	cell = [searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
	[self showAccessoryTickForCell:cell withValue:self.session.doDateTime enabled:dropoffDateSet];
	cell = [searchTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
	[self showAccessoryTickForCell:cell withValue:self.session.driverAge enabled:YES];
	
}

#pragma mark -
#pragma mark showMapButtonPressed

- (void) showMapButtonPressed:(id)sender {
	UIButton *btn = (UIButton *)sender;
	DLog(@"Tag is %li", (long)btn.tag);
	[pickupTextField resignFirstResponder];
	[dropoffTextField resignFirstResponder];
	
	MapSearchViewController *msvc = [[MapSearchViewController alloc] init];
	[msvc setModalMode:YES];
	[msvc setReferringFieldValue:btn.tag];
	if (btn.tag == 0) {
		// Pick up
	} else {
		// Drop off
		searchingAlternateDropOffLocationFromMapView = YES;
		isSelectingByMap = YES;
	}

	[self presentViewController:msvc animated:YES  completion:nil];
	//[msvc release];
	
}

@end
