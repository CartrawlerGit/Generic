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

@interface BookingViewController ()

@property (nonatomic, strong) CTHudViewController *hud;
@property (nonatomic, strong) UIButton *visaButton;
@property (nonatomic, strong) UIButton *mastercardButton;
@property (nonatomic, strong) CTUserBookingDetails *ctUserBookingDetails;

@end

@interface BookingViewController (Private)

- (void) updateFieldColors;
- (void) updateAccessoryViewsInTableView;
- (void) showAccessoryTickForCell:(UITableViewCell*)cell withValue:(NSString*)value enabled:(BOOL)enabled;

@end

@implementation BookingViewController

#pragma mark -
#pragma mark Accessory Mark Stuff

- (void) updateFieldColors {
	[self.givenNameTB setTextColor:placeholderTextColor];
	[self.surnameTB setTextColor:placeholderTextColor];
	[self.emailAddressTB setTextColor:placeholderTextColor];
	[self.addressTB setTextColor:placeholderTextColor];
	[self.phoneNumberTB setTextColor:placeholderTextColor];
	[self.flightNumberTB setTextColor:placeholderTextColor];
	
	if (self.givenNameTB.text != nil) {
		self.haveGivenName = YES;
		[self.givenNameTB setTextColor:fieldTextColor];
	}
		
	if (self.surnameTB.text != nil) {
		self.haveSurname = YES;
		[self.surnameTB setTextColor:fieldTextColor];
	}
		
	if (self.emailAddressTB.text != nil) {
		self.haveEmailAddress = YES;
		[self.emailAddressTB setTextColor:fieldTextColor];
	}
		
	if (self.addressTB.text != nil) {
		self.haveAddress = YES;
		[self.addressTB setTextColor:fieldTextColor];
	}
		
	if (self.phoneNumberTB.text != nil) {
		self.havePhoneNumber = YES;
		[self.phoneNumberTB setTextColor:fieldTextColor];
	}
		
	if (self.flightNumberTB.text != nil) {
		self.haveFlightNumber = YES;
		[self.flightNumberTB setTextColor:fieldTextColor];
	}
		
	
	[self updateAccessoryViewsInTableView];
}

- (void) updateAccessoryViewsInTableView {
	
	UITableViewCell *cell;
	
	// Section 0 - Personal Details
	
	cell = [self.bookingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:self.givenNameTB.text enabled:self.haveGivenName];
	
	cell = [self.bookingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:self.surnameTB.text enabled:self.haveSurname];
	
	cell = [self.bookingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:self.emailAddressTB.text enabled:self.haveEmailAddress];
	
	cell = [self.bookingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:self.addressTB.text enabled:self.haveAddress];
	
	cell = [self.bookingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:self.phoneNumberTB.text enabled:self.havePhoneNumber];
	
	cell = [self.bookingTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
	[self showAccessoryTickForCell:cell withValue:self.flightNumberTB.text enabled:self.haveFlightNumber];
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
	
	if (self.acceptedConditions && self.acceptedEngineTerms) {
		[self.acceptConditionsButton setSelected:YES];
	}
}

- (void) engineTermsAccepted:(NSNotification *)notify  {
	self.acceptedEngineTerms = YES;	
	
	if (self.acceptedConditions && self.acceptedEngineTerms) {
		[self.acceptConditionsButton setSelected:YES];
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
	
	if (self.acceptedConditions && self.acceptedEngineTerms) {
		[self.acceptConditionsButton setSelected:NO];
		self.acceptedConditions = NO;
		self.acceptedEngineTerms = NO;
	} else {
		[self.acceptConditionsButton setSelected:YES];
		self.acceptedConditions = YES;
		self.acceptedEngineTerms = YES;
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
	
	if ([self.session.extras count] > 0) {
		for (ExtraEquipment *e in self.session.extras) {
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
	
	for (ExtraEquipment *e in self.session.extras) {
		if (e.qty > 0) {
			[includedExtras addObject:e];
		}
	}
	//[includedExtras release];
}

#pragma mark -
#pragma mark Success and Failure View Controller creation

- (void) resetTableOffset {
	[self.bookingTable setContentOffset:CGPointMake(0, 0) animated:YES];
	[self.bookingTable setScrollEnabled:YES];
}

- (void) scrollTableOffset:(NSIndexPath*)indexPath {
	NSInteger ypos = [indexPath row]*[self.bookingTable rowHeight];
	DLog(@"ypos is %li", (long)ypos);
	[self.bookingTable setContentOffset:CGPointMake(0, ypos) animated:YES];
	[self.bookingTable setScrollEnabled:YES];
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
	if (self.acceptedConditions) {
		
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
		
		if (self.session.theCar.needCCInfo || self.session.hasBoughtInsurance) {
			if (self.ccNumberTB.text == nil) {
				[CTHelper showAlert:@"Missing Information" message:@"You must include a credit card number."];
			} else if (self.ccExpDateTB.text == nil) {
				[CTHelper showAlert:@"Missing Information" message:@"You must include an expiry date for your credit card."];
			} else if (self.ccHolderNameTB.text == nil) {
				[CTHelper showAlert:@"Missing Information" message:@"Please include the credit card holder's name."];
			} else if (self.ccSeriesCodeTB.text == nil) {
				[CTHelper showAlert:@"Missing Information" message:@"Please include the credit card's CCV code."];
			} else if ([self.selectedCardType isEqualToString:@""]) {
				[CTHelper showAlert:@"Missing Information" message:@"You must select a credit card type."];
			}
		} 
		
		// Personal detail are always required, so go through those and then proceed with the request.
		
		if (self.emailAddressTB.text == nil) {
			[CTHelper showAlert:@"Missing Information" message:@"An email address is required."];
		} else if (self.givenNameTB.text == nil) {
			[CTHelper showAlert:@"Missing Information" message:@"Given name is required."];
		} else if (self.surnameTB.text == nil) {
			[CTHelper showAlert:@"Missing Information" message:@"Surname is required."];
		} else if (self.emailAddressTB.text == nil) {
			[CTHelper showAlert:@"Missing Information" message:@"An email address is required."];
		} else {
			self.hud = [[CTHudViewController alloc] initWithTitle:@"Creating reservation"];
			[self.hud show];
			
			ASIHTTPRequest *request;
			
			if (self.session.theCar.needCCInfo || self.session.hasBoughtInsurance) {
				DLog(@"Payment needed");
				NSString *requestString = [CTRQBuilder OTA_VehResRQ:self.session.puDateTime returnDateTime:self.session.doDateTime 
												 pickupLocationCode:self.session.puLocationCode dropoffLocationCode:self.session.doLocationCode 
														homeCountry:self.session.homeCountry driverAge:self.session.driverAge 
													  numPassengers:self.session.numPassengers flightNumber:self.flightNumberTB.text refID:self.session.theCar.refID 
													   refTimeStamp:self.session.theCar.refTimeStamp refURL:self.session.theCar.refURL 
													   extrasString:extrasStr
														 namePrefix:@"Mr."
														  givenName:self.givenNameTB.text
															surName:self.surnameTB.text
													   emailAddress:self.emailAddressTB.text
															address:self.addressTB.text
														phoneNumber:self.phoneNumberTB.text
														   cardType:self.selectedCardType
														 cardNumber:self.ccNumberTB.text
													 cardExpireDate:self.ccExpDateTB.text
													 cardHolderName:self.ccHolderNameTB.text
													  cardCCVNumber:self.ccSeriesCodeTB.text
													insuranceObject:self.session.insurance
												  isBuyingInsurance:self.session.hasBoughtInsurance];
				if (kShowRequest) {
					DLog(@"\n\n%@\n\n", requestString);
				}
				
				request = [CTHelper makeRequest:kOTA_VehResRQ tail:requestString];
				
			} else {
				DLog(@"No payment needed");
				NSString *requestStringNoPayment = [CTRQBuilder OTA_VehResRQNoPayment:self.session.puDateTime returnDateTime:self.session.doDateTime 
												 pickupLocationCode:self.session.puLocationCode dropoffLocationCode:self.session.doLocationCode 
														homeCountry:self.session.homeCountry driverAge:self.session.driverAge 
													  numPassengers:self.session.numPassengers flightNumber:self.flightNumberTB.text refID:self.session.theCar.refID 
													   refTimeStamp:self.session.theCar.refTimeStamp refURL:self.session.theCar.refURL 
													   extrasString:extrasStr
														 namePrefix:@"Mr."
														  givenName:self.givenNameTB.text
															surName:self.surnameTB.text
													   emailAddress:self.emailAddressTB.text
														  address:self.addressTB.text
													  phoneNumber:self.phoneNumberTB.text];
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
		
		[b setCustomerEmail:self.emailAddressTB.text];
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
	[self.givenNameTB setPlaceholder:@"Given name"];
	[self.surnameTB setPlaceholder:@"Surname"];
	[self.emailAddressTB setPlaceholder:@"me@example.com"];
	[self.addressTB setPlaceholder:@"1 My House, My Street, London"];
	[self.phoneAreaCodeTB setPlaceholder:@"01"];
	[self.phoneNumberTB setPlaceholder:@"Phone number"];
	[self.countryCodeTB setPlaceholder:@"Country"];
	[self.flightNumberTB setPlaceholder:@"Flight number"];
	
	[self.visaMasterSegment setSelectedSegmentIndex:0];
	[self.ccHolderNameTB setPlaceholder:@"Card holder's name"];
	[self.ccNumberTB setPlaceholder:@"Card number"];
	[self.ccExpDateTB setPlaceholder:@"MMYY"];
	[self.ccSeriesCodeTB setPlaceholder:@"123"];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
	[self getExtras];

	self.selectedCardType = @"";
	
	if (![self.session.puLocationNameString isEqualToString:self.session.doLocationNameString]) {
		self.hasAlternateDropOff = YES;
		DLog(@"There is alternate drop off!");
		[self.overViewCell setFrame:CGRectMake(0, 0, self.overViewCell.frame.size.width, 184)];		
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(termsAndConditionsAccepted:) name:@"termsAndConditionsAccepted" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(engineTermsAccepted:) name:@"engineTermsAccepted" object:nil];
	
	UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleBordered target:self action:@selector(resetPersonalDetails)];
	self.navigationItem.rightBarButtonItem = rightBarButton;
	//[rightBarButton release];
	
	[self.bookingTable setContentInset:UIEdgeInsetsMake(17,0,0,0)];
	
	self.title = @"Place Booking";
	self.navigationItem.titleView = [CTHelper getNavBarLabelWithTitle:@"Book Car"];
	
	self.bookingTable.backgroundColor = [UIColor clearColor];
    self.bookingTable.backgroundView = nil;
	
	//Personal Details
	
	self.givenNameTB = [self newTextField];
	
	self.surnameTB = [self newTextField];
	
	self.emailAddressTB = [self newTextField];
	[self.emailAddressTB setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.emailAddressTB setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.emailAddressTB setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	
	self.self.addressTB = [self newTextField];
	
	self.phoneAreaCodeTB = [self newTextField];
	
	self.phoneNumberTB = [self newTextField];
	[self.phoneNumberTB setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	
	self.countryCodeTB = [self newTextField];
	
	//Payment Details
	
	self.ccHolderNameTB = [self newTextField];
	
	self.ccNumberTB = [self newTextField];
	[self.ccNumberTB setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	
	self.ccExpDateTB = [self newTextField];
	[self.ccExpDateTB setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	
	self.ccSeriesCodeTB = [self newTextField];
	[self.ccSeriesCodeTB setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	self.ccSeriesCodeTB.returnKeyType = UIReturnKeyDone;
	
	self.flightNumberTB = [self newTextField];
	self.flightNumberTB.returnKeyType = UIReturnKeyDone;
	
	self.haveGivenName = NO;
	self.haveSurname = NO;
	self.haveAddress = NO;
	self.haveEmailAddress = NO;
	self.havePhoneNumber = NO;
	self.haveFlightNumber = NO;
	
	[self setPlaceholders];
	[self loadUserPrefs];
}

- (void) resetPersonalDetails {
	[self resignFirstResponder];
	[self resetTableOffset];
	
	// Clear TBs
	
	[self.nameTB setText:@""];
	[self.namePrefixTB setText:@""];
	[self.givenNameTB setText:@""];
	[self.surnameTB setText:@""];
	[self.emailAddressTB setText:@""];
	[self.addressTB setText:@""];
	[self.phoneAreaCodeTB setText:@""];
	[self.phoneNumberTB setText:@""];
	[self.countryCodeTB setText:@""];
	[self.flightNumberTB setText:@""];
	
	[self.nameTB resignFirstResponder];
	[self.namePrefixTB resignFirstResponder];
	[self.givenNameTB resignFirstResponder];
	[self.surnameTB resignFirstResponder];
	[self.emailAddressTB resignFirstResponder];
	[self.addressTB resignFirstResponder];
	[self.phoneAreaCodeTB resignFirstResponder];
	[self.phoneNumberTB resignFirstResponder];
	[self.countryCodeTB resignFirstResponder];
	[self.flightNumberTB resignFirstResponder];
	
	[self setPlaceholders];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated{
	[self saveUserPrefs];
	[super viewWillDisappear:animated];
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
	[self.bookingTable setContentOffset:CGPointMake(0, i) animated:YES];
	[self.bookingTable setScrollEnabled:YES];
}

#define editHeight 10

- (void) textFieldDidBeginEditing:(UITextField *)textField { }

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered {
	if (textField == self.ccNumberTB) {
		if (textField.text.length >= 16 && range.length == 0) {
			[textField resignFirstResponder];
			[self.ccExpDateTB becomeFirstResponder];
			return NO;
		}
		else {
			return YES;
		}
	} else if (textField == self.ccExpDateTB) {
		if (textField.text.length >= 4 && range.length == 0) {
			[textField resignFirstResponder];
			[self.ccSeriesCodeTB becomeFirstResponder];
			return NO;
		}
		else {
			return YES;
		}
	} else if (textField == self.ccSeriesCodeTB) {
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
    
	if (textField == self.givenNameTB) {

		//[textField resignFirstResponder];
		[self.surnameTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 44];
		
	} else if (textField == self.surnameTB) {
		//[textField resignFirstResponder];
		[self.emailAddressTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 88];
		
	} else if (textField == self.emailAddressTB) {
		
		//[textField resignFirstResponder];
		[self.addressTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 132];
		
	} else if (textField == self.addressTB) {
		
		//[textField resignFirstResponder];
		[self.phoneNumberTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 176];
		
	} else if (textField == self.phoneNumberTB) {
		
		//[textField resignFirstResponder];
		
		if (self.session.puLocation.atAirport) {
			[self.flightNumberTB becomeFirstResponder];
			[self scrolltablePosition:editHeight + 220];
		} else {
			[self.ccHolderNameTB becomeFirstResponder];
			[self scrolltablePosition:editHeight + 220];
		}

	} else if (textField == self.flightNumberTB) {
		
		//[textField resignFirstResponder];
		[self.ccHolderNameTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 264];
		
	} else if (textField == self.ccHolderNameTB) {
		
		//[textField resignFirstResponder];
		[self.ccNumberTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 304];
		
	} else if (textField == self.ccNumberTB) {
		
		//[textField resignFirstResponder];
		[self.ccExpDateTB becomeFirstResponder];
		[self scrolltablePosition:editHeight + 348];
		
	} else if (textField == self.ccExpDateTB) {
		
		//[textField resignFirstResponder];
		[self.ccSeriesCodeTB becomeFirstResponder];
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
		if (self.hasAlternateDropOff) {
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
		if (self.session.puLocation.atAirport) {
			return 6;
		} else {
			return 5;
		}
	} else if (section == 1) {
		if (self.session.theCar.needCCInfo || self.session.hasBoughtInsurance) { // Do we need to ask for cc details?
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
		if (self.hasAlternateDropOff) {
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
			[self.nameTB setPlaceholder:@"Given name"];
			[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
			[cell.contentView addSubview:self.givenNameTB];
		} else if (indexPath.row == 1) {
			[self.nameTB setPlaceholder:@"Surname"];
			[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
			[cell.contentView addSubview:self.surnameTB];
		} else if (indexPath.row == 2) {
			[self.emailAddressTB setPlaceholder:@"Email"];
			[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
			[cell.contentView addSubview:self.emailAddressTB];
		} else if (indexPath.row == 3) {
			[self.addressTB setPlaceholder:@"Address"];
			[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
			[cell.contentView addSubview:self.addressTB];
		} else if (indexPath.row == 4) {
			[self.phoneNumberTB setPlaceholder:@"Phone"];
			[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
			[cell.contentView addSubview:self.phoneNumberTB];
		} else {
			if (self.session.puLocation.atAirport) {
				[self.flightNumberTB setPlaceholder:@"Flight number"];
				[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
				[cell.contentView addSubview:self.flightNumberTB];
			}
		}
	} 
	else if (indexPath.section == 1) {
		if (self.session.theCar.needCCInfo || self.session.hasBoughtInsurance) { // Do we need to ask for cc details?
			if (indexPath.row == 0) {
				self.visaButton = [UIButton buttonWithType:UIButtonTypeCustom];
				
				self.visaButton.frame = CGRectMake(100, 5, 80, 35);
				[self.visaButton setImage:[UIImage imageNamed:@"visaIconInactive.png"] forState:UIControlStateNormal];
				[self.visaButton setImage:[UIImage imageNamed:@"visaIconActive.png"] forState:UIControlStateSelected];
				[self.visaButton setTitle:@"" forState:UIControlStateNormal];
				[self.visaButton addTarget:self action:@selector(visaButtonPressed) forControlEvents:UIControlEventTouchUpInside];
				
				[cell addSubview:self.visaButton];
				[self.view bringSubviewToFront:self.visaButton];
				
				self.mastercardButton = [UIButton buttonWithType:UIButtonTypeCustom];
				
				//set the position of the button
				self.mastercardButton.frame = CGRectMake(180, 5, 80, 35);
				[self.mastercardButton setImage:[UIImage imageNamed:@"mastercardIconInactive.png"] forState:UIControlStateNormal];
				[self.mastercardButton setImage:[UIImage imageNamed:@"mastercardIconActive.png"] forState:UIControlStateSelected];
				
				[self.mastercardButton setTitle:@"" forState:UIControlStateNormal];
				[self.mastercardButton addTarget:self action:@selector(mastercardButtonPressed) forControlEvents:UIControlEventTouchUpInside];
				
				[cell addSubview:self.mastercardButton];
				[self.view bringSubviewToFront:self.mastercardButton];
				
			} 
			else if (indexPath.row == 1) {
				// Name on Card
				[self.ccHolderNameTB setPlaceholder:@"Cardholder's name"];
				[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
				[cell.contentView addSubview:self.ccHolderNameTB];
			} else if (indexPath.row == 2) {
				// Number
				[self.ccNumberTB setPlaceholder:@"Card number"];
				[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
				[cell.contentView addSubview:self.ccNumberTB];
			} else if (indexPath.row == 3) {
				// Exp
				[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
				[cell.contentView addSubview:self.ccExpDateTB];
			} else if (indexPath.row == 4) {
				// Security Number
				[self.ccSeriesCodeTB setPlaceholder:@"CVS"];
				[cell setFrame:CGRectMake(kSmallLeftInset, kHeightInset, kInputItemWidth, kTextFieldHeight)];
				[cell.contentView addSubview:self.ccSeriesCodeTB];
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
		self.overViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell = self.overViewCell;
		
		//------------------------------------------------------------------------------------------------
		[self.carCategoryLabel setText:[CTHelper getVehcileCategoryStringFromNumber:[NSString stringWithFormat:@"%li", (long)self.session.theCar.vehicleClassSize]]];
		//[carCategoryLabel setText:session.theCar.vehicleCategory];
		
		[self.numberOfPeopleLabel setText:[NSString stringWithFormat:@"x%li", (long)self.session.theCar.passengerQtyInt]];
		[self.baggageLabel setText:[NSString stringWithFormat:@"x %@", self.session.theCar.baggageQty]];
		[self.numberOfDoorsLabel setText:[NSString stringWithFormat:@"%@", self.session.theCar.doorCount]];
		
		[self.pickUpLocationLabel setText:self.session.puLocationNameString];
		[self.dropOffLocationLabel setText:self.session.doLocationNameString];
		
		[self.pickUpDateLabel setText:self.session.readablePuDateTimeString];
		[self.dropOffDateLabel setText:self.session.readableDoDateTimeString];
		
		
		NSString *extrasStr = @"";
		
		if (![self.session.theCar.fuelType isEqualToString:@"Unspecified"]) {
			extrasStr = [extrasStr stringByAppendingFormat:@"- %@ ", self.session.theCar.fuelType];
		}
		
		if (self.session.theCar.transmissionType) {
			extrasStr = [extrasStr stringByAppendingFormat:@"- %@ ", self.session.theCar.transmissionType];
		}
		
		if (self.session.theCar.isAirConditioned) {
			extrasStr = [extrasStr stringByAppendingFormat:@"- Aircon "];
		}
		
		[self.extraFeaturesLabel setText:extrasStr];
		
		//------------------------------------------------------------------------------------------------
		
		CTTableViewAsyncImageView *thisImage = [[CTTableViewAsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 64.0, 40.0)];
		[self.carLogo addSubview:thisImage];
		
		NSURL *url = [NSURL URLWithString:self.session.theCar.pictureURL];
		[thisImage loadImageFromURL:url];
		
		if (self.session.theVendor.vendorName == NULL) {
			// No Vendor Name or Image supplied so cant draw anything.
		} else  {
			CTTableViewAsyncImageView *vendorImage = [[CTTableViewAsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 23.0)];
			[self.vendorLogo addSubview:vendorImage];
            if ([self.session.theVendor.venLogo isKindOfClass:[NSString class]] && self.session.theVendor.venLogo.length > 0)  {
                NSURL *urll = [NSURL URLWithString:self.session.theVendor.venLogo];
                [vendorImage loadImageFromURL:urll];
            }
		}
		
		if (self.hasAlternateDropOff) {	
			
			// Add new spacer
			
			UILabel *spacerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 274, 1)];
			[spacerLabel setBackgroundColor:[UIColor lightGrayColor]];
			[self.overViewCell addSubview:spacerLabel];
			
			// Add new Location name
			
			UILabel	*alternateDropOffLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 140, 258, 23)];
			[alternateDropOffLabel setBackgroundColor:[UIColor clearColor]];
			[alternateDropOffLabel setFont:[UIFont systemFontOfSize:12]];
			[alternateDropOffLabel setTextColor:[UIColor darkGrayColor]];
			[alternateDropOffLabel setText:self.session.doLocationNameString];
			[self.overViewCell addSubview:alternateDropOffLabel];
			
			// Add another spacer
			
			UILabel *anotherSpacerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 162, 274, 1)];
			[anotherSpacerLabel setBackgroundColor:[UIColor colorWithHexString:@"#dcdcdc"]];
			[self.overViewCell addSubview:anotherSpacerLabel];
			
			// Drop Off location Labels
			
			[self.dropOffHeaderLabel setFrame:CGRectMake(self.dropOffHeaderLabel.frame.origin.x, 165, self.dropOffHeaderLabel.frame.size.width, self.dropOffHeaderLabel.frame.size.height)];
			[self.dropOffDateLabel setFrame:CGRectMake(93, 163, 172, 19)];
			
		}
		
	} else if (indexPath.section == 3) {
		self.costCell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell = self.costCell;
		
		// Layout Costs Cell...this cell will probably only ever have 3 sections to it, maybe 2 (fees...)
		NSNumber *total = [NSNumber numberWithDouble:0.00];
		
		if (self.session.hasBoughtInsurance) {
			total = [NSNumber numberWithDouble:([[CTHelper convertStringToNumber:self.session.insurance.premiumAmount] doubleValue] + [total doubleValue])];
		}

		
		NSString *currentCurrency=@"EUR";
		if ([self.session.theCar.fees count] > 0) {
			
			for (Fee *f in self.session.theCar.fees) {
				NSString *cs = [CTHelper getCurrencySymbolFromString:f.feeCurrencyCode];
				currentCurrency = cs;
				
				if ([f.feePurpose isEqualToString:@"22"]) {
					// Deposit
					if (self.session.hasBoughtInsurance) {
						NSNumber *depositPlusInsurance = [NSNumber numberWithDouble:([total doubleValue] + [[CTHelper convertFeeFromStringToNumber:f] doubleValue])];
						[self.depositLabel setText:[NSString stringWithFormat:@"%@ %.2f", cs, [depositPlusInsurance doubleValue]]];
					} else {
						[self.depositLabel setText:[NSString stringWithFormat:@"%@ %.2f", cs, [[CTHelper convertFeeFromStringToNumber:f] doubleValue]]];
					}
					total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
					
				} else if ([f.feePurpose isEqualToString:@"23"]) {
					// Pay on Arrival
					[self.arrivalAmountLabel setText:[NSString stringWithFormat:@"%@ %.2f", cs, [[CTHelper convertFeeFromStringToNumber:f] doubleValue]]];
					total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
					
				} else if ([f.feePurpose isEqualToString:@"6"]) {
					// Booking Fee amount is added to the deposit.				
					total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
					
				}
			}
			[self.totalLabel setText:[NSString stringWithFormat:@"%@ %.2f", currentCurrency, [total doubleValue]]];
		}
		
		if ([[self getTotalCostOfExtrasWithCurrency:NO] isEqualToString:@"0.00"]) {
			self.extrasCostLabel.hidden = YES;
			self.extrasTitleLabel.hidden = YES;
		} else {
			[self.extrasCostLabel setText:[self getTotalCostOfExtrasWithCurrency:YES]];
		}
		
		// Add insurance premium if it's been bought in the confirmation.
		
		if (self.session.hasBoughtInsurance) {
			[self.insuranceCostTitleLabel setHidden:NO];
			[self.insuranceLabelForCostSection setHidden:NO];
			[self.insuranceLabelForCostSection setText:[NSString stringWithFormat:@"%@ %@", self.session.insurance.premiumCurrencyCode, self.session.insurance.premiumAmount]];
		} else {
			[self.insuranceCostTitleLabel setHidden:YES];
			[self.insuranceLabelForCostSection setHidden:YES];
			//[insuranceLabelForCostSection setText:@"(Not Included)"];
		}
		
		return self.costCell;
		
	} else if (indexPath.section == 4){
		self.termsCell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell = self.termsCell;
	} 
	
	return cell;
 }

- (void) mastercardButtonPressed {
	self.selectedCardType = @"MC";
	[self.visaButton setImage:[UIImage imageNamed:@"visaIconInactive.png"] forState:UIControlStateNormal];
	[self.mastercardButton setImage:[UIImage imageNamed:@"mastercardIconActive.png"] forState:UIControlStateNormal];
}

- (void) visaButtonPressed {
	self.selectedCardType = @"VI";
	[self.visaButton setImage:[UIImage imageNamed:@"visaIconActive.png"] forState:UIControlStateNormal];
	[self.mastercardButton setImage:[UIImage imageNamed:@"mastercardIconInactive.png"] forState:UIControlStateNormal];
}

- (void) saveUserPrefs {
	if (self.ctUserBookingDetails!=nil){
		
		self.ctUserBookingDetails.givenName = self.givenNameTB.text;
		self.ctUserBookingDetails.namePrefix = self.namePrefixTB.text;
		self.ctUserBookingDetails.surname = self.surnameTB.text;
		self.ctUserBookingDetails.phoneAreaCode = self.phoneAreaCodeTB.text;
		self.ctUserBookingDetails.phoneNumber = self.phoneNumberTB.text;
		self.ctUserBookingDetails.emailAddress = self.emailAddressTB.text;
		self.ctUserBookingDetails.address = self.addressTB.text;
		self.ctUserBookingDetails.countryCode = self.countryCodeTB.text;
		
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

		[prefs setValue:self.ctUserBookingDetails.givenName forKey:@"ctUserBookingDetails.givenName"];
		[prefs setValue:self.ctUserBookingDetails.namePrefix forKey:@"ctUserBookingDetails.namePrefix"];
		[prefs setValue:self.ctUserBookingDetails.surname forKey:@"ctUserBookingDetails.surname"];
		[prefs setValue:self.ctUserBookingDetails.phoneAreaCode forKey:@"ctUserBookingDetails.phoneAreaCode"];
		[prefs setValue:self.ctUserBookingDetails.phoneNumber forKey:@"ctUserBookingDetails.phoneNumber"];
		[prefs setValue:self.ctUserBookingDetails.emailAddress forKey:@"ctUserBookingDetails.emailAddress"];
		[prefs setValue:self.ctUserBookingDetails.address forKey:@"ctUserBookingDetails.address"];
		[prefs setValue:self.ctUserBookingDetails.countryCode forKey:@"ctUserBookingDetails.countryCode"];
		
		[prefs synchronize];
	}
}

- (void) loadUserPrefs {
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	self.ctUserBookingDetails = [[CTUserBookingDetails alloc] init];

	self.ctUserBookingDetails.givenName = [prefs valueForKey:@"ctUserBookingDetails.givenName"];
	self.ctUserBookingDetails.namePrefix = [prefs valueForKey:@"ctUserBookingDetails.namePrefix"];
	self.ctUserBookingDetails.surname = [prefs valueForKey:@"ctUserBookingDetails.surname"];
	self.ctUserBookingDetails.phoneAreaCode = [prefs valueForKey:@"ctUserBookingDetails.phoneAreaCode"];
	self.ctUserBookingDetails.phoneNumber = [prefs valueForKey:@"ctUserBookingDetails.phoneNumber"];
	self.ctUserBookingDetails.emailAddress = [prefs valueForKey:@"ctUserBookingDetails.emailAddress"];
	self.ctUserBookingDetails.address = [prefs valueForKey:@"ctUserBookingDetails.address"];
	self.ctUserBookingDetails.countryCode = [prefs valueForKey:@"ctUserBookingDetails.countryCode"];
	
	[self.givenNameTB setText:self.ctUserBookingDetails.givenName];
	[self.namePrefixTB setText:self.ctUserBookingDetails.namePrefix];
	[self.surnameTB setText:self.ctUserBookingDetails.surname];
	[self.phoneAreaCodeTB setText:self.ctUserBookingDetails.phoneAreaCode];
	[self.phoneNumberTB setText:self.ctUserBookingDetails.phoneNumber];
	[self.emailAddressTB setText:self.ctUserBookingDetails.emailAddress];
	[self.addressTB setText:self.ctUserBookingDetails.address];
	[self.countryCodeTB setText:self.ctUserBookingDetails.countryCode];
	
	//[self updateFieldColors];
}

@end
