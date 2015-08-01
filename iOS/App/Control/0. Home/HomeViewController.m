//
//  HomeViewController.m
//  CarTrawler
//
//

#import "HomeViewController.h"
#import "CarTrawlerAppDelegate.h"
#import "RentalSession.h"
#import "SearchViewController.h"
#import "MapSearchViewController.h"
#import "ManageViewController.h"
#import "LocationListViewController.h"
#import "BookingViewController.h"
#import "AdvancedFilterViewController.h"
#import "DataListViewController.h"
#import "CTCountry+Factory.h"
#import "CTCurrency.h"

#define kLocaleLabelStringFormat @"%@ (%@)"

@interface HomeViewController (Private)

- (void) saveCountryChoice;
- (void) showCountryPickerView;
- (void) saveUserPrefs;
- (void) loadUserPrefs;

@end

@implementation HomeViewController

- (void) viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBar.hidden = YES;
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.preloadedCountryList = appDelegate.preloadedCountryList;
	
    
	[self loadUserPrefs];
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:YES];
	
    [self.countryPickerView setHidden:YES];
	[self loadUserPrefs];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
    [super viewDidUnload];
}
#pragma mark -
#pragma mark IBActions

- (IBAction) showCurrencyList {
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	DataListViewController *dlvc = [[DataListViewController alloc] init];
	
	dlvc.currencyMode = YES;
	dlvc.tableContents = appDelegate.preloadedCurrencyList;
	
	[self.navigationController presentViewController:dlvc animated:YES completion:nil];
	//[dlvc release];
}

- (IBAction) showCountryList {
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	DataListViewController *dlvc = [[DataListViewController alloc] init];
	
	dlvc.countryMode = YES;
	dlvc.tableContents = appDelegate.preloadedCountryList;
	
	[self.navigationController presentViewController:dlvc animated:YES completion:nil];
	//[dlvc release];
}

- (IBAction) makeReservationButton:(id)sender{
	CarTrawlerAppDelegate *delegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate.tabBarController setSelectedIndex:1];
}

- (IBAction) nearbyLocationsButton:(id)sender{
	CarTrawlerAppDelegate *delegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate.tabBarController setSelectedIndex:2];
}

- (IBAction) callUsButton:(id)sender {
	CarTrawlerAppDelegate *delegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate.tabBarController setSelectedIndex:3];
}

- (IBAction) manageReservationButton:(id)sender{
	CarTrawlerAppDelegate *delegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate.tabBarController setSelectedIndex:4];
}

- (IBAction) changeLocaleButton:(id)sender{
	if ([self.countryPickerView isHidden]==YES){
		[self showCountryPickerView];
	} else {
		[self saveCountryChoice];
	}
}

- (IBAction) changeCurrencyButton:(id)sender {
	DLog(@"I want to change my currency");
	
	if ([self.countryPickerView isHidden]==YES){
		[self showCurrencyPickerView];
	} else {
		[self saveCurrencyChoice];
	}
}

#pragma mark -
#pragma mark locale detection

- (void) saveCurrencyChoice {
	[self.countryPickerView setHidden:YES];
	[self.localeCurrencyLabel setText:[CTHelper getCurrencyNameForCode:self.ctCountry.currencyCode]];
	//[self.localeCurrencyLabel setText:self.ctCountry.currencyCode];
	DLog(@"Saving %@", self.ctCountry.currencyCode);
	[self saveUserPrefs];
}

- (void) saveCountryChoice {
	[self.countryPickerView setHidden:YES];
	[self.localeLabel setText:[NSString stringWithFormat:kLocaleLabelStringFormat, self.ctCountry.isoCountryName, self.ctCountry .isoCountryCode]];
	DLog(@"Saving %@", self.ctCountry.isoCountryCode);
	[self saveUserPrefs];
}

- (void) showCurrencyPickerView {
	self.currencyPicker.frame = CGRectMake(0.0, 61.0, 312, 216);
	[self.countryPickerView addSubview:self.currencyPicker];
	
	UIImageView *pickerOutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"currencyPickerPop.png"]];
	[self.countryPickerView addSubview:pickerOutline];
	[self.countryPickerView bringSubviewToFront:pickerOutline];
	
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(255, 25, 50, 30);
    [doneButton addTarget:self action:@selector(saveCurrencyChoice) forControlEvents:UIControlEventTouchUpInside];
    [self.countryPickerView addSubview:doneButton];
	
	[self.countryPickerView setHidden:NO];
}

- (void) showCountryPickerView {
	self.countryPicker.frame = CGRectMake(0.0, 61.0, 312, 216);
	[self.countryPickerView addSubview:self.countryPicker];

	UIImageView *pickerOutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"countryPickerPop.png"]];
	[self.countryPickerView addSubview:pickerOutline];
	[self.countryPickerView bringSubviewToFront:pickerOutline];
	
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(255, 25, 50, 30);
    [doneButton addTarget:self action:@selector(saveCountryChoice) forControlEvents:UIControlEventTouchUpInside];
    [self.countryPickerView addSubview:doneButton];
	
	[self.countryPickerView setHidden:NO];
}

#pragma mark -
#pragma mark UIPickerViews

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

// We don't need another copy of these array's in memory here, pulling them from the AD is fine.

- (NSInteger) pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (thePickerView == self.countryPicker) {
		return [appDelegate.preloadedCountryList count];
	} else {
		return [appDelegate.preloadedCurrencyList count];
	}
}

- (NSString *) pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (thePickerView == self.countryPicker) {
		CTCountry *country = (CTCountry *)[self.preloadedCountryList objectAtIndex:row];
		return country.isoCountryName;
	} else {
		CTCurrency *currency = (CTCurrency *)[appDelegate.preloadedCurrencyList objectAtIndex:row];
		return currency.currencyName;
	}	
}

- (void) pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (thePickerView == self.countryPicker) {
		CTCountry *temp = (CTCountry *)[self.preloadedCountryList objectAtIndex:row];
		self.ctCountry = [self.ctCountry countryWithIsoCountryName:temp.isoCountryName andIsoCountryCode:temp.isoCountryCode];
		// We purposely don't check currency here as country and currency can be different.
		
	} else {
		CTCurrency *currency = (CTCurrency *)[appDelegate.preloadedCurrencyList objectAtIndex:row];
		self.ctCountry = [self.ctCountry countryWithCurrencyCode:currency.currencyCode];
		DLog(@"You selected %@", currency.currencyName);
	}

}

#pragma mark -
#pragma mark Save/Load Settings

- (void) saveUserPrefs {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.ctCountry];
	[prefs setObject:data forKey:@"ctCountry.userPrefs"];
	[prefs synchronize];
}

- (void) loadUserPrefs {
	self.ctCountry = [CTHelper loadCountry];
	[CTHelper saveCountry:self.ctCountry];
	
	[self.localeLabel setText:[NSString stringWithFormat:kLocaleLabelStringFormat, self.ctCountry.isoCountryName, self.ctCountry.isoCountryCode]];
	[self.localeCurrencyLabel setText:self.ctCountry.currencyCode];
	//[self.localeCurrencyLabel setText:[CTHelper getCurrencyNameForCode:self.ctCountry.currencyCode]];
	
}

@end
