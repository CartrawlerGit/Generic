//
//  SearchResultsViewController.m
//  CarTrawler
//

#import "SearchResultsViewController.h"
#import "VehAvailRSCore.h"
#import "Vendor.h"
#import "Car.h"
#import "CTTableViewAsyncImageView.h"
#import "CustomCarDisplayCell.h"
#import "ConfirmationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RentalConditionsViewController.h"
#import "RentalSession.h"
#import "Fee.h"
#import "AdvancedFilterViewController.h"
#import "CTSearchFilters.h"
#import "CarTrawlerAppDelegate.h"


#define SectionHeaderHeight 40

@implementation SearchResultsViewController

@synthesize sortedPriceAsc;
@synthesize sortedPriceDesc;
@synthesize sortedTypeAsc;
@synthesize sortedTypeDesc;
@synthesize hasSetFiltersAlready;
@synthesize noresultsLabel;
@synthesize segmentedControl;
@synthesize dayCount;
@synthesize carResultsArray;
@synthesize noResultsCell;
@synthesize session;
@synthesize activeCar;
@synthesize resultsCore;
@synthesize resultsTable;
@synthesize searchFilters;

#pragma mark -
#pragma mark Filtering

- (void) filterStuff {
	AdvancedFilterViewController *vc = [[AdvancedFilterViewController alloc] initWithNibName:@"AdvancedFilterViewController" bundle:nil];
	
	vc.delegate = self;
	
	if (searchFilters == nil) {
		vc.ctSearchFilters = searchFilters;
		[vc resetUIElements];
	}
	
	vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	[self presentViewController:vc animated:YES completion:nil];
	
	//[vc release];
}

#pragma mark -
#pragma mark Car Array Compilation

- (void) makeCarArray {
	if (!carResultsArray) {
		carResultsArray = [[NSMutableArray alloc] init];
	} else {
		[carResultsArray removeAllObjects];
	}
	
	for (int i = 0; i < [resultsCore.availableVendors count]; ++i) {
		Vendor *ven = [resultsCore.availableVendors objectAtIndex:i];
		for (Car *car in ven.availableCars) {
			[car setVendor:ven];
			[carResultsArray addObject:car];
			// This takes the car lists
		}
	}
	
	carResultsArrayOriginalQuery = [NSMutableArray arrayWithArray:carResultsArray];
	
	DLog(@"Total car count is %lu", (unsigned long)[carResultsArray count]);
}

#pragma mark -
#pragma mark Array Sort Descriptors

- (void) sortCarsByPriceAsc {
	
	// Have added totalPriceForThisVehicle in *Car 
	NSSortDescriptor *orderIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"totalPriceForThisVehicle" ascending:YES];
	//NSSortDescriptor *orderIndexSorter = [[[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES] autorelease];
	[carResultsArray sortUsingDescriptors:[NSArray arrayWithObject:orderIndexSorter]];
	[resultsTable reloadData];
	
}

- (void) sortCarsByPriceDesc {
	NSSortDescriptor *orderIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"totalPriceForThisVehicle" ascending:NO];
	[carResultsArray sortUsingDescriptors:[NSArray arrayWithObject:orderIndexSorter]];
	[resultsTable reloadData];
	
}

- (void) sortCarsByTypeAsc {
	NSSortDescriptor *orderIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"vehicleClassSize" ascending:YES];
	[carResultsArray sortUsingDescriptors:[NSArray arrayWithObject:orderIndexSorter]];
	[resultsTable reloadData];
}

- (void) sortCarsByTypeDesc{
	NSSortDescriptor *orderIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"vehicleClassSize" ascending:NO];
	[carResultsArray sortUsingDescriptors:[NSArray arrayWithObject:orderIndexSorter]];
	[resultsTable reloadData];
}

- (void) trackSorting {
	if (sortedPriceAsc) {
		[self sortCarsByPriceAsc];
	} else if (sortedPriceDesc) {
		[self sortCarsByPriceDesc];
	} else if (sortedTypeAsc) {
		[self sortCarsByTypeAsc];
	} else if (sortedTypeDesc) {
		[self sortCarsByTypeDesc];
	} 
	
	[self updateSegmentedControlLabels];
}

#pragma mark -
#pragma mark UISegmentedControl methods

- (void) changedSelectionValue:(id)sender {
	UISegmentedControl *sc = (UISegmentedControl *)sender;
	NSLog(@"changedSelectionValue");
	NSSortDescriptor *priceIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"totalPriceForThisVehicle" ascending:YES];
	//NSSortDescriptor *priceIndexSorter = [[[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES] autorelease];
	NSSortDescriptor *typeIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"vehicleClassSize" ascending:YES];
	NSSortDescriptor *vendorIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"vendor.vendorName" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:priceIndexSorter,typeIndexSorter,vendorIndexSorter,nil];
	
	if (selectedSegmentIndex == [segmentedControl selectedSegmentIndex]){
		ascending = !ascending;

	}
    if (!ascending) {
        sortedPriceAsc = NO;
        sortedPriceDesc = YES;
    } else {
        sortedPriceAsc = YES;
        sortedPriceDesc = NO;
    }
	selectedSegmentIndex = [segmentedControl selectedSegmentIndex];
	
	if ([segmentedControl numberOfSegments] > 2) {
		switch ([sc selectedSegmentIndex]) {
			case 2:{ // Toggle sort by Price
				priceIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"totalPriceForThisVehicle" ascending:ascending];
				//priceIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:ascending];
				sortDescriptors = [NSArray arrayWithObjects:priceIndexSorter,typeIndexSorter,vendorIndexSorter,nil];
				//[priceIndexSorter release];
			}
				break;
			case 1:{ // Toggle sort by vehicleCategory
				sortedPriceAsc = NO;
				sortedPriceDesc = NO;
				typeIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"vehicleClassSize" ascending:ascending];
				sortDescriptors = [NSArray arrayWithObjects:typeIndexSorter,priceIndexSorter,vendorIndexSorter,nil];
			}
				break;
			case 0:{ // Toggle sort by vendor.vendorName
				sortedPriceAsc = NO;
				sortedPriceDesc = NO;
				vendorIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"vendor.vendorName" ascending:ascending];
				sortDescriptors = [NSArray arrayWithObjects:vendorIndexSorter,priceIndexSorter,typeIndexSorter,nil];
			}
				break;
			default:
				break;
		}
	} else {
		switch ([sc selectedSegmentIndex]) {
			case 1:{ // Toggle sort by Price
				priceIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"totalPriceForThisVehicle" ascending:ascending];
				//priceIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:ascending];
				sortDescriptors = [NSArray arrayWithObjects:priceIndexSorter,typeIndexSorter,vendorIndexSorter,nil];
				//[priceIndexSorter release];
			}
				break;
			case 0:{ // Toggle sort by vehicleCategory
				sortedPriceAsc = NO;
				sortedPriceDesc = NO;
				typeIndexSorter = [[NSSortDescriptor alloc] initWithKey:@"vehicleClassSize" ascending:ascending];
				sortDescriptors = [NSArray arrayWithObjects:typeIndexSorter,priceIndexSorter,vendorIndexSorter,nil];
			}
				break;
			default:
				break;
		}
		
	}

	[self updateSegmentedControlLabels];
	[carResultsArray sortUsingDescriptors:sortDescriptors];
	
	// HERE BE DRAGONS
	// slightly eldritch results here, car.vehicleClassSize & car.vehicleCategory
	// don't appear to quite correspond to each other...
	//             ...the question is, should they?
	
	[resultsTable reloadData];
	
}

- (void) updateSegmentedControlLabels {
	if ([segmentedControl numberOfSegments] > 2) {
		[segmentedControl setTitle:@"Price" forSegmentAtIndex:2];
		[segmentedControl setTitle:@"Types" forSegmentAtIndex:1];
		[segmentedControl setTitle:@"Company" forSegmentAtIndex:0];
	} else {
		[segmentedControl setTitle:@"Price" forSegmentAtIndex:1];
		[segmentedControl setTitle:@"Types" forSegmentAtIndex:0];
	}
	
	NSString *selectedTitle = [segmentedControl titleForSegmentAtIndex:selectedSegmentIndex];
	NSString *sortDirection;
	if (ascending)
		sortDirection = kSortDirectionAsc;
	else
		sortDirection = kSortDirectionDesc;
	NSString *selectedTitleWithSort = [NSString stringWithFormat:@"%@ %@",selectedTitle,sortDirection];
	[segmentedControl setTitle:selectedTitleWithSort forSegmentAtIndex:selectedSegmentIndex];
}

#pragma mark -
#pragma mark UIViewController boilerplate

- (void) viewDidLoad {
    [super viewDidLoad];
    CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.searchFilters = nil;
	
	[self makeCarArray];
	
	[self sortCarsByPriceAsc];
	
	self.title = @"Results";
	
	self.navigationItem.titleView = [CTHelper getNavBarLabelWithTitle:@"Results"];
    
	[segmentedControl setTintColor:appDelegate.governingTintColor];
	
	[segmentedControl addTarget:self action:@selector(changedSelectionValue:) forControlEvents:UIControlEventValueChanged];
	
	UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleBordered target:self action:@selector(filterStuff)];
	//UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_filter_25x25.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(filterStuff)];
	self.navigationItem.rightBarButtonItem = filterButton;
	//[filterButton release];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    //[self.view setAlpha:0];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.view setAlpha:1];
	
	if (!hasSetFiltersAlready) {
		ascending = YES;
		hideCompanyFilter = NO;
		[segmentedControl setHidden:NO];
		[resultsTable setHidden:NO];
		[noresultsLabel setHidden:YES];
		
		if ([carResultsArray count]==0) {
			[segmentedControl setHidden:YES];
			[resultsTable setHidden:YES];
			[noresultsLabel setHidden:NO];
		} else if ([[(Car*)[carResultsArray objectAtIndex:0] vendor] vendorName]==nil) { // vendor object doesn't exist 
			if ([segmentedControl numberOfSegments]==3){ // segmented control still has the company button
				hideCompanyFilter = YES;
				[segmentedControl removeSegmentAtIndex:2 animated:NO]; // remove it
				
			}
		} 
		
		[self updateSegmentedControlLabels];
		
		// Always set price to be selected by default on load.
		
		if (hideCompanyFilter) {
			[segmentedControl setSelectedSegmentIndex:1];
		} else {
			[segmentedControl setSelectedSegmentIndex:2];
		}
	}
	hasSetFiltersAlready = YES;
	[super viewWillAppear:animated];
    
}



- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
	/*self.noResultsCell = nil;
	self.session = nil;
	self.activeCar = nil;
	self.resultsCore = nil;
	self.resultsTable = nil;*/
    [super viewDidUnload];
}

- (void) dealloc {
    /*
	[resultsTable release];
	[resultsCore release];
	[activeCar release];
	
	[session release];
	[noResultsCell release];
	[carResultsArray release];
	carResultsArray = nil;
	
	
	[segmentedControl release];
	segmentedControl = nil;
	
	[noresultsLabel release];
	noresultsLabel = nil;
     */
    //[super dealloc];
}

#pragma mark -
#pragma mark UITableView Stuff

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if ([carResultsArray count] == 0) {
		resultsTable.hidden = YES;
		[noresultsLabel setHidden:NO];
	} else {
		resultsTable.hidden = NO;
		[noresultsLabel setHidden:YES];
	}

	return [carResultsArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ResultItemCell";
	
	CustomCarDisplayCell *cell = (CustomCarDisplayCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCarDisplayCell" owner:self options:nil];
		cell = (CustomCarDisplayCell *)[nib objectAtIndex:0];
	}
	
	Car *car = (Car *)[carResultsArray objectAtIndex:indexPath.row];
	CTTableViewAsyncImageView *_thisImage = [[CTTableViewAsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 64.0, 40.0)];
	[cell.vendorImageView addSubview:_thisImage];
	[cell.vendorImageView setHidden:hideCompanyFilter];

	if ([car.vendor.venLogo isKindOfClass:[NSString class]] && car.vendor.venLogo.length > 0) {
		NSURL *_url = [NSURL URLWithString:car.vendor.venLogo];
		[_thisImage loadImageFromURL:_url];
	}
	
	cell.totalLabel.layer.cornerRadius = 3;
	cell.currencyLabelBG.layer.cornerRadius = 3;
	
	NSNumber *total = [NSNumber numberWithDouble:0.00];
	NSString *currentCurrency;
	
	if ([car.fees count] > 0) {
		
		for (Fee *f in car.fees) {
			NSString *cs = [CTHelper getCurrencySymbolFromString:f.feeCurrencyCode];
			currentCurrency = cs;
            
			if ([f.feePurpose isEqualToString:@"22"]) {
				// Deposit
				//[depositLabel setText:[NSString stringWithFormat:@"%@ %.2f", cs, [[CTHelper convertFeeFromStringToNumber:f] doubleValue]]];
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
				
			} else if ([f.feePurpose isEqualToString:@"23"]) {
				// Pay on Arrival
				//[arrivalAmountLabel setText:[NSString stringWithFormat:@"%@ %.2f", cs, [[CTHelper convertFeeFromStringToNumber:f] doubleValue]]];
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
				
			} else if ([f.feePurpose isEqualToString:@"6"]) {
				// Booking Fee amount
				//[bookingFeeLabel setText:[NSString stringWithFormat:@"%@ %.2f", cs, [[CTHelper convertFeeFromStringToNumber:f] doubleValue]]];
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
				
			} else {
				DLog(@"Unknown Fee - %@ %@ %@ %@", f.feePurpose, f.feePurposeDescription, f.feeCurrencyCode, f.feeAmount);
				
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
			}
		
		}
		total = (NSNumber *)[CTHelper calculatePricePerDay:session price:total];
        DLog(@"Total calculatePricePerDay %@", total);
		[cell.totalLabel setText:[NSString stringWithFormat:@"%.02f", [total doubleValue]]];
		[cell.currencyLabel setText:[currentCurrency uppercaseString]];
	}

	// Set up the extras on the car cell (AC, Transmission etc)
	//------------------------------------------------------------------------------------------------
	[cell.infoLabel setText:[CTHelper getVehcileCategoryStringFromNumber:[NSString stringWithFormat:@"%li", (long)car.vehicleClassSize]]];
	[cell.carMakeModelLabel setText:car.vehicleMakeModelName];
	
	[cell.numberOfPeopleLabel setText:[NSString stringWithFormat:@"x%li", (long)car.passengerQtyInt]];
	[cell.baggageLabel setText:[NSString stringWithFormat:@"x%@", car.baggageQty]];
	[cell.numberOfDoorsLabel setText:[NSString stringWithFormat:@"x%@", car.doorCount]];
	
	NSString *extrasString = @"";
	
	if (![car.fuelType isEqualToString:@"Unspecified"]) {
		extrasString = [extrasString stringByAppendingString:[NSString stringWithFormat:@"- %@", car.fuelType]];
	}
	
	if (car.transmissionType) {
		extrasString = [extrasString stringByAppendingString:[NSString stringWithFormat:@"- %@ ", car.transmissionType]];
	}
	
	if (car.isAirConditioned) {
		extrasString = [extrasString stringByAppendingFormat:@"- Aircon "];
	}
	
	[cell.additionalExtrasLabel setText:extrasString];
	
	//------------------------------------------------------------------------------------------------
	
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	CTTableViewAsyncImageView *thisImage = [[CTTableViewAsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 64.0, 40.0)];
	
	[cell.carImageView addSubview:thisImage];
	
	NSURL *url = [NSURL URLWithString:car.pictureURL];
	[thisImage loadImageFromURL:url];
	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Car *car = (Car *)[carResultsArray objectAtIndex:indexPath.row];
	Car *selectedCar = [[Car alloc] init];
	
	for (int i = 0; i < [resultsCore.availableVendors count]; ++i) {
		Vendor *ven = [resultsCore.availableVendors objectAtIndex:i];
		for (Car *c in ven.availableCars) {
			[c setVendor:ven];
			if (car.orderIndex == c.orderIndex) {
				selectedCar = c;
				break;
			}
		}
	}
	
	ConfirmationViewController *cfvc = [[ConfirmationViewController alloc] initWithNibName:@"ConfirmationViewController" bundle:nil];
    
	[self.session appendVendorAndCarObjects:selectedCar theVendor:selectedCar.vendor];
	[self.session setDoLocationCode:selectedCar.vendor.dropoffVendor.locationCode];
	self.session.extras = selectedCar.extraEquipment;
	cfvc.session = session;
	
//	[FlurryAPI logEvent:[NSString stringWithFormat:@"Step 2: Selected %@ Car", [CTHelper getVehcileCategoryStringFromNumber:[NSString stringWithFormat:@"%i", car.vehicleClassSize]]]];
	
	[self.navigationController pushViewController:cfvc animated:YES ];
}

- (void) advancedFilterViewController:(AdvancedFilterViewController *)advancedFilterViewController didSaveFilterSettings:(CTSearchFilters*)ctSearchFilters {
	if (ctSearchFilters == nil) {
		carResultsArray = [NSMutableArray arrayWithArray:carResultsArrayOriginalQuery];
		
		[self trackSorting];
		
		[resultsTable reloadData];
		
		DLog(@"%s returning %lu items",__FUNCTION__,(unsigned long)[carResultsArray count]);
		return;
	}
	NSString *predicateString = [NSString stringWithFormat:@"%@",ctSearchFilters];
	DLog(@"Predicate String is %@", predicateString);
	if (![predicateString isEqualToString:@""]){
		NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
		carResultsArray = nil;
 		carResultsArray = [NSMutableArray arrayWithArray:[carResultsArrayOriginalQuery filteredArrayUsingPredicate:predicate]];
		[self trackSorting];
		searchFilters = ctSearchFilters;
		[resultsTable reloadData];
	} else {
		carResultsArray = [NSMutableArray arrayWithArray:carResultsArrayOriginalQuery];
		[self trackSorting];
		[resultsTable reloadData];
	}
	DLog(@"%s returning %lu items for (%@)",__FUNCTION__,(unsigned long)[carResultsArray count],predicateString);
}

@end
