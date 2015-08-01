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

@interface SettingsViewController ()

@property (nonatomic, strong) UISegmentedControl *mileKMSegment;
@property (nonatomic, strong) UISegmentedControl *radiusSegment;
@property (nonatomic, assign) NSInteger searchRadius;
@property (nonatomic, assign) NSInteger metric;
@property (nonatomic, assign) NSInteger radius;

@end

@interface SettingsViewController (Private)

- (void) saveUserPrefs;
- (void) loadUserPrefs;
- (void) showCurrencyPickerView;
- (void) showCountryPickerView;
- (void) resetTableOffset;

@end

@implementation SettingsViewController

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
	self.radiusSegment = [[UISegmentedControl alloc] initWithFrame: CGRectMake(135, 8, 140, 30)];
	self.mileKMSegment = [[UISegmentedControl alloc] initWithFrame: CGRectMake(135, 8, 140, 30)];
    CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.mileKMSegment setTintColor:appDelegate.governingTintColor];
	[self.radiusSegment setTintColor:appDelegate.governingTintColor];
	
	self.modalNavbar.frame = CGRectMake(0, 0, 320, 44);
	
	CGRect frame = self.settingsTable.frame;
	if (self.fromMap)
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
	
	self.aSlider.value = self.searchRadius;
	self.metricSlider.value = self.metric;
}

- (void) viewDidDisappear:(BOOL)animated {
	self.fromMap = NO;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
	self.radiusLabel.text = [NSString stringWithFormat:@"Search Radius (%.fkm)", slider.value];
	self.searchRadius = slider.value;
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
		
		[ self.radiusSegment insertSegmentWithTitle: @"10" atIndex: 0 animated: NO ];
		[ self.radiusSegment insertSegmentWithTitle: @"20" atIndex: 1 animated: NO ];
		[ self.radiusSegment insertSegmentWithTitle: @"50" atIndex: 2 animated: NO ];
		[ self.radiusSegment insertSegmentWithTitle: @"100" atIndex: 3 animated: NO ];
		
		self.radiusSegment.autoresizesSubviews = YES;
		
		if (self.radius == 10)
		{
			self.radiusSegment.selectedSegmentIndex = 0;
		}
		else if (self.radius == 20)
		{
			self.radiusSegment.selectedSegmentIndex = 1;
		}
		else if (self.radius == 50)
		{
			self.radiusSegment.selectedSegmentIndex = 2;
		}
		else 
		{
			self.radiusSegment.selectedSegmentIndex = 3;
		}
		 
//		radiusSegment.segmentedControlStyle = UISegmentedControlStyleBar;
		self.radiusSegment.tag = 1;
		self.radiusSegment.enabled = YES;
		[self.radiusSegment addTarget:self action:@selector(radiusSegment:) forControlEvents:UIControlEventValueChanged];
		[cell addSubview: self.radiusSegment];
		[self.view bringSubviewToFront:self.radiusSegment];
		
		[cell.textLabel setText:@"Search Radius"];
	}
	else if (indexPath.row == 1 )
	{
		[ self.mileKMSegment insertSegmentWithTitle: @"Miles" atIndex: 0 animated: NO ];
		[ self.mileKMSegment insertSegmentWithTitle: @"KM" atIndex: 1 animated: NO ];
		self.mileKMSegment.selectedSegmentIndex = self.metric;
//		mileKMSegment.segmentedControlStyle = UISegmentedControlStyleBar;
		self.mileKMSegment.tag = 1;
		self.mileKMSegment.enabled = YES;
		[self.mileKMSegment addTarget:self action:@selector(mileKMSegment) forControlEvents:UIControlEventValueChanged];
		[cell addSubview: self.mileKMSegment];
		[self.view bringSubviewToFront:self.mileKMSegment];
		[cell.textLabel setText:@"Distance Metric"];
	}


	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -
#pragma mark Segment Control

- (UISegmentedControl *) mileKMSegment{
	self.metric = self.mileKMSegment.selectedSegmentIndex;
	[self saveUserPrefs];
	return self.mileKMSegment;
}

- (void) radiusSegment:(id)sender{
	if (self.radiusSegment.selectedSegmentIndex == 0)
	{
		self.radius = 10;
		//radius = 20;
	}
	else if (self.radiusSegment.selectedSegmentIndex == 1)
	{
		//radius = 10;
		self.radius = 20;
	
	}
	else if (self.radiusSegment.selectedSegmentIndex == 2)
	{
		//radius = 50;
		self.radius = 50;
		
	}
	else if (self.radiusSegment.selectedSegmentIndex == 3)
	{
		//radius = 100;
		self.radius = 100;

	}
	[self saveUserPrefs];
}

- (void) saveUserPrefs {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	[prefs setInteger:self.radius forKey:@"searchRadius"];
	[prefs setInteger:self.metric forKey:@"metric"];
	
	[prefs synchronize];
}

- (void) loadUserPrefs {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	self.metric = [prefs integerForKey:@"metric"];
	self.radius = [prefs integerForKey:@"searchRadius"];
	
}

@end
