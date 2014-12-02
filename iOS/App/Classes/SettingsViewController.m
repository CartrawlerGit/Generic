//
//  SettingsViewController.m
//  CarTrawler
//


#import "SettingsViewController.h"
#import "CarTrawlerAppDelegate.h"
#import "CTCountry.h"
#import "CTCurrency.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NSString+CSVParser.h"


#define SectionHeaderHeight 40


@interface SettingsViewController (Private)

- (void) saveUserPrefs;
- (void) loadUserPrefs;
- (void) showCurrencyPickerView;
- (void) showCountryPickerView;
- (void) resetTableOffset;

@end

@implementation SettingsViewController

@synthesize modalNavbar;
@synthesize modalDoneButton;
@synthesize infoLabel;
@synthesize fromMap;
@synthesize pickerView;
@synthesize aSwitch;
@synthesize aSlider;
@synthesize metricSlider;
@synthesize radiusLabel;
@synthesize countryLabel;
@synthesize currencyLabel;
@synthesize kmLabel;
@synthesize milesLabel;
@synthesize settingsTable;
@synthesize preloadedCountryList;
@synthesize preloadedCurrencyList;
@synthesize countryPickerView;
@synthesize currencyPickerView;
@synthesize countryPicker;
@synthesize currencyPicker;
@synthesize pickerModeLabel;
@synthesize homeCountryCode;
@synthesize homeCurrencyCode;
@synthesize ctCurrency;
@synthesize ctCountry;


- (id) init {
    self=[super initWithNibName:@"SettingsViewController" bundle:nil];
    return self;
}

- (id) initWithNibName:(NSString *)n bundle:(NSBundle *)b {
	
	return [self init];
}

- (void) viewDidUnload {
	self.aSwitch = nil;
	self.aSlider = nil;
	self.radiusLabel = nil;
	self.settingsTable = nil;
    [super viewDidUnload];
}

- (void) viewDidLoad {
	radiusSegment = [[UISegmentedControl alloc] initWithFrame: CGRectMake(135, 8, 140, 30)];
	mileKMSegment = [[UISegmentedControl alloc] initWithFrame: CGRectMake(135, 8, 140, 30)];
    CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [mileKMSegment setTintColor:appDelegate.governingTintColor];
	[radiusSegment setTintColor:appDelegate.governingTintColor];
	
	modalNavbar.frame = CGRectMake(0, 0, 320, 44);
	
	CGRect frame = self.settingsTable.frame;
	if (fromMap)
	{		
		frame.origin.y = 60;
	}
	else 
	{
		frame.origin.y = 0;
	}

	self.settingsTable.frame = frame;
	
	self.settingsTable.backgroundColor = [UIColor clearColor];
    self.settingsTable.backgroundView = nil;
	
    [super viewDidLoad];
	
	[self loadUserPrefs];
	
	aSlider.value = searchRadius;
	metricSlider.value = metric; 
}

- (void) viewDidDisappear:(BOOL)animated {
	fromMap = NO;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
    /*
	[radiusSegment release];
	[mileKMSegment release];
	[settingsTable release];
	[radiusLabel release];
	[aSwitch release];
	[aSlider release];
	[ctCountry release]; // ok?
	[ctCurrency release]; // ok?
	[infoLabel release];
	infoLabel = nil;

	[modalNavbar release];
	modalNavbar = nil;
	[modalDoneButton release];
	modalDoneButton = nil;

    [super dealloc];
     */
}

- (IBAction) dismissModalView:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Table view data source

- (void) sliderValueChanged:(id)sender {
	UISlider *slider = (UISlider *) sender;
	NSInteger tag = slider.tag;
	if (tag == 1)
	{
	radiusLabel.text = [NSString stringWithFormat:@"Search Radius (%.fkm)", slider.value];
	searchRadius = slider.value;
	[self saveUserPrefs];
	}
}

#pragma mark -
#pragma mark UITableView Stuff

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	CGRect rect = CGRectMake(0,0,292,45);
	
	UIView *view = [[UIView alloc] initWithFrame:rect];
	[view setContentMode:UIViewContentModeScaleToFill];
	[view setClipsToBounds:YES];
	[view setOpaque:NO];
	
	UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect] ;
	UIImage *image = [UIImage imageNamed:@"table_middle.png"];
	[imageview setImage:image];
	[view addSubview:imageview];
	
	//[imageview release];
	
	[cell insertSubview:view belowSubview:[cell backgroundView]];
} 

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 16;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 107;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
	
	CGRect rect = CGRectMake(0,0,292,16);
	UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
	UIImage *image = [UIImage imageNamed:@"table_header_short.png"];
	[imageview setImage:image];
	[view addSubview:imageview];
	
	return view;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 107)];
	CGRect rect = CGRectMake(0,0,292,67);
	UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
	UIImage *image = [UIImage imageNamed:@"table_button_footer.png"];
	[imageview setImage:image];
	[view addSubview:imageview];
	
	UIButton *closeBtn = [CTHelper getGreenUIButtonWithTitle:@"Done"];
	[closeBtn addTarget:self action:@selector(dismissModalView:) forControlEvents:UIControlEventTouchUpInside];
	
	[view addSubview:closeBtn];
	return view;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13.0]];

	if (indexPath.row == 0 )
	{
		
		[ radiusSegment insertSegmentWithTitle: @"10" atIndex: 0 animated: NO ];
		[ radiusSegment insertSegmentWithTitle: @"20" atIndex: 1 animated: NO ];
		[ radiusSegment insertSegmentWithTitle: @"50" atIndex: 2 animated: NO ];
		[ radiusSegment insertSegmentWithTitle: @"100" atIndex: 3 animated: NO ];
		
		radiusSegment.autoresizesSubviews = YES;
		
		if (radius == 10)
		{
			radiusSegment.selectedSegmentIndex = 0;
		}
		else if (radius == 20)
		{
			radiusSegment.selectedSegmentIndex = 1;
		}
		else if (radius == 50)
		{
			radiusSegment.selectedSegmentIndex = 2;
		}
		else 
		{
			radiusSegment.selectedSegmentIndex = 3;
		}
		 
//		radiusSegment.segmentedControlStyle = UISegmentedControlStyleBar;
		radiusSegment.tag = 1;
		radiusSegment.enabled = YES;
		[radiusSegment addTarget:self action:@selector(radiusSegment:) forControlEvents:UIControlEventValueChanged];
		[cell addSubview: radiusSegment];
		[self.view bringSubviewToFront:radiusSegment];		
		
		[cell.textLabel setText:@"Search Radius"];
	}
	else if (indexPath.row == 1 )
	{
		[ mileKMSegment insertSegmentWithTitle: @"Miles" atIndex: 0 animated: NO ];
		[ mileKMSegment insertSegmentWithTitle: @"KM" atIndex: 1 animated: NO ];
		mileKMSegment.selectedSegmentIndex = metric;
//		mileKMSegment.segmentedControlStyle = UISegmentedControlStyleBar;
		mileKMSegment.tag = 1;
		mileKMSegment.enabled = YES;
		[mileKMSegment addTarget:self action:@selector(mileKMSegment) forControlEvents:UIControlEventValueChanged];
		[cell addSubview: mileKMSegment];
		[self.view bringSubviewToFront:mileKMSegment];
		[cell.textLabel setText:@"Distance Metric"];
	}


	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark Segment Control

- (void) mileKMSegment{
	metric = mileKMSegment.selectedSegmentIndex;
	[self saveUserPrefs];
}

- (void) radiusSegment:(id)sender{
	if (radiusSegment.selectedSegmentIndex == 0)
	{
		radius = 10;
		//radius = 20;
	}
	else 	if (radiusSegment.selectedSegmentIndex == 1)
	{
		//radius = 10;
		radius = 20;
	
	}
	else 	if (radiusSegment.selectedSegmentIndex == 2)
	{
		//radius = 50;
		radius = 50;
		
	}
	else 	if (radiusSegment.selectedSegmentIndex == 3)
	{
		//radius = 100;
		radius = 100;

	}
	[self saveUserPrefs];
}

- (void) saveUserPrefs {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	[prefs setInteger:radius forKey:@"searchRadius"];
	[prefs setInteger:metric forKey:@"metric"];
	
	[prefs synchronize];
}

- (void) loadUserPrefs {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	metric = [prefs integerForKey:@"metric"];
	radius = [prefs integerForKey:@"searchRadius"];
	
}

@end
