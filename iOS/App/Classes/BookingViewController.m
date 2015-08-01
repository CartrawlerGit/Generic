//
//  BookingViewController.m
//  CarTrawler
//
//

#import "BookingViewController.h"
#import "CTHudViewController.h"
#import "Car.h"
#import "Vendor.h"
#import "RentalSession.h"
#import "Booking.h"
#import "ReceiptViewController.h"
#import "CTUserBookingDetails.h"
#import "CTLocation.h"
#import "CTTableViewAsyncImageView.h"
#import "RentalConditionsViewController.h"
#import "Fee.h"
#import "ExtraEquipment.h"
#import "InsuranceObject.h"

#define SectionHeaderHeight 30
#define placeholderTextColor [UIColor colorWithWhite:0.7 alpha:1.0]
#define fieldTextColor [UIColor colorWithWhite:0.0 alpha:1.0]

#ifdef NSFoundationVersionNumber_iOS_6_1
#define SD_IS_IOS6 (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
#else
#define SD_IS_IOS6 YES
#endif

@interface BookingViewController (Private)

- (void) updateFieldColors;
- (void) updateAccessoryViewsInTableView;
- (void) showAccessoryTickForCell:(UITableViewCell*)cell withValue:(NSString*)value enabled:(BOOL)enabled;

@property (nonatomic, strong) CTHudViewController *hud;

@end

@implementation BookingViewController

@synthesize selectedCardType;
@synthesize insuranceCostTitleLabel;
@synthesize insuranceLabelForCostSection;
@synthesize dropOffHeaderLabel;
@synthesize hasAlternateDropOff;
@synthesize haveGivenName;
@synthesize haveSurname;
@synthesize haveEmailAddress;
@synthesize haveAddress;
@synthesize haveFlightNumber;
@synthesize havePhoneNumber;
@synthesize extrasTitleLabel;
@synthesize extrasCostLabel;
@synthesize costCell;
@synthesize pickUpDateLabel;
@synthesize dropOffDateLabel;
@synthesize numberOfPeopleLabel;
@synthesize baggageLabel;
@synthesize numberOfDoorsLabel;
@synthesize extraFeaturesLabel;
@synthesize depositLabel;
@synthesize bookingFeeLabel;
@synthesize extrasLabel;
@synthesize totalLabel;
@synthesize arrivalAmountLabel;
@synthesize acceptConditionsButton;
@synthesize acceptedConditions;
@synthesize acceptedRentalTerms;
@synthesize acceptedEngineTerms;
@synthesize termsCell;
@synthesize nameTB;
@synthesize flightNumberTB;
@synthesize vendorLogo;
@synthesize carLogo;
@synthesize carCategoryLabel;
@synthesize overViewCell;
@synthesize pickUpLocationLabel;
@synthesize dropOffLocationLabel;
@synthesize totalCostLabel;
@synthesize visaMasterSegment;
@synthesize footerView;
@synthesize session;
@synthesize givenNameTB;
@synthesize namePrefixTB;
@synthesize surnameTB;
@synthesize phoneAreaCodeTB;
@synthesize phoneNumberTB;
@synthesize emailAddressTB;
@synthesize addressTB;
@synthesize countryCodeTB;
@synthesize ccHolderNameTB;
@synthesize ccNumberTB;
@synthesize ccExpDateTB;
@synthesize ccSeriesCodeTB;
@synthesize bookingTable;

#pragma mark -
#pragma mark Accessory Mark Stuff

- (void) updateFieldColors {
	[givenNameTB setTextColor:placeholderTextColor];
	[surnameTB setTextColor:placeholderTextColor];
	[emailAddressTB setTextColor:placeholderTextColor];
	[addressTB setTextColor:placeholderTextColor];
	[phoneNumberTB setTextColor:placeholderTextColor];
	[flightNumberTB setTextColor:placeholderTextColor];
	
	if (givenNameTB.text != nil) {
		haveGivenName = YES;
		[givenNameTB setTextColor:fieldTextColor];
	}
		
	if (surnameTB.text != nil) {
		haveSurname = YES;
		[surnameTB setTextColor:fieldTextColor];
	}
		
	if (emailAddressTB.text != nil) {
		haveEmailAddress = YES;
		[emailAddressTB setTextColor:fieldTextColor];
	}
		
	if (addressTB.text != nil) {
		haveAddress = YES;
		[addressTB setTextColor:fieldTextColor];
	}
		
	if (phoneNumberTB.text != nil) {
		havePhoneNumber = YES;
		[phoneNumberTB setTextColor:fieldTextColor];
	}
		
	if (flightNumberTB.text != nil) {
		haveFlightNumber = YES;
		[flightNumberTB setTextColor:fieldTextColor];
	}
		
	
	[self updateAccessoryViewsInTableView];
}

- (void) updateAccessoryViewsInTableView {
	
	UITableViewCell *cell;
	
	// Section 0 - Personal Details
	
	cell = [bookingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:givenNameTB.text enabled:haveGivenName];
	
	cell = [bookingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:surnameTB.text enabled:haveSurname];
	
	cell = [bookingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:emailAddressTB.text enabled:haveEmailAddress];
	
	cell = [bookingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:addressTB.text enabled:haveAddress];
	
	cell = [bookingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:phoneNumberTB.text enabled:havePhoneNumber];
	
	cell = [bookingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:flightNumberTB.text enabled:haveFlightNumber];
}

- (void) showAccessoryTickForCell:(UITableViewCell*)cell withValue:(NSString*)value enabled:(BOOL)enabled {
	UIImage *tickImage = [UIImage imageNamed:@"includedIcon.png"];
	
	if (value != nil) {
		
		if (enabled) {
			cell.accessoryView = [[UIImageView alloc] initWithImage:tickImage];
		}
		
		[cell.accessoryView popIn:0.5f delegate:self];
		
	} else {
		cell.accessoryView = nil;
	}
}

#pragma mark -
#pragma mark T&C Logic

- (void) termsAndConditionsAccepted:(NSNotification *)notify  {
	self.acceptedConditions = YES;
	
	if (acceptedConditions && acceptedEngineTerms) {
		[acceptConditionsButton setSelected:YES];
	}
}

- (void) engineTermsAccepted:(NSNotification *)notify  {
	self.acceptedEngineTerms = YES;	
	
	if (acceptedConditions && acceptedEngineTerms) {
		[acceptConditionsButton setSelected:YES];
	}
}

- (IBAction) readEngineConditionsPressed:(id)sender {
	RentalConditionsViewController *rcvc = [[RentalConditionsViewController alloc] init];
	rcvc.session = self.session;
	[rcvc setBookingEngineTermsAndConditions:YES];
	
//	[FlurryAPI logEvent:@"Step 3: Read engine t&cs."];
	
	[self presentViewController:rcvc animated:NO completion:nil];
	//[rcvc release];
}

- (IBAction) readRentalConditionsPressed:(id)sender {
	
	RentalConditionsViewController *rcvc = [[RentalConditionsViewController alloc] init];
	rcvc.session = self.session;
	
//	[FlurryAPI logEvent:@"Step 3: Read rental conditions t&cs."];
	
	[self presentViewController:rcvc animated:NO completion:nil];
	//[rcvc release];
}

- (IBAction) acceptedConditionButtonPressed:(id)sender {
	
	if (acceptedConditions && acceptedEngineTerms) {
		[acceptConditionsButton setSelected:NO];
		acceptedConditions = NO;
		acceptedEngineTerms = NO;
	} else {
		[acceptConditionsButton setSelected:YES];
		acceptedConditions = YES;
		acceptedEngineTerms = YES;
	}
}

#pragma mark -
#pragma mark UITextField & UILabel Creation

- (UITextField *) newTextField {
	CGRect frame = CGRectMake(52, 14.0, 190.0, kTextFieldHeight);
	UITextField *textField = [[UITextField alloc] initWithFrame:frame];
	
	textField.borderStyle = UITextBorderStyleNone;
	textField.textColor = [UIColor blackColor];
	textField.font = [UIFont systemFontOfSize:14.0];
	textField.backgroundColor = [UIColor clearColor];
	textField.opaque = NO;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	[textField setEnabled:YES];
	textField.keyboardType = UIKeyboardTypeDefault;	
	textField.returnKeyType = UIReturnKeyNext;
	textField.delegate = self;
	
	[textField setAccessibilityLabel:NSLocalizedString(@"Text Field", @"")];
	
	return textField;
}

- (UILabel *) newLabel {
	CGRect frame = CGRectMake(52, 7.0, 190.0, kTextFieldHeight);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	
	label.textColor = [UIColor blackColor];
	label.font = [UIFont systemFontOfSize:14.0];
	label.backgroundColor = [UIColor whiteColor];
	
	return label;
}

#pragma mark -
#pragma mark Get Extra Costs

- (NSString *) getTotalCostOfExtrasWithCurrency:(BOOL)withCurrency {
	double extrasTotal;
	NSString *currency;
	
	if ([session.extras count] > 0) {
		for (ExtraEquipment *e in session.extras) {
			extrasTotal = (e.qty * [e.chargeAmount doubleValue]);
			currency = e.currencyCode;
		}
		
		if (withCurrency) {
			return [NSString stringWithFormat:@"%@ %.2f", currency, extrasTotal];
		} else {
			return [NSString stringWithFormat:@"%.2f",extrasTotal];
		}
		
	} else {
		return @"0.00";
	}
}

- (void) getExtras {
	NSMutableArray *includedExtras = [[NSMutableArray alloc] init];
	
	for (ExtraEquipment *e in session.extras) {
		if (e.qty > 0) {
			[includedExtras addObject:e];
		}
	}
	//[includedExtras release];
}

#pragma mark -
#pragma mark Success and Failure View Controller creation

- (void) resetTableOffset {
	[bookingTable setContentOffset:CGPointMake(0, 0) animated:YES];
	[bookingTable setScrollEnabled:YES];
}

- (void) scrollTableOffset:(NSIndexPath*)indexPath {
	NSInteger ypos = [indexPath row]*[bookingTable rowHeight];
	DLog(@"ypos is %li", (long)ypos);
	[bookingTable setContentOffset:CGPointMake(0, ypos) animated:YES];
	[bookingTable setScrollEnabled:YES];
}

- (void) saveCustomObject:(Booking *)obj {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([[[defaults dictionaryRepresentation] allKeys] containsObject:@"Bookings"]) 
	{
		NSMutableDictionary *allBookings = [[defaults objectForKey:@"Bookings"] mutableCopy];
		NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
		[allBookings setObject:myEncodedObject forKey:obj.confID];
		[defaults setObject:[allBookings copy] forKey:@"Bookings"];
	} 
	else 
	{
		NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];	
		NSDictionary *bookingDict = [NSDictionary dictionaryWithObject:myEncodedObject forKey:obj.confID];
		[defaults setObject:bookingDict forKey:@"Bookings"];
	}
	[defaults synchronize];
}

- (void) showSuccessfulViewController:(Booking *)b {
	
	[self saveCustomObject:b];
		
   ReceiptViewController *rvc = [[ReceiptViewController alloc] initWithNibName:@"ReceiptViewController" bundle:nil];
    
//	ReceiptViewController *rvc = [[[ReceiptViewController alloc] init] autorelease];
   
	[rvc setTheBooking:b];
    [self.navigationController pushViewController:rvc animated:YES];
	
	//[rvc release];
}

#pragma mark -
#pragma mark API Calls

- (void) makeTheBooking {
	if (acceptedConditions) {
		
		NSString *extrasStr = @"";
		
		NSMutableArray *validExtras = [[NSMutableArray alloc] init];
		
		for (ExtraEquipment *e in self.session.extras) {
			if (e.qty > 0) {
				[validExtras addObject:e];
			}
		}
		
		if ([validExtras count] > 0) {
			
			extrasStr = [extrasStr stringByAppendingString:@",\"SpecialEquipPrefs\":{\"SpecialEquipPref\":["];
			
			for (int i = 0; i < [validExtras count]; i++) {
				ExtraEquipment *e = (ExtraEquipment *)[validExtras objectAtIndex:i];
				if (e.qty != 0) {
					extrasStr = [extrasStr stringByAppendingString:[NSString stringWithFormat:@"{\"@EquipType\":\"%li\",\"@Quantity\":\"%li\"}", (long)[e.equipType integerValue], (long)e.qty]];
					if ([validExtras count] > 1) {
						if ((i + 1) != ([validExtras count])) {
							extrasStr = [extrasStr stringByAppendingString:@","];
						}
					}
					
				}
			}
			extrasStr = [extrasStr stringByAppendingString:@"]}"];
			
		} else {
			extrasStr = @"";
		}
		
		// If payment is required, fields need to be validated.
		
		if (session.theCar.needCCInfo || session.hasBoughtInsurance) {
			if (ccNumberTB.text == nil) {
				[CTHelper showAlert:@"Missing Information" message:@"You must include a credit card number."];
			} else if (ccExpDateTB.text == nil) {
				[CTHelper showAlert:@"Missing Information" message:@"You must include an expiry date for your credit card."];
			} else if (ccHolderNameTB.text == nil) {
				[CTHelper showAlert:@"Missing Information" message:@"Please include the credit card holder's name."];
			} else if (ccSeriesCodeTB.text == nil) {
				[CTHelper showAlert:@"Missing Information" message:@"Please include the credit card's CCV code."];
			} else if ([selectedCardType isEqualToString:@""]) {
				[CTHelper showAlert:@"Missing Information" message:@"You must select a credit card type."];
			}
		} 
		
		// Personal detail are always required, so go through those and then proceed with the request.
		
		if (emailAddressTB.text == nil) {
			[CTHelper showAlert:@"Missing Information" message:@"An email address is required."];
		} else if (givenNameTB.text == nil) {
			[CTHelper showAlert:@"Missing Information" message:@"Given name is required."];
		} else if (surnameTB.text == nil) {
			[CTHelper showAlert:@"Missing Information" message:@"Surname is required."];
		} else if (emailAddressTB.text == nil) {
			[CTHelper showAlert:@"Missing Information" message:@"An email address is required."];
		} else {
			self.hud = [[CTHudViewController alloc] initWithTitle:@"Creating reservation"];
			[self.hud show];
			
			ASIHTTPRequest *request;
			
			if (session.theCar.needCCInfo || session.hasBoughtInsurance) {
				DLog(@"Payment needed");
				NSString *requestString = [CTRQBuilder OTA_VehResRQ:self.session.puDateTime returnDateTime:self.session.doDateTime 
												 pickupLocationCode:session.puLocationCode dropoffLocationCode:session.doLocationCode 
														homeCountry:self.session.homeCountry driverAge:self.session.driverAge 
													  numPassengers:self.session.numPassengers flightNumber:flightNumberTB.text refID:self.session.theCar.refID 
													   refTimeStamp:self.session.theCar.refTimeStamp refURL:self.session.theCar.refURL 
													   extrasString:extrasStr
														 namePrefix:@"Mr."
														  givenName:givenNameTB.text
															surName:surnameTB.text
													   emailAddress:emailAddressTB.text
															address:addressTB.text
														phoneNumber:phoneNumberTB.text
														   cardType:selectedCardType
														 cardNumber:ccNumberTB.text
													 cardExpireDate:ccExpDateTB.text
													 cardHolderName:ccHolderNameTB.text
													  cardCCVNumber:ccSeriesCodeTB.text
													insuranceObject:session.insurance
												  isBuyingInsurance:session.hasBoughtInsurance];
				if (kShowRequest) {
					DLog(@"\n\n%@\n\n", requestString);
				}
				
				request = [CTHelper makeRequest:kOTA_VehResRQ tail:requestString];
				
			} else {
				DLog(@"No payment needed");
				NSString *requestStringNoPayment = [CTRQBuilder OTA_VehResRQNoPayment:self.session.puDateTime returnDateTime:self.session.doDateTime 
												 pickupLocationCode:session.puLocationCode dropoffLocationCode:session.doLocationCode 
														homeCountry:self.session.homeCountry driverAge:self.session.driverAge 
													  numPassengers:self.session.numPassengers flightNumber:flightNumberTB.text refID:self.session.theCar.refID 
													   refTimeStamp:self.session.theCar.refTimeStamp refURL:self.session.theCar.refURL 
													   extrasString:extrasStr
														 namePrefix:@"Mr."
														  givenName:givenNameTB.text
															surName:surnameTB.text
													   emailAddress:emailAddressTB.text
														  address:addressTB.text
													  phoneNumber:phoneNumberTB.text];
				if (kShowRequest) {
					DLog(@"\n\n%@\n\n", requestStringNoPayment);
				}
				request = [CTHelper makeRequest:kOTA_VehResRQ tail:requestStringNoPayment];
			}
			
			[request setDelegate:self];
			[request setTimeOutSeconds:30];
			[request setNumberOfTimesToRetryOnTimeout:1];
			[request startAsynchronous];
			
		//	[FlurryAPI logEvent:@"Step 3: Submited Booking."];
		}

	} else {
		UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle: @"Cannot proceed"
								   message: @"You must agree to the car rental & booking engine terms and conditions."
								   delegate:nil
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil];
        [errorAlert show];
        //[errorAlert release];
	}

	
}

- (void) requestFinished:(ASIHTTPRequest *) request {
	NSString *responseString = [request responseString];
	NSDictionary *responseDict = [responseString JSONValue];
	
	if (kShowResponse) {
		DLog(@"Booking Response is \n\n%@\n\n", [request responseString]);
	}
	
	[self.hud hide];
	//[hud autorelease];
	self.hud = nil;
	
	// Test here, the booking might not be a booking.  Errors will be returned in an array.
	
	id response = [CTHelper validateResponse:responseDict];
	
	if ([response isKindOfClass:[NSArray class]]) {

		NSArray *errors = (NSArray *)response;
		
		for (CTError *err in errors) {
			[err description];
			
		//	[FlurryAPI logEvent:[NSString stringWithFormat:@"Step 3: Booking Error %@ - (%@)", err.errorType, ////err.errorShortTxt]];
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:err.errorShortTxt delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			[alert show];
			//[alert release];
		}
		
	} else {
		Booking *b = (Booking *)response;
		
		[b setCustomerEmail:emailAddressTB.text];
	//	[FlurryAPI logEvent:@"Step 3: Successful Booking made."];
		[self showSuccessfulViewController:b];
	}
//	[FlurryAPI endTimedEvent:@"Session." withParameters:nil];
}

- (void) requestFailed:(ASIHTTPRequest *) request {
	NSError *error = [request error];
	Error(@"%@", error);
	
	//[FlurryAPI logEvent:@"Step 3: Booking API failure detectd."];
	//[FlurryAPI endTimedEvent:@"Session." withParameters:nil];
	
	[self.hud hide];
	//[hud autorelease];
	self.hud = nil;
} 

#pragma mark -
#pragma mark Lifecycle stuff

- (void) setPlaceholders {
	[givenNameTB setPlaceholder:@"Given name"];
	[surnameTB setPlaceholder:@"Surname"];
	[emailAddressTB setPlaceholder:@"me@example.com"];
	[addressTB setPlaceholder:@"1 My House, My Street, London"];
	[phoneAreaCodeTB setPlaceholder:@"01"];
	[phoneNumberTB setPlaceholder:@"Phone number"];
	[countryCodeTB setPlaceholder:@"Country"];
	[flightNumberTB setPlaceholder:@"Flight number"];
	
	[visaMasterSegment setSelectedSegmentIndex:0];
	[ccHolderNameTB setPlaceholder:@"Card holder's name"];
	[ccNumberTB setPlaceholder:@"Card number"];
	[ccExpDateTB setPlaceholder:@"MMYY"];
	[ccSeriesCodeTB setPlaceholder:@"123"];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
	[self getExtras];

	selectedCardType = @"";
	
	if (![session.puLocationNameString isEqualToString:session.doLocationNameString]) {
		hasAlternateDropOff = YES;
		DLog(@"There is alternate drop off!");
		[overViewCell setFrame:CGRectMake(0, 0, overViewCell.frame.size.width, 184)];		
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(termsAndConditionsAccepted:) name:@"termsAndConditionsAccepted" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(engineTermsAccepted:) name:@"engineTermsAccepted" object:nil];
	
	UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleBordered target:self action:@selector(resetPersonalDetails)];
	self.navigationItem.rightBarButtonItem = rightBarButton;
	//[rightBarButton release];
	
	[bookingTable setContentInset:UIEdgeInsetsMake(17,0,0,0)];
	
	self.title = @"Place Booking";
	self.navigationItem.titleView = [CTHelper getNavBarLabelWithTitle:@"Book Car"];
	
	self.bookingTable.backgroundColor = [UIColor clearColor];
    self.bookingTable.backgroundView = nil;
	
	//Personal Details
	
	self.givenNameTB = [self newTextField];
	
	self.surnameTB = [self newTextField];
	
	self.emailAddressTB = [self newTextField];
	[emailAddressTB setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailAddressTB setAutocorrectionType:UITextAutocorrectionTypeNo];
    [emailAddressTB setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	
	self.addressTB = [self newTextField];
	
	self.phoneAreaCodeTB = [self newTextField];
	
	self.phoneNumberTB = [self newTextField];
	[phoneNumberTB setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	
	self.countryCodeTB = [self newTextField];
	
	//Payment Details
	
	self.ccHolderNameTB = [self newTextField];
	
	self.ccNumberTB = [self newTextField];
	[ccNumberTB setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	
	self.ccExpDateTB = [self newTextField];
	[ccExpDateTB setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	
	self.ccSeriesCodeTB = [self newTextField];
	[ccSeriesCodeTB setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	self.ccSeriesCodeTB.returnKeyType = UIReturnKeyDone;
	
	self.flightNumberTB = [self newTextField];
	self.flightNumberTB.returnKeyType = UIReturnKeyDone;
	
	haveGivenName = NO;
	haveSurname = NO;
	haveAddress = NO;
	haveEmailAddress = NO;
	havePhoneNumber = NO;
	haveFlightNumber = NO;
	
	[self setPlaceholders];
	[self loadUserPrefs];
}

- (void) resetPersonalDetails {
	[self resignFirstResponder];
	[self resetTableOffset];
	
	// Clear TBs
	
	[nameTB setText:@""];
	[namePrefixTB setText:@""];
	[givenNameTB setText:@""];
	[surnameTB setText:@""];
	[emailAddressTB setText:@""];
	[addressTB setText:@""];
	[phoneAreaCodeTB setText:@""];
	[phoneNumberTB setText:@""];
	[countryCodeTB setText:@""];
	[flightNumberTB setText:@""];
	
	[nameTB resignFirstResponder];
	[namePrefixTB resignFirstResponder];
	[givenNameTB resignFirstResponder];
	[surnameTB resignFirstResponder];
	[emailAddressTB resignFirstResponder];
	[addressTB resignFirstResponder];
	[phoneAreaCodeTB resignFirstResponder];
	[phoneNumberTB resignFirstResponder];
	[countryCodeTB resignFirstResponder];
	[flightNumberTB resignFirstResponder];
	
	[self setPlaceholders];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated{
	[self saveUserPrefs];
	[super viewWillDisappear:animated];
}

- (void) viewDidUnload {
	self.footerView = nil;
	self.session = nil;
	self.givenNameTB = nil;
	self.namePrefixTB = nil;
	self.surnameTB = nil;
	self.phoneAreaCodeTB = nil;
	self.phoneNumberTB = nil;
	self.emailAddressTB = nil;
	self.addressTB = nil;
	self.countryCodeTB = nil;
	self.ccHolderNameTB = nil;
	self.ccNumberTB = nil;
	self.ccExpDateTB = nil;
	self.ccSeriesCodeTB = nil;
	self.bookingTable = nil;
	self.flightNumberTB = nil;
    [super viewDidUnload];
}

- (void) dealloc {
    /*
	[bookingTable release];
	[namePrefixTB release];
	[surnameTB release];
	[phoneAreaCodeTB release];
	[phoneNumberTB release];
	[emailAddressTB release];
	[addressTB release];
	[countryCodeTB release];
	[ccHolderNameTB release];
	[ccNumberTB release];
	[ccExpDateTB release];
	[ccSeriesCodeTB release];
	[givenNameTB release];
	[session release];
	[footerView release];
	[overViewCell release];
	[pickUpLocationLabel release];
	[dropOffLocationLabel release];
	[totalCostLabel release];
	[carCategoryLabel release];
	[vendorLogo release];
	[carLogo release];
	[flightNumberTB release];
	[nameTB release];
	[termsCell release];
	[acceptConditionsButton release];

	[pickUpDateLabel release];
	pickUpDateLabel = nil;
	[dropOffDateLabel release];
	dropOffDateLabel = nil;
	[numberOfPeopleLabel release];
	numberOfPeopleLabel = nil;
	[baggageLabel release];
	baggageLabel = nil;
	[numberOfDoorsLabel release];
	numberOfDoorsLabel = nil;
	[extraFeaturesLabel release];
	extraFeaturesLabel = nil;
	[depositLabel release];
	depositLabel = nil;
	[bookingFeeLabel release];
	bookingFeeLabel = nil;
	[extrasLabel release];
	extrasLabel = nil;
	[totalLabel release];
	totalLabel = nil;
	[arrivalAmountLabel release];
	arrivalAmountLabel = nil;
	[costCell release];
	costCell = nil;
	[extrasCostLabel release];
	extrasCostLabel = nil;
	[extrasTitleLabel release];
	extrasTitleLabel = nil;
	[dropOffHeaderLabel release];
	dropOffHeaderLabel = nil;
	[insuranceLabelForCostSection release];
	insuranceLabelForCostSection = nil;
	[insuranceCostTitleLabel release];
	insuranceCostTitleLabel = nil;
	[selectedCardType release];
	selectedCardType = nil;
    [super dealloc];
    //self=nil;
     */
}

#pragma mark -
#pragma mark UIImageView setup for tablerows

- (UIImage *) getIconForCellAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger section = indexPath.section;
	NSUInteger row = indexPath.row;
	
	if (section == 0) {
		if (row == 0) {
			return [UIImage imageNamed:@"name.png"];
		} else if (row == 1) {
			return [UIImage imageNamed:@"name.png"];
		} else if (row == 2) {
			return [UIImage imageNamed:@"email.png"];
		} else if (row == 3) {
			return [UIImage imageNamed:@"address.png"];
		} else if (row == 4) {
			return [UIImage imageNamed:@"telephone.png"];
		} else {
			return nil;
		}

	} else if (section == 1) {
		if (row == 0) {
			return [UIImage imageNamed:@"card_type.png"];
		} else if (row == 1) {
			return [UIImage imageNamed:@"card_name.png"];
		} else if (row == 2) {
			return [UIImage imageNamed:@"card_number.png"];
		} else if (row == 3) {
			return [UIImage imageNamed:@"card_expiry.png"];
		} else if (row == 4) {
			return [UIImage imageNamed:@"card_CVS.png"];
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void) scrolltablePosition:(NSInteger)i {
	[bookingTable setContentOffset:CGPointMake(0, i) animated:YES];
	[bookingTable setScrollEnabled:YES];
}

#define editHeight 10

- (void) textFieldDidBeginEditing:(UITextField *)textField { }

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered {
	if (textField == ccNumberTB) {
		if (textField.text.length >= 16 && range.length == 0) {
			[textField resignFirstResponder];
			[ccExpDateTB becomeFirstResponder];
			return NO;
		}
		else {
			return YES;
		}
	} else if (textField == ccExpDateTB) {
		if (textField.text.length >= 4 && range.length == 0) {
			[textField resignFirstResponder];
			[ccSeriesCodeTB becomeFirstResponder];
			return NO;
		}
		else {
			return YES;
		}
	} else if (textField == ccSeriesCodeTB) {
		if (textField.text.length >= 3 && range.length == 0) {
          //rjh  [self.view endEditing:YES];
			//rjh[textField resignFirstResponder];
			return NO;
		}
		else {
			return YES;
		}
	}
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {

    [self.view endEditing:YES];
    
	if (textField == givenNameTB) {

		//[textField resignFirstResponder];
		[surnameTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 44];
		
	} else if (textField == surnameTB) {
		//[textField resignFirstResponder];
		[emailAddressTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 88];
		
	} else if (textField == emailAddressTB) {
		
		//[textField resignFirstResponder];
		[addressTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 132];
		
	} else if (textField == addressTB) {
		
		//[textField resignFirstResponder];
		[phoneNumberTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 176];
		
	} else if (textField == phoneNumberTB) {
		
		//[textField resignFirstResponder];
		
		if (session.puLocation.atAirport) {
			[flightNumberTB becomeFirstResponder];
			[self scrolltablePosition:editHeight + 220];
		} else {
			[ccHolderNameTB becomeFirstResponder];
			[self scrolltablePosition:editHeight + 220];
		}

	} else if (textField == flightNumberTB) {
		
		//[textField resignFirstResponder];
		[ccHolderNameTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 264];
		
	} else if (textField == ccHolderNameTB) {
		
		//[textField resignFirstResponder];
		[ccNumberTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 304];
		
	} else if (textField == ccNumberTB) {
		
		//[textField resignFirstResponder];
		[ccExpDateTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 348];
		
	} else if (textField == ccExpDateTB) {
		
		//[textField resignFirstResponder];
		[ccSeriesCodeTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 392];
		
	} else {
		//[ccSeriesCodeTB resignFirstResponder];
		//[self resetTableOffset];
	}

	[self saveUserPrefs];
	// [self updateFieldColors];
	return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark UITableView Stuff

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	
	CGFloat height;
	if (indexPath.section == 4) {
		height = 71;
	} else if (indexPath.section == 3) {
		height = 121;
	}
	else if (indexPath.section == 2) {
		if (hasAlternateDropOff) {
			height = 185;
		} else {
			height = 167;
		}
	} else {
		height = 44;
	}
	
	CGRect rect = CGRectMake(0,0,292,height);
	
	UIView *view = [[UIView alloc] initWithFrame:rect];
	[view setContentMode:UIViewContentModeScaleToFill];
	[view setClipsToBounds:YES];
	[view setOpaque:NO];
	
	UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect] ;
    [imageview setContentMode:UIViewContentModeScaleToFill];
	UIImage *image = [UIImage imageNamed:@"table_middle.png"];
	[imageview setImage:image];
        if (SD_IS_IOS6) {
            [view addSubview:imageview];
        }
	//[imageview release];
	
	[cell insertSubview:view belowSubview:[cell backgroundView]];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
	switch (section) {
		case 0:
			title = @"Personal Information";
			break;
		case 1:
			title = @"Payment Information";
			break;
		case 2:
			title = @"Booking Overview";
			break;
		case 3:
			title = @"Cost Overview";
			break;
		case 4:
			title = @"Terms & Conditions";
			break;
		default:
			break;
	}
	return title;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
		return 5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
		if (session.puLocation.atAirport) {
			return 6;
		} else {
			return 5;
		}
	} else if (section == 1) {
		if (session.theCar.needCCInfo || session.hasBoughtInsurance) { // Do we need to ask for cc details?
			return 5;
		} else { // If we don't...
			return 1;
		}
	} else {
		return 1;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
		return 33;
	} else {
		return SectionHeaderHeight;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 4) {
		return 100.0;	 
	} else {
		return 0;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 4) {
		return 70;
	} else if (indexPath.section == 3) {
		return 120;
	} else if (indexPath.section == 2) {
		if (hasAlternateDropOff) {
			return 184;
		} else {
			return 166;
		}
	} else if (indexPath.section == 0 || indexPath.section == 1) { // This is to correct the odd 1px break that was happening under the first section headings.
		if (indexPath.row == 0) {
			return 43;
		} else {
			return 44;
		}
	} 
	else {
		return 44;
	}
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 33)] ;
	UILabel *label = [[UILabel alloc] init];
	if (section == 0) {
		
		label.frame = CGRectMake(20, 3, 300, 33);
		
		CGRect rect = CGRectMake(0,0,292,33);
		UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
		UIImage *image = [UIImage imageNamed:@"table_header.png"];
		[imageview setImage:image];
		[view addSubview:imageview];
        //[imageview release];
		
	} else {
		
		label.frame = CGRectMake(20, 0, 300, 33);
		
		CGRect rect = CGRectMake(0,-2,292,33);
		UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect] ;
		UIImage *image = [UIImage imageNamed:@"table_middle.png"];
		[imageview setImage:image];
		[view setContentMode:UIViewContentModeScaleToFill];
		[view addSubview:imageview];
        //[imageview release];
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
    if (section == 4) {
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 77)] ;
		CGRect rect = CGRectMake(0,0,292,77);
		UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
		UIImage *image = [UIImage imageNamed:@"table_button_footer.png"];
		[imageview setImage:image];
		[view addSubview:imageview];
		//[imageview release];
		UIButton *bookBtn = [CTHelper getGreenUIButtonWithTitle:@"Complete Booking"];
		[bookBtn setFrame:CGRectMake(bookBtn.frame.origin.x, 18, bookBtn.frame.size.width, bookBtn.frame.size.height)];
		[bookBtn addTarget:self action:@selector(makeTheBooking) forControlEvents:UIControlEventTouchUpInside];
		
		[view addSubview:bookBtn];
		return view;
	} else {
		return nil;
	}
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"ResultItemCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)  {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
	
	[cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	for (UIView *view in cell.contentView.subviews)
		if ([view isKindOfClass:[UITextField class]])
			[view removeFromSuperview];
	
	for (UIView *view in cell.subviews)
		if ([view isKindOfClass:[UIButton class]])
			[view removeFromSuperview];
	 
	 for (UIView *view in cell.subviews)
		 if ([view isKindOfClass:[UIImageView class]])
			 [view removeFromSuperview];

	UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 29, 22)];
	[icon setImage:[self getIconForCellAtIndexPath:indexPath]];
	[cell.contentView addSubview:icon];
	
	if (indexPath.section == 0) {
		
		if (indexPath.row == 0) {
			[nameTB setPlaceholder:@"Given name"];
			[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
			[cell.contentView addSubview:givenNameTB];
		} else if (indexPath.row == 1) {
			[nameTB setPlaceholder:@"Surname"];
			[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
			[cell.contentView addSubview:surnameTB];
		} else if (indexPath.row == 2) {
			[emailAddressTB setPlaceholder:@"Email"];
			[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
			[cell.contentView addSubview:emailAddressTB];
		} else if (indexPath.row == 3) {
			[addressTB setPlaceholder:@"Address"];
			[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
			[cell.contentView addSubview:addressTB];
		} else if (indexPath.row == 4) {
			[phoneNumberTB setPlaceholder:@"Phone"];
			[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
			[cell.contentView addSubview:phoneNumberTB];
		} else {
			if (session.puLocation.atAirport) {
				[flightNumberTB setPlaceholder:@"Flight number"];
				[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
				[cell.contentView addSubview:flightNumberTB];
			}
		}
	} 
	else if (indexPath.section == 1) {
		if (session.theCar.needCCInfo || session.hasBoughtInsurance) { // Do we need to ask for cc details?
			if (indexPath.row == 0) {
				visaButton = [UIButton buttonWithType:UIButtonTypeCustom];
				
				visaButton.frame = CGRectMake(100, 5, 80, 35);
				[visaButton setImage:[UIImage imageNamed:@"visaIconInactive.png"] forState:UIControlStateNormal];
				[visaButton setImage:[UIImage imageNamed:@"visaIconActive.png"] forState:UIControlStateSelected];
				[visaButton setTitle:@"" forState:UIControlStateNormal];
				[visaButton addTarget:self action:@selector(visaButtonPressed) forControlEvents:UIControlEventTouchUpInside];
				
				[cell addSubview:visaButton];
				[self.view bringSubviewToFront:visaButton];
				
				mastercardButton = [UIButton buttonWithType:UIButtonTypeCustom];
				
				//set the position of the button
				mastercardButton.frame = CGRectMake(180, 5, 80, 35);
				[mastercardButton setImage:[UIImage imageNamed:@"mastercardIconInactive.png"] forState:UIControlStateNormal];
				[mastercardButton setImage:[UIImage imageNamed:@"mastercardIconActive.png"] forState:UIControlStateSelected];
				
				[mastercardButton setTitle:@"" forState:UIControlStateNormal];
				[mastercardButton addTarget:self action:@selector(mastercardButtonPressed) forControlEvents:UIControlEventTouchUpInside];
				
				[cell addSubview:mastercardButton];
				[self.view bringSubviewToFront:mastercardButton];
				
			} 
			else if (indexPath.row == 1) {
				// Name on Card
				[ccHolderNameTB setPlaceholder:@"Cardholder's name"];
				[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
				[cell.contentView addSubview:ccHolderNameTB];
			} else if (indexPath.row == 2) {
				// Number
				[ccNumberTB setPlaceholder:@"Card number"];
				[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
				[cell.contentView addSubview:ccNumberTB];
			} else if (indexPath.row == 3) {
				// Exp
				[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
				[cell.contentView addSubview:ccExpDateTB];
			} else if (indexPath.row == 4) {
				// Security Number
				[ccSeriesCodeTB setPlaceholder:@"CVS"];
				[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
				[cell.contentView addSubview:ccSeriesCodeTB];
			}
		} else { // If we don't...
					cell.textLabel.alpha = 0.439216f; // (1 - alpha) * 255 = 143
			//		cell.userInteractionEnabled = NO;
			//		cell.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
			icon.hidden = YES;
			cell.textLabel.text = @"No Payment details required at this time.";
			cell.userInteractionEnabled = NO;
		}
	} 
	else if (indexPath.section == 2) {
		overViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell = overViewCell;
		
		//------------------------------------------------------------------------------------------------
		[carCategoryLabel setText:[CTHelper getVehcileCategoryStringFromNumber:[NSString stringWithFormat:@"%li", (long)session.theCar.vehicleClassSize]]];
		//[carCategoryLabel setText:session.theCar.vehicleCategory];
		
		[numberOfPeopleLabel setText:[NSString stringWithFormat:@"x%li", (long)session.theCar.passengerQtyInt]];
		[baggageLabel setText:[NSString stringWithFormat:@"x %@", session.theCar.baggageQty]];
		[numberOfDoorsLabel setText:[NSString stringWithFormat:@"%@", session.theCar.doorCount]];
		
		[pickUpLocationLabel setText:session.puLocationNameString];
		[dropOffLocationLabel setText:session.doLocationNameString];
		
		[pickUpDateLabel setText:session.readablePuDateTimeString];
		[dropOffDateLabel setText:session.readableDoDateTimeString];
		
		
		NSString *extrasStr = @"";
		
		if (![session.theCar.fuelType isEqualToString:@"Unspecified"]) {
			extrasStr = [extrasStr stringByAppendingFormat:@"- %@ ", session.theCar.fuelType];
		}
		
		if (session.theCar.transmissionType) {
			extrasStr = [extrasStr stringByAppendingFormat:@"- %@ ", session.theCar.transmissionType];
		}
		
		if (session.theCar.isAirConditioned) {
			extrasStr = [extrasStr stringByAppendingFormat:@"- Aircon "];
		}
		
		[extraFeaturesLabel setText:extrasStr];
		
		//------------------------------------------------------------------------------------------------
		
		CTTableViewAsyncImageView *thisImage = [[CTTableViewAsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 64.0, 40.0)];
		[carLogo addSubview:thisImage];
		
		NSURL *url = [NSURL URLWithString:session.theCar.pictureURL];
		[thisImage loadImageFromURL:url];
		
		if (session.theVendor.vendorName == NULL) {
			// No Vendor Name or Image supplied so cant draw anything.
		} else  {
			CTTableViewAsyncImageView *vendorImage = [[CTTableViewAsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 23.0)];
			[vendorLogo addSubview:vendorImage];
            if ([session.theVendor.venLogo isKindOfClass:[NSString class]] && session.theVendor.venLogo.length > 0)  {
                NSURL *urll = [NSURL URLWithString:session.theVendor.venLogo];
                [vendorImage loadImageFromURL:urll];
            }
		}
		
		if (hasAlternateDropOff) {	
			
			// Add new spacer
			
			UILabel *spacerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 274, 1)];
			[spacerLabel setBackgroundColor:[UIColor lightGrayColor]];
			[overViewCell addSubview:spacerLabel];
			
			// Add new Location name
			
			UILabel	*alternateDropOffLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 140, 258, 23)];
			[alternateDropOffLabel setBackgroundColor:[UIColor clearColor]];
			[alternateDropOffLabel setFont:[UIFont systemFontOfSize:12]];
			[alternateDropOffLabel setTextColor:[UIColor darkGrayColor]];
			[alternateDropOffLabel setText:session.doLocationNameString];
			[overViewCell addSubview:alternateDropOffLabel];
			
			// Add another spacer
			
			UILabel *anotherSpacerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 162, 274, 1)];
			[anotherSpacerLabel setBackgroundColor:[UIColor colorWithHexString:@"#dcdcdc"]];
			[overViewCell addSubview:anotherSpacerLabel];
			
			// Drop Off location Labels
			
			[dropOffHeaderLabel setFrame:CGRectMake(dropOffHeaderLabel.frame.origin.x, 165, dropOffHeaderLabel.frame.size.width, dropOffHeaderLabel.frame.size.height)];
			[dropOffDateLabel setFrame:CGRectMake(93, 163, 172, 19)];
			
		}
		
	} else if (indexPath.section == 3) {
		costCell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell = costCell;
		
		// Layout Costs Cell...this cell will probably only ever have 3 sections to it, maybe 2 (fees...)
		NSNumber *total = [NSNumber numberWithDouble:0.00];
		
		if (session.hasBoughtInsurance) {
			total = [NSNumber numberWithDouble:([[CTHelper convertStringToNumber:session.insurance.premiumAmount] doubleValue] + [total doubleValue])];
		}

		
		NSString *currentCurrency=@"EUR";
		if ([session.theCar.fees count] > 0) {
			
			for (Fee *f in session.theCar.fees) {
				NSString *cs = [CTHelper getCurrencySymbolFromString:f.feeCurrencyCode];
				currentCurrency = cs;
				
				if ([f.feePurpose isEqualToString:@"22"]) {
					// Deposit
					if (session.hasBoughtInsurance) {
						NSNumber *depositPlusInsurance = [NSNumber numberWithDouble:([total doubleValue] + [[CTHelper convertFeeFromStringToNumber:f] doubleValue])];
						[depositLabel setText:[NSString stringWithFormat:@"%@ %.2f", cs, [depositPlusInsurance doubleValue]]];
					} else {
						[depositLabel setText:[NSString stringWithFormat:@"%@ %.2f", cs, [[CTHelper convertFeeFromStringToNumber:f] doubleValue]]];
					}
					total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
					
				} else if ([f.feePurpose isEqualToString:@"23"]) {
					// Pay on Arrival
					[arrivalAmountLabel setText:[NSString stringWithFormat:@"%@ %.2f", cs, [[CTHelper convertFeeFromStringToNumber:f] doubleValue]]];
					total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
					
				} else if ([f.feePurpose isEqualToString:@"6"]) {
					// Booking Fee amount is added to the deposit.				
					total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
					
				}
			}
			[totalLabel setText:[NSString stringWithFormat:@"%@ %.2f", currentCurrency, [total doubleValue]]];
		}
		
		if ([[self getTotalCostOfExtrasWithCurrency:NO] isEqualToString:@"0.00"]) {
			extrasCostLabel.hidden = YES;
			extrasTitleLabel.hidden = YES;
		} else {
			[extrasCostLabel setText:[self getTotalCostOfExtrasWithCurrency:YES]];
		}
		
		// Add insurance premium if it's been bought in the confirmation.
		
		if (session.hasBoughtInsurance) {
			[insuranceCostTitleLabel setHidden:NO];
			[insuranceLabelForCostSection setHidden:NO];
			[insuranceLabelForCostSection setText:[NSString stringWithFormat:@"%@ %@", session.insurance.premiumCurrencyCode, session.insurance.premiumAmount]];
		} else {
			[insuranceCostTitleLabel setHidden:YES];
			[insuranceLabelForCostSection setHidden:YES];
			//[insuranceLabelForCostSection setText:@"(Not Included)"];
		}
		
		return costCell;
		
	} else if (indexPath.section == 4){
		termsCell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell = termsCell;
	} 
	
	return cell;
 }

- (void) mastercardButtonPressed {
	self.selectedCardType = @"MC";
	[visaButton setImage:[UIImage imageNamed:@"visaIconInactive.png"] forState:UIControlStateNormal];
	[mastercardButton setImage:[UIImage imageNamed:@"mastercardIconActive.png"] forState:UIControlStateNormal];
}

- (void) visaButtonPressed {
	self.selectedCardType = @"VI";
	[visaButton setImage:[UIImage imageNamed:@"visaIconActive.png"] forState:UIControlStateNormal];
	[mastercardButton setImage:[UIImage imageNamed:@"mastercardIconInactive.png"] forState:UIControlStateNormal];
}

- (void) saveUserPrefs {
	if (ctUserBookingDetails!=nil){
		
		ctUserBookingDetails.givenName = givenNameTB.text;
		ctUserBookingDetails.namePrefix = namePrefixTB.text;
		ctUserBookingDetails.surname = surnameTB.text;
		ctUserBookingDetails.phoneAreaCode = phoneAreaCodeTB.text;
		ctUserBookingDetails.phoneNumber = phoneNumberTB.text;
		ctUserBookingDetails.emailAddress = emailAddressTB.text;
		ctUserBookingDetails.address = addressTB.text;
		ctUserBookingDetails.countryCode = countryCodeTB.text;
		
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

		[prefs setValue:ctUserBookingDetails.givenName forKey:@"ctUserBookingDetails.givenName"];
		[prefs setValue:ctUserBookingDetails.namePrefix forKey:@"ctUserBookingDetails.namePrefix"];
		[prefs setValue:ctUserBookingDetails.surname forKey:@"ctUserBookingDetails.surname"];
		[prefs setValue:ctUserBookingDetails.phoneAreaCode forKey:@"ctUserBookingDetails.phoneAreaCode"];
		[prefs setValue:ctUserBookingDetails.phoneNumber forKey:@"ctUserBookingDetails.phoneNumber"];
		[prefs setValue:ctUserBookingDetails.emailAddress forKey:@"ctUserBookingDetails.emailAddress"];
		[prefs setValue:ctUserBookingDetails.address forKey:@"ctUserBookingDetails.address"];
		[prefs setValue:ctUserBookingDetails.countryCode forKey:@"ctUserBookingDetails.countryCode"];
		
		[prefs synchronize];
	}
}

- (void) loadUserPrefs {
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	ctUserBookingDetails = [[CTUserBookingDetails alloc] init];

	ctUserBookingDetails.givenName = [prefs valueForKey:@"ctUserBookingDetails.givenName"];
	ctUserBookingDetails.namePrefix = [prefs valueForKey:@"ctUserBookingDetails.namePrefix"];
	ctUserBookingDetails.surname = [prefs valueForKey:@"ctUserBookingDetails.surname"];
	ctUserBookingDetails.phoneAreaCode = [prefs valueForKey:@"ctUserBookingDetails.phoneAreaCode"];
	ctUserBookingDetails.phoneNumber = [prefs valueForKey:@"ctUserBookingDetails.phoneNumber"];
	ctUserBookingDetails.emailAddress = [prefs valueForKey:@"ctUserBookingDetails.emailAddress"];
	ctUserBookingDetails.address = [prefs valueForKey:@"ctUserBookingDetails.address"];
	ctUserBookingDetails.countryCode = [prefs valueForKey:@"ctUserBookingDetails.countryCode"];
	
	[givenNameTB setText:ctUserBookingDetails.givenName];
	[namePrefixTB setText:ctUserBookingDetails.namePrefix];
	[surnameTB setText:ctUserBookingDetails.surname];
	[phoneAreaCodeTB setText:ctUserBookingDetails.phoneAreaCode];
	[phoneNumberTB setText:ctUserBookingDetails.phoneNumber];
	[emailAddressTB setText:ctUserBookingDetails.emailAddress];
	[addressTB setText:ctUserBookingDetails.address];
	[countryCodeTB setText:ctUserBookingDetails.countryCode];
	
	//[self updateFieldColors];
}

@end
