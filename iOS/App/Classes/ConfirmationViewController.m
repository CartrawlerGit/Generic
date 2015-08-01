//
//  ConfirmationViewController.m
//  CarTrawler
//

#import "ConfirmationViewController.h"
#import "BookingViewController.h"
#import "RentalSession.h"
#import "CustomCarDisplayCell.h"
#import "CTTableViewAsyncImageView.h"
#import "Car.h"
#import "Vendor.h"
#import "CarTrawlerAppDelegate.h"
#import "PricedCoverage.h"
#import "VehicleCharge.h"

#import "RentalConditionsViewController.h"
#import "Fee.h"
#import "ExtraEquipment.h"
#import "CustomExtrasCell.h"
#import "CustomIncludedItemCell.h"
#import "CTHudViewController.h"
#import "InsuranceObject.h"
#import "InsuranceTermsViewController.h"
#import "CTLocation.h"

#define FONT_SIZE 12.0f
#define CELL_CONTENT_WIDTH 274.0f
#define CELL_CONTENT_MARGIN 10.0f


@interface ConfirmationViewController (Private)

- (void) requestInsuranceDetails;

@end

@implementation ConfirmationViewController

@synthesize noInsuranceForThisRegion;
@synthesize insuranceCostTitleLabel;
@synthesize insuranceDetailView;
@synthesize findOutMoreButton;
@synthesize wantsMoreInsuranceInfo;
@synthesize dropOffHeaderLabel;
@synthesize insuranceLabelForCostSection;
@synthesize wantsInsuranceCover;
@synthesize extrasTitleLabel;
@synthesize buyInsuranceButton;
@synthesize insuranceTermsButton;
@synthesize basePremiumPriceLabel;
@synthesize insurancePriceLabel;
@synthesize calculatingLabel;
@synthesize insuranceSpinner;
@synthesize hasAlternateDropOff;
@synthesize extraFeaturesLabel;
@synthesize pickUpDateLabel;
@synthesize dropOffDateLabel;
@synthesize numberOfPeopleLabel;
@synthesize dropOffLocationLabel;
@synthesize pickUpLocationLabel;
@synthesize extrasCostLabel;
@synthesize insuranceCell;
@synthesize showInsurance;
@synthesize acceptedRentalTerms;
@synthesize acceptedEngineTerms;
@synthesize showExtras;
@synthesize extrasString;
@synthesize readConditionsButton;
@synthesize acceptConditionsButton;
@synthesize acceptedConditions;
@synthesize arrivalAmountLabel;
@synthesize depositLabel;
@synthesize bookingFeeLabel;
@synthesize extrasLabel;
@synthesize totalLabel;
@synthesize carCategoryLabel;
@synthesize vendorImageView;
@synthesize carMakeModelLabel;
@synthesize carImageView;
@synthesize transmissionType;
@synthesize fuelTypeImageView;
@synthesize acImageView;
@synthesize fuelLabel;
@synthesize baggageLabel;
@synthesize numberOfDoorsLabel;
@synthesize costCell;
@synthesize extrasCell;
@synthesize termsCell;
@synthesize vehicleCell;
@synthesize confirmationTable;
@synthesize session;

#pragma mark -
#pragma mark Insurance controls

// This is step 1 in insurance, all it does is expand the table.
- (IBAction) wantsMoreInsuranceInfoAction {
	wantsMoreInsuranceInfo = !wantsMoreInsuranceInfo;
	findOutMoreButton.hidden = wantsMoreInsuranceInfo;
	
	//[FlurryAPI logEvent:@"Step 2: Asked for more insurance information."];
	
	[confirmationTable reloadData];
}

// This is step 2 in insurance, which actually buys it & adds it to the active session.
- (IBAction) buyInsurance {
	wantsInsuranceCover = !wantsInsuranceCover;
	session.hasBoughtInsurance = !session.hasBoughtInsurance;
	
	[buyInsuranceButton setSelected:wantsInsuranceCover];
	
//	[FlurryAPI logEvent:@"Step 2: Has added insurance to booking."];
	
	[confirmationTable reloadData];
}

- (IBAction) presentInuranceTerms {
	InsuranceTermsViewController *ivc = [[InsuranceTermsViewController alloc] init];
	[ivc setIns:session.insurance];
	
//	[FlurryAPI logEvent:@"Step 2: Has read insurance to t&cs."];
	
	[self.navigationController presentViewController:ivc animated:YES completion:nil];
	//[ivc release];
}

#pragma mark -
#pragma mark Insurance API Calls

- (void) requestInsuranceDetails {
	findOutMoreButton.enabled = NO;
	if (!hasInsuranceObject) {
		[insuranceSpinner setHidden:NO];
		[insuranceSpinner startAnimating];
		[calculatingLabel setHidden:NO];
		[insurancePriceLabel setHidden:YES];
		[basePremiumPriceLabel setHidden:YES];
		[insuranceTermsButton setHidden:YES];
		[buyInsuranceButton setHidden:YES];
		[session printSession];
		
		//NSString *OTA_VehLocSearchRQString = [CTRQBuilder OTA_InsuranceDetailsRQ:[CTHelper getTotalFeesWithNoCurrencyFromSession:session] session:session];
		NSString *OTA_VehLocSearchRQString = [CTRQBuilder OTA_InsuranceDetailsRQ:[CTHelper getTotalFeesWithNoCurrencyFromSession:session] session:session destinationCountry:session.puLocation.countryCode];
		
		NSString *jsonString = [NSString stringWithFormat:@"{%@%@}", [CTRQBuilder buildHeader:kInsuranceHeader], OTA_VehLocSearchRQString];
		//NSString *jsonString = [NSString stringWithFormat:@"{%@%@}", kInsuranceHeader, OTA_VehLocSearchRQString];
		
		if (kShowResponse) {
			DLog(@"Request is \n\n%@\n\n", jsonString);
		}
		
		NSData *requestData = [NSData dataWithBytes: [jsonString UTF8String] length: [jsonString length]];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kCTTestAPISecure, kOTA_InsuranceQuoteRQ]];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
		[request setDelegate:self];
		[request appendPostData:requestData];
		[request setRequestMethod:@"POST"];
		[request setShouldStreamPostDataFromDisk:YES];
		[request setAllowCompressedResponse:YES];
		[request startAsynchronous];
	} else {
		[insurancePriceLabel setText:[NSString stringWithFormat:@"Price: %@%@", session.insurance.costCurrencyCode, session.insurance.costAmount]];
		[basePremiumPriceLabel setText:[NSString stringWithFormat:@"Base Premium: %@%@", session.insurance.premiumCurrencyCode, session.insurance.premiumAmount]];
	}

}

- (void) requestFinished:(ASIHTTPRequest *)request {
	NSString *responseString = [request responseString];
	NSDictionary *responseDict = [responseString JSONValue];
	
	if (kShowResponse) {
		DLog(@"Response is \n\n%@\n\n", responseString);
	}
	
	InsuranceObject *ins = [[InsuranceObject alloc] initFromDict:responseDict];
	[session setInsurance:ins];
	
	if (session.insurance.planID) {
		hasInsuranceObject = YES;
		
		[basePremiumPriceLabel setText:[NSString stringWithFormat:@"For just %@ %@ buy our Excess insurance and get covered!", session.insurance.premiumCurrencyCode, session.insurance.premiumAmount]];
	}
	
	//[ins release];
	
	[insuranceSpinner stopAnimating];
	[calculatingLabel setHidden:YES];
	[insurancePriceLabel setHidden:NO];
	[basePremiumPriceLabel setHidden:NO];
	[insuranceTermsButton setHidden:NO];
	[buyInsuranceButton setHidden:NO];
	findOutMoreButton.enabled = YES;
}

- (void) requestFailed:(ASIHTTPRequest *)request {
	if (kShowResponse) {
		DLog(@"Response is %@", [request responseString]);
	}
	
	[insuranceSpinner stopAnimating];
	[calculatingLabel setHidden:YES];
	NSError *error = [request error];
	DLog(@"Error is %@", error);
}

#pragma mark -
#pragma mark T&C controls

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

#pragma mark -
#pragma mark Pass to booking view

- (IBAction) bookThisThing:(id)sender {
	
	acceptedConditions = YES;
	
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:nil message:@"You must accept the rental & engine booking conditions to proceed." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
	if (acceptedConditions) {
		BookingViewController *bvc = [[BookingViewController alloc] initWithNibName:@"BookingViewController" bundle:nil] ;
		bvc.session = session;
//		[FlurryAPI logEvent:@"Step 2: Confirmed car selection."];
		[self.navigationController pushViewController:bvc animated:YES];
	} else {
		[myAlert show];
		//[myAlert release];
	}
}

#pragma mark -
#pragma mark Button actions

- (IBAction) readEngineConditionsPressed:(id)sender {
	RentalConditionsViewController *rcvc = [[RentalConditionsViewController alloc] init];
	rcvc.session = self.session;
	[rcvc setBookingEngineTermsAndConditions:YES];
	[self presentViewController:rcvc animated:NO completion:nil];
	//[rcvc release];
}

- (IBAction) readRentalConditionsPressed:(id)sender {
	
	RentalConditionsViewController *rcvc = [[RentalConditionsViewController alloc] init];
	rcvc.session = self.session;
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



- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
	
	[buyInsuranceButton setHidden:YES];
	[insuranceTermsButton setHidden:YES];
	// See if pickup & drop off locations are different
	
	if (![session.puLocationNameString isEqualToString:session.doLocationNameString]) {
		hasAlternateDropOff = YES;
		[vehicleCell setFrame:CGRectMake(0, 0, vehicleCell.frame.size.width, 184)];
		
	}
	showInsurance = NO;
	session.hasBoughtInsurance = NO;
	[confirmationTable setContentInset:UIEdgeInsetsMake(17,0,0,0)];

	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSEnumerator *enumerator = [session.extras reverseObjectEnumerator];
	for (id element in enumerator) {
		[array addObject:element];
	}
	session.extras = array;
	//[array release];
	
	
	[confirmationTable reloadData];
	
	self.title = @"Car Selection";
	self.navigationItem.titleView = [CTHelper getNavBarLabelWithTitle:@"Car Selection"];
	
	self.confirmationTable.backgroundColor = [UIColor clearColor];
    self.confirmationTable.backgroundView = nil;
	
	self.acceptedConditions = NO;
	self.wantsInsuranceCover = NO;
	
	if (!noInsuranceForThisRegion) {
		[self requestInsuranceDetails];
	}
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
    /*
	self.readConditionsButton = nil;
	self.acceptConditionsButton = nil;
	self.arrivalAmountLabel = nil;
	self.depositLabel = nil;
	self.bookingFeeLabel = nil;
	self.extrasLabel = nil;
	self.totalLabel = nil;
	self.carCategoryLabel = nil;
	self.vendorImageView = nil;
	self.carMakeModelLabel = nil;
	self.carImageView = nil;
	self.transmissionType = nil;
	self.fuelTypeImageView = nil;
	self.acImageView = nil;
	self.fuelLabel = nil;
	self.baggageLabel = nil;
	self.numberOfDoorsLabel = nil;
	self.costCell = nil;
	self.termsCell = nil;
	self.vehicleCell = nil;
	self.confirmationTable = nil;
	self.session = nil;
	self.extrasString = nil;
	self.insuranceCell = nil;
	*/
    [super viewDidUnload];
}




- (void) madeSelection:(id)sender {
	UISegmentedControl *thisSegmentedControl = (UISegmentedControl *)sender;
	
	if ( [thisSegmentedControl selectedSegmentIndex] == 0 ) {
		showExtras = NO;
		showInsurance = NO;
		[confirmationTable reloadData];
	} else if ([thisSegmentedControl selectedSegmentIndex] == 1) {
		showExtras = YES;
		showInsurance = NO;
		[confirmationTable reloadData];
	} else {
		showExtras = NO;
		showInsurance = YES;
		
		[confirmationTable reloadData];		
	}
}



- (NSString *) getTotalCostOfExtrasWithCurrency:(BOOL)withCurrency {
	double extrasTotal=0.0;
	NSString *currency=@"EUR";
	
	if ([session.extras count] > 0) {
		for (ExtraEquipment *e in session.extras) {
			extrasTotal += (e.qty * [e.chargeAmount doubleValue]);
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
#pragma mark UITableView Stuff

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	
	CGFloat height;
	
	if (indexPath.section == 0) {
		if (hasAlternateDropOff) {
			height = 186;
		} else {
			height = 168;
		}
	} else if (indexPath.section == 1) {
		if ([session.theCar.pricedCoverages count] > 0 || [session.theCar.vehicleCharges count] > 0) {
			
			NSString *allText = @"";
			
			for (PricedCoverage *pc in session.theCar.pricedCoverages) {
				allText = [allText stringByAppendingString:[NSString stringWithFormat:@"- %@\n", pc.chargeDescription]];
				//DLog(@"%@", pc.chargeDescription);
			}
		
			for (VehicleCharge *vc in session.theCar.vehicleCharges) {
				if (vc.isIncludedInRate) {
					//DLog(@"%@", vc.chargeDescription);
//					allText = [allText stringByAppendingFormat:[NSString stringWithFormat:@"- %@\n", vc.chargeDescription]];
				}
			}
			
			CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
			
//			CGSize size = [allText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            UIFont *font=[UIFont systemFontOfSize:FONT_SIZE];
            NSAttributedString * attributedText=[[NSAttributedString alloc] initWithString:allText attributes:@{ NSFontAttributeName: font}];
            CGRect rect=[attributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            CGSize size= rect.size;
			
			CGFloat h = MAX(size.height, 44.0f);
			
			height = (h + (CELL_CONTENT_MARGIN * 2)) + 110;
		} else {
			height = 1;
		}
		
	} else if (indexPath.section == 2) {
		// This is for the costs | extras
		if (showExtras) {
			height = 45;
		} else {
			height = 121;
		}
	} else if (indexPath.section == 3) { // Insurance
		if (wantsMoreInsuranceInfo) {
			height = 371;
		} else {
			height = 93;
		}
        // INSURANCE TEMPORARY REMOVE
        height = 0;
	} else {
		// This is for the Ts & Cs section
		height = 121;
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
    
    
	[view addSubview:imageview];
	
	//[imageview release];
	
	[cell insertSubview:view belowSubview:[cell backgroundView]];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	for (NSDictionary *region in appDelegate.insuranceRegions) {
		if ([self.session.homeCountry isEqualToString:[region objectForKey:@"countryCode"]]) {
			noInsuranceForThisRegion = NO;
			return 4;
		}
	}
	noInsuranceForThisRegion = YES;
	return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 2) {
		if (showExtras) {
			if ([session.extras count] == 0) {
				return  1;
			} else {
				return [session.extras count];
			}	
		}
	} 
	return 1;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (hasAlternateDropOff) {
			return 185;
		} else {
			return 167;
		}
	} else if (indexPath.section == 1) {
		
		CGFloat height;
		
		if ([session.theCar.pricedCoverages count] > 0 || [session.theCar.vehicleCharges count] > 0) {
			
			NSString *allText = @"";
			
			for (PricedCoverage *pc in session.theCar.pricedCoverages) {
				allText = [allText stringByAppendingFormat:@"- %@\n", pc.chargeDescription];
				//DLog(@"%@", pc.chargeDescription);
			}
			
			for (VehicleCharge *vc in session.theCar.vehicleCharges) {
				if (vc.isIncludedInRate) {
					//DLog(@"%@", vc.chargeDescription);
					allText = [allText stringByAppendingFormat:@"- %@\n", vc.chargeDescription];
				}
			}
			
			CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
			
			CGSize size = [allText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint];
			
			CGFloat h = MAX(size.height, 44.0f);
			
			height = (h + (CELL_CONTENT_MARGIN * 2)) + 40;
			//DLog(@"height is %f", height);
		} else {
			height = 0;
		}
		return height;
		
	} else if (indexPath.section == 2) {
		if (showExtras) {
			return 44;
		} else {
			// Height for prices...
			return 120;
		}
	} else if (indexPath.section == 3) { // Insurance
        // INSURANCE TEMPORARY REMOVE
        return 0;
		if (wantsMoreInsuranceInfo) {
			return 370;
		} else {
			return 92;
		}
	} 
	else {
		return 70;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 16.0;
    } else if (section == 2) {
		return 66;
	} else {
        return 18;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 3) {
		return 120.0;	 
	} else if (section == 2 && noInsuranceForThisRegion) {
		return 120.0;
	} 
	else {
		return 0;
	}
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
	
	if (section == 0) {
		
		//label.frame = CGRectMake(20, 3, 300, 30);
		
		CGRect rect = CGRectMake(0,0,292,16);
		UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
		UIImage *image = [UIImage imageNamed:@"table_header_short.png"];
		[imageview setImage:image];
		[view addSubview:imageview];
		
	} else if (section == 2) {
		
		CGRect rect = CGRectMake(0,0,292,66);
		UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
		UIImage *image = [UIImage imageNamed:@"table_middle.png"];
		[imageview setImage:image];
		[view setContentMode:UIViewContentModeScaleToFill];
		[view addSubview:imageview];
		
		NSArray *items = [NSArray arrayWithObjects:@"Cost", @"Extras", nil];
		UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        
        CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
		[segmentedControl setTintColor:appDelegate.governingTintColor];
        
		[segmentedControl setFrame:CGRectMake(10, 19, 274.0, 30.0)];
		[segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
		
		if (showExtras) {
			[segmentedControl setSelectedSegmentIndex:1];
		} else if (showInsurance) {
			[segmentedControl setSelectedSegmentIndex:2];
		} else {
			[segmentedControl setSelectedSegmentIndex:0];
		}
		
		[segmentedControl addTarget:self action:@selector(madeSelection:) forControlEvents:UIControlEventValueChanged];
		
		[view addSubview:segmentedControl];
		
	} else {
		CGRect rect = CGRectMake(0,0,292,18);
		UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
		UIImage *image = [UIImage imageNamed:@"table_middle.png"];
		[imageview setImage:image];
		[view setContentMode:UIViewContentModeScaleToFill];
		[view addSubview:imageview];
	}

	
	return view;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (section == 3 || (section == 2 && noInsuranceForThisRegion)) {
		
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 77)];
		CGRect rect = CGRectMake(0,0,292,77);
		UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
		UIImage *image = [UIImage imageNamed:@"table_button_footer.png"];
		[imageview setImage:image];
		[view addSubview:imageview];
		
		UIButton *confirmBtn = [CTHelper getGreenUIButtonWithTitle:@"Confirm & Proceed"];
		[confirmBtn addTarget:self action:@selector(bookThisThing:) forControlEvents:UIControlEventTouchUpInside];
		[confirmBtn setFrame:CGRectMake(confirmBtn.frame.origin.x, 18, confirmBtn.frame.size.width, confirmBtn.frame.size.height)];
		[view addSubview:confirmBtn];
		return view;
		
	} else {
		return nil;
	}
}

- (void) addExtras:(id)sender {
	UIButton *btn = (UIButton *)sender;
	ExtraEquipment *e = (ExtraEquipment *)[session.extras objectAtIndex:btn.tag];

	if ([e.description isEqualToString:@"Excess Insurance"]) {
		e.qty = 1;
	} else {
		if (e.qty <= 3) {
			e.qty += 1;
		}
	}
	
	/*NSDictionary *fd =*/ [NSDictionary dictionaryWithObjectsAndKeys:e.description, @"Extra item", nil];
//	[FlurryAPI logEvent:@"Step 2: Added Extra" withParameters:fd];
	
	[session.extras insertObject:e atIndex:btn.tag];
	[session.extras removeObjectAtIndex:(btn.tag + 1)];
	extrasTitleLabel.hidden = NO;
	extrasCostLabel.hidden = NO;
	[confirmationTable reloadData];
}

- (void) removeExtras:(id)sender {
	UIButton *btn = (UIButton *)sender;
	ExtraEquipment *e = (ExtraEquipment *)[session.extras objectAtIndex:btn.tag];
	if (e.qty != 0) {
		e.qty -= 1;
		[session.extras insertObject:e atIndex:btn.tag];
		[session.extras removeObjectAtIndex:(btn.tag + 1)];
		
	//	NSDictionary *fd = [NSDictionary dictionaryWithObjectsAndKeys:e.description, @"Extra item", nil];
	//	[FlurryAPI logEvent:@"Step 2: Removed Extra" withParameters:fd];
		
		[confirmationTable reloadData];	
	} else {
		DLog(@"Pop an error, it's already 0");
	}
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [termsCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[vehicleCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[extrasCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[costCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[insuranceCell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	if (indexPath.section == 0) {
		
		//------------------------------------------------------------------------------------------------
		[carCategoryLabel setText:[CTHelper getVehcileCategoryStringFromNumber:[NSString stringWithFormat:@"%li", (long)session.theCar.vehicleClassSize]]];
		
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
		[carImageView addSubview:thisImage];
		
		NSURL *url = [NSURL URLWithString:session.theCar.pictureURL];
		[thisImage loadImageFromURL:url];
		
		if (session.theVendor.vendorName == NULL) {
			// No Vendor Name or Image supplied so cant draw anything.
		} else  {
			CTTableViewAsyncImageView *vendorImage = [[CTTableViewAsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 23.0)];
			[vendorImageView addSubview:vendorImage];
{

            }
            if ([session.theVendor.venLogo isKindOfClass:[NSString class]] && session.theVendor.venLogo.length > 0)  {
                NSURL *urll = [NSURL URLWithString:session.theVendor.venLogo];
                [vendorImage loadImageFromURL:urll];
            }
		}
		
		if (hasAlternateDropOff) {	
			
			// Add new spacer
			
			UILabel *spacerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 274, 1)];
			[spacerLabel setBackgroundColor:[UIColor lightGrayColor]];
			[vehicleCell addSubview:spacerLabel];
			
			// Add new Location name
			
			UILabel	*alternateDropOffLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 140, 258, 23)];
			[alternateDropOffLabel setBackgroundColor:[UIColor clearColor]];
			[alternateDropOffLabel setFont:[UIFont systemFontOfSize:12]];
			[alternateDropOffLabel setTextColor:[UIColor darkGrayColor]];
			[alternateDropOffLabel setText:session.doLocationNameString];
			[vehicleCell addSubview:alternateDropOffLabel];
			
			// Add another spacer
			
			UILabel *anotherSpacerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 162, 274, 1)];
			[anotherSpacerLabel setBackgroundColor:[UIColor colorWithHexString:@"#dcdcdc"]];
			[vehicleCell addSubview:anotherSpacerLabel];
			
			// Drop Off location Labels
			
			[dropOffHeaderLabel setFrame:CGRectMake(dropOffHeaderLabel.frame.origin.x, 165, dropOffHeaderLabel.frame.size.width, dropOffHeaderLabel.frame.size.height)];
			[dropOffDateLabel setFrame:CGRectMake(93, 163, 172, 19)];

		}
		
		return vehicleCell;
	} 
	else if (indexPath.section == 1) {

		UITableViewCell *cell;
		UILabel *label = nil;
		
		UILabel	*totalPriceLabel;
		UILabel	*totalPriceAmountLabel;
		UILabel	*seperatorLabel;
		UILabel	*includedInPriceLabel;
		
		/*cell = */[tableView dequeueReusableCellWithIdentifier:@"Cell"];
		
		NSString *pricedCoverString = @"";
		
		if ([session.theCar.pricedCoverages count] > 0) {
			for (PricedCoverage *pc in session.theCar.pricedCoverages) {
				//DLog(@"%@", pc.chargeDescription);
				pricedCoverString = [pricedCoverString stringByAppendingFormat:@"- %@\n", pc.chargeDescription];
			}
		} 
		
		if ([session.theCar.vehicleCharges count] > 0) {
			for (VehicleCharge *vc in session.theCar.vehicleCharges) {
				if (vc.isIncludedInRate) {
					//DLog(@"%@", vc.chargeDescription);
					pricedCoverString = [pricedCoverString stringByAppendingFormat:@"- %@\n", vc.chargeDescription];
				}
			}
		} else {
			pricedCoverString = @"Nothing Included.";
		}
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, 130, 14)];
		[totalPriceLabel setTextColor:[UIColor colorWithHexString:@"#2c81f6"]];
		[totalPriceLabel setFont:[UIFont boldSystemFontOfSize:15]];
		[totalPriceLabel setNumberOfLines:1];
		[totalPriceLabel setText:@"Total rental cost:"];
        [totalPriceLabel setBackgroundColor:[UIColor clearColor]];
		
		totalPriceAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(166, 7, 102, 14)];
        totalPriceAmountLabel.textAlignment = NSTextAlignmentRight;
		[totalPriceAmountLabel setTextColor:[UIColor colorWithHexString:@"#2c81f6"]];
		[totalPriceAmountLabel setFont:[UIFont boldSystemFontOfSize:15]];
		[totalPriceAmountLabel setNumberOfLines:1];
		[totalPriceAmountLabel setBackgroundColor:[UIColor clearColor]];
		
		[totalPriceAmountLabel setText:[CTHelper getTotalFeesFromSession:session]];

		seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 274, 1)];
		[seperatorLabel setBackgroundColor:[UIColor colorWithHexString:@"#aaaaaa"]];
		
		includedInPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 34, 130, 14)];
		[includedInPriceLabel setTextColor:[UIColor colorWithHexString:@"#2c81f6"]];
		[includedInPriceLabel setFont:[UIFont boldSystemFontOfSize:12]];
		[includedInPriceLabel setNumberOfLines:1];
		[includedInPriceLabel setText:@"Included in price:"];
        [includedInPriceLabel setBackgroundColor:[UIColor clearColor]];
        
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		[label setLineBreakMode:NSLineBreakByWordWrapping];
		//[label setMinimumFontSize:FONT_SIZE];
		[label setNumberOfLines:0];
		[label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
		[label setTextColor:[UIColor colorWithHexString:@"#777c8b"]];
                [label setBackgroundColor:[UIColor clearColor]];
		[label setTag:1];
		
		if ([session.theCar.pricedCoverages count] > 0 || [session.theCar.vehicleCharges count] > 0) {
			[[cell contentView] addSubview:label];
			[[cell contentView] addSubview:totalPriceLabel];
			[[cell contentView] addSubview:totalPriceAmountLabel];
			[[cell contentView] addSubview:seperatorLabel];
			[[cell contentView] addSubview:includedInPriceLabel];
		}
	
		CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
		
		CGSize size = [pricedCoverString sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
		
		if (!label)
			label = (UILabel*)[cell viewWithTag:1];
		
		[label setText:pricedCoverString];
		[label setFrame:CGRectMake(CELL_CONTENT_MARGIN, 48, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
		
		return cell;
		
	} else if (indexPath.section == 3) {
		if (wantsMoreInsuranceInfo) {
            
			insuranceDetailView.frame = CGRectMake(10, 75, 270, 292);
			[insuranceCell addSubview:insuranceDetailView];
		}
		return insuranceCell;
	} 
	else {
		if (showExtras) {
			static NSString *CellIdentifier = @"CustomExtrasCell";
			
			CustomExtrasCell *cell = (CustomExtrasCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) 
			{
				NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomExtrasCell" owner:self options:nil];
				cell = (CustomExtrasCell *)[nib objectAtIndex:0];
			}
			
			if ([session.extras count] > 0) {
				ExtraEquipment *e = (ExtraEquipment *)[session.extras objectAtIndex:indexPath.row];
				/*
				if ([e.description isEqualToString:@"Excess Insurance"]) {
					[cell.extraNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
				} else {
					
				}*/
				cell.extraNameLabel.text = [NSString stringWithFormat:@"%@ \n(%@ %@ each)", e.description, e.currencyCode, e.chargeAmount];//e.description;
			
				cell.extraQtyLabel.text = [NSString stringWithFormat:@"%li", (long)e.qty];
				cell.plusBtn.tag = indexPath.row;
				cell.minusBtn.tag = indexPath.row;
				
				[cell.plusBtn addTarget:self action:@selector(addExtras:) forControlEvents:UIControlEventTouchUpInside];
				[cell.minusBtn addTarget:self action:@selector(removeExtras:) forControlEvents:UIControlEventTouchUpInside];
			} else {
				cell.extraNameLabel.text = @"No Extras available at this time.";
				cell.plusBtn.hidden = YES;
				cell.minusBtn.hidden = YES;
				cell.extraQtyLabel.hidden = YES;
			}
			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			return cell;
		} 
		else {
			// Layout Costs Cell...this cell will probably only ever have 3 sections to it, maybe 2 (fees...)
			NSNumber *total = [NSNumber numberWithDouble:0.00];
			
			if (wantsInsuranceCover) {
				total = [NSNumber numberWithDouble:([[CTHelper convertStringToNumber:session.insurance.premiumAmount] doubleValue] + [total doubleValue])];
			}
			
			NSString *currentCurrency;
			if ([session.theCar.fees count] > 0) {
				
				for (Fee *f in session.theCar.fees) {
					
					//DLog(@"Fee is %@ %@", f.feeAmount, f.feePurpose);
					
					NSString *cs = [CTHelper getCurrencySymbolFromString:f.feeCurrencyCode];
					currentCurrency = cs;
					
					if ([f.feePurpose isEqualToString:@"22"]) {
						// Deposit
						if (wantsInsuranceCover) {
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
			
			if (wantsInsuranceCover) {
				[insuranceCostTitleLabel setHidden:NO];
				[insuranceLabelForCostSection setHidden:NO];
				[insuranceLabelForCostSection setText:[NSString stringWithFormat:@"%@ %@", session.insurance.premiumCurrencyCode, session.insurance.premiumAmount]];
			} else {
				[insuranceCostTitleLabel setHidden:YES];
				[insuranceLabelForCostSection setHidden:YES];
				//[insuranceLabelForCostSection setText:@"(Not Included)"];
			}


			
			return costCell;
		}
	} 
}

@end
