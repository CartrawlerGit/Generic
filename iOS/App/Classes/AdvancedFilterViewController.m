//
//  AdvancedFilterViewController.m
//  CarTrawler
//
//

#import "AdvancedFilterViewController.h"
#import "CarTrawlerAppDelegate.h"
#import "CTSearchFilters.h"
#import "Constants.h"

@implementation AdvancedFilterViewController

@synthesize delegate;
@synthesize ctSearchFilters;
@synthesize filterTable;
@synthesize peopleSegCtrl;
@synthesize fuelSegCtrl;
@synthesize transmissionSegCtrl;
@synthesize airConSegCtrl;

- (id) init {
  //  [super initWithNibName:@"AdvancedFilterViewController" bundle:nil];
	return self;
}

- (void) viewDidLoad {
//	[FlurryAPI logEvent:@"Step 2: Using Filters." timed:YES];
	
    CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	[filterTable setContentInset:UIEdgeInsetsMake(17,0,0,0)];
	[filterTable setOpaque:NO];
	[filterTable setBackgroundColor:[UIColor clearColor]];
	//[filterTable setBackgroundView:nil]; <- tut tut, this is iOS 3.2 only.
	
	CGRect frame = CGRectMake(80, 10.0, 180.0, 24.0);

	NSArray *items;
	
	items = [NSArray arrayWithObjects:@"≤ 2",@"≤ 4",@"≤ 6",@"All",nil];
	peopleSegCtrl = [[UISegmentedControl alloc] initWithItems:items];
	[peopleSegCtrl setTintColor:appDelegate.governingTintColor];
	[peopleSegCtrl setFrame:frame];
	[peopleSegCtrl setSegmentedControlStyle:UISegmentedControlStyleBezeled];
	
	items = [NSArray arrayWithObjects:@"Petrol",@"Diesel",@"Either",nil];
	fuelSegCtrl = [[UISegmentedControl alloc] initWithItems:items];
	[fuelSegCtrl setTintColor:appDelegate.governingTintColor];
	[fuelSegCtrl setFrame:frame];
	[fuelSegCtrl setSegmentedControlStyle:UISegmentedControlStyleBezeled];
	
	items = [NSArray arrayWithObjects:@"Auto",@"Manual",@"Either",nil];
	transmissionSegCtrl = [[UISegmentedControl alloc] initWithItems:items];
	[transmissionSegCtrl setTintColor:appDelegate.governingTintColor];
	[transmissionSegCtrl setFrame:frame];
	[transmissionSegCtrl setSegmentedControlStyle:UISegmentedControlStyleBezeled];
	
	items = [NSArray arrayWithObjects:@"Required",@"Not Required",nil];
	airConSegCtrl = [[UISegmentedControl alloc] initWithItems:items];
	[airConSegCtrl setTintColor:appDelegate.governingTintColor];
	[airConSegCtrl setFrame:frame];
	[airConSegCtrl setSegmentedControlStyle:UISegmentedControlStyleBezeled];

	if (ctSearchFilters==nil)
		[self setDefaultValues];
	[self loadFilters:nil];
}

- (id) initWithNibName:(NSString *)n bundle:(NSBundle *)b {
    return [self init];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
    [super viewDidUnload];
}

- (void) dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	CGRect rect = CGRectMake(0,0,292,45);
	
	UIView *view = [[UIView alloc] initWithFrame:rect];
	[view setContentMode:UIViewContentModeScaleToFill];
	[view setClipsToBounds:YES];
	[view setOpaque:NO];
	
	UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
	UIImage *image = [UIImage imageNamed:@"table_middle.png"];
	[imageview setImage:image];
	[view addSubview:imageview];
	
	[imageview release];
	
	[cell insertSubview:view belowSubview:[cell backgroundView]];
} 

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 16;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 122;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 16)] autorelease];
	
	CGRect rect = CGRectMake(0,0,292,16);
	UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
	UIImage *image = [UIImage imageNamed:@"table_header_short.png"];
	[imageview setImage:image];
	[view addSubview:imageview];
	
	return view;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 107)] autorelease];
	CGRect rect = CGRectMake(0,0,292,122);
	UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
	UIImage *image = [UIImage imageNamed:@"table_button_footer.png"];
	[imageview setImage:image];
	[view addSubview:imageview];
	
	UIButton *showAllBtn = [CTHelper getGreenUIButtonWithTitle:@"Use selected filters"];
	[showAllBtn addTarget:self action:@selector(saveFilters:) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *applySelectedBtn = [CTHelper getGreenUIButtonWithTitle:@"Reset filters"];
	[applySelectedBtn setFrame:CGRectMake(11, 67, 272, 46)];
	[applySelectedBtn addTarget:self action:@selector(resetForm:) forControlEvents:UIControlEventTouchUpInside];
	
	[view addSubview:applySelectedBtn];
	[view addSubview:showAllBtn];
	return view;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SearchItemCell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)  {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	[cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.tag = indexPath.row; // i.e. one of the SearchMenuItem enum items
	NSUInteger section = [indexPath section];
	NSUInteger row = [indexPath row];
	
	if (section == 0){
		switch (row) {
			case 0:{
				cell.textLabel.text = @"People";
				[cell.contentView addSubview:peopleSegCtrl];
				
			}
				break;
			case 1:{
				cell.textLabel.text = @"Fuel";
				[cell.contentView addSubview:fuelSegCtrl];
				
			}
				break;
			case 2:{
				cell.textLabel.text = @"Gearbox";
				[cell.contentView addSubview:transmissionSegCtrl];
				
			}
				break;
			case 3:{
				cell.textLabel.text = @"Aircon";
				[cell.contentView addSubview:airConSegCtrl];
				
			}
				break;
			default:
				break;
		}
	}	
	return cell;
}

#pragma mark -
#pragma mark IBActions

- (IBAction) dismissView:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadFilters:(id)sender{

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

	if ([prefs objectForKey:@"ctSearchFilters.people"]!=nil){
		ctSearchFilters = [[CTSearchFilters alloc] init];
		ctSearchFilters.people = [[prefs objectForKey:@"ctSearchFilters.people"] integerValue];
		ctSearchFilters.fuel = [[prefs objectForKey:@"ctSearchFilters.fuel"] integerValue];
		ctSearchFilters.transmission = [[prefs objectForKey:@"ctSearchFilters.transmission"] integerValue];
		ctSearchFilters.airCon = [[prefs objectForKey:@"ctSearchFilters.airCon"] integerValue];
	}
	
	if (ctSearchFilters!=nil){
		peopleSegCtrl.selectedSegmentIndex = ctSearchFilters.people;
		fuelSegCtrl.selectedSegmentIndex = ctSearchFilters.fuel;
		transmissionSegCtrl.selectedSegmentIndex = ctSearchFilters.transmission;
		airConSegCtrl.selectedSegmentIndex = ctSearchFilters.airCon;
	}
}

- (IBAction) saveFilters:(id)sender{
	//save filters
	ctSearchFilters = [[CTSearchFilters alloc] init];
	ctSearchFilters.people = peopleSegCtrl.selectedSegmentIndex;
	ctSearchFilters.fuel = fuelSegCtrl.selectedSegmentIndex;
	ctSearchFilters.transmission = transmissionSegCtrl.selectedSegmentIndex;
	ctSearchFilters.airCon = airConSegCtrl.selectedSegmentIndex;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:ctSearchFilters.people forKey:@"ctSearchFilters.people"];
	[prefs setInteger:ctSearchFilters.fuel forKey:@"ctSearchFilters.fuel"];
	[prefs setInteger:ctSearchFilters.transmission forKey:@"ctSearchFilters.transmission"];
	[prefs setInteger:ctSearchFilters.airCon forKey:@"ctSearchFilters.airCon"];
	[prefs synchronize];
	
	if(delegate && [delegate respondsToSelector:@selector(advancedFilterViewController:didSaveFilterSettings:)]) {
		[delegate advancedFilterViewController:self didSaveFilterSettings:ctSearchFilters];
	}
	
/*	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSString stringWithFormat:@"%d", ctSearchFilters.people], @"Filter: Number of people.",
								[NSString stringWithFormat:@"%d", ctSearchFilters.fuel], @"Filter: Fuel type.",
								[NSString stringWithFormat:@"%d", ctSearchFilters.transmission], @"Filter: Transmission Type.",
								[NSString stringWithFormat:@"%d", ctSearchFilters.airCon], @"Filter: Air Con.",
								nil];
	
//	[FlurryAPI logEvent:@"Step 2: Set Filter values." withParameters:dictionary];
	
//	[FlurryAPI endTimedEvent:@"Step 2: Using Filters." withParameters:nil];
 */
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setDefaultValues{
	ctSearchFilters = [[[CTSearchFilters alloc] init] retain];
	ctSearchFilters.people = 3;
	ctSearchFilters.fuel = 2;
	ctSearchFilters.transmission = 2;
	ctSearchFilters.airCon = 1;
	peopleSegCtrl.selectedSegmentIndex = 3;
	fuelSegCtrl.selectedSegmentIndex = 2;
	transmissionSegCtrl.selectedSegmentIndex = 2;
	airConSegCtrl.selectedSegmentIndex = 1;
}

- (IBAction) resetForm:(id)sender{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs removeObjectForKey:@"ctSearchFilters.people"];
	[prefs removeObjectForKey:@"ctSearchFilters.fuel"];
	[prefs removeObjectForKey:@"ctSearchFilters.transmission"];
	[prefs removeObjectForKey:@"ctSearchFilters.airCon"];
	
	[prefs synchronize];
	
	ctSearchFilters = nil;
	
	if(delegate && [delegate respondsToSelector:@selector(advancedFilterViewController:didSaveFilterSettings:)]) {
		[delegate advancedFilterViewController:self didSaveFilterSettings:nil];
	}
	
//	[FlurryAPI logEvent:@"Step 2: Reset Filters."];
	
//	[FlurryAPI endTimedEvent:@"Step 2: Using Filters." withParameters:nil];
	
	[self dismissViewControllerAnimated:YES completion:nil];
	
}

- (void) resetUIElements {
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs removeObjectForKey:@"ctSearchFilters.people"];
	[prefs removeObjectForKey:@"ctSearchFilters.fuel"];
	[prefs removeObjectForKey:@"ctSearchFilters.transmission"];
	[prefs removeObjectForKey:@"ctSearchFilters.airCon"];
	
	[prefs synchronize];
	
	ctSearchFilters = nil;
	[self setDefaultValues];
}

@end
