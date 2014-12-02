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

#define kLocaleLabelStringFormat @"%@ (%@)"

@interface HomeViewController (Private)

- (void) saveCountryChoice;
- (void) showCountryPickerView;
- (void) saveUserPrefs;
- (void) loadUserPrefs;

@end

@implementation HomeViewController

@synthesize currencyPicker;
@synthesize localeCurrencyLabel;
@synthesize localeCurrencyButton;
@synthesize localeLabel;
@synthesize makeReservationButton;
@synthesize nearbyLocationsButton;
@synthesize manageReservationButton;
@synthesize callUsButton;
@synthesize localeButton;
@synthesize ctCountry;
@synthesize countryPickerView;
@synthesize countryPicker;
@synthesize preloadedCountryList;

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
/*
- (void) dealloc {
	[localeLabel release];
	localeLabel = nil;

	[localeCurrencyLabel release];
	localeCurrencyLabel = nil;
	[localeCurrencyButton release];
	localeCurrencyButton = nil;

	[currencyPicker release];
	currencyPicker = nil;

    [super dealloc];
}
 */

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
	if ([countryPickerView isHidden]==YES){
		[self showCountryPickerView];
	} else {
		[self saveCountryChoice];
	}
}

- (IBAction) changeCurrencyButton:(id)sender {
	DLog(@"I want to change my currency");
	
	if ([countryPickerView isHidden]==YES){
		[self showCurrencyPickerView];
	} else {
		[self saveCurrencyChoice];
	}
}

#pragma mark -
#pragma mark locale detection

- (void) saveCurrencyChoice {
	[countryPickerView setHidden:YES];
	[localeCurrencyLabel setText:[CTHelper getCurrencyNameForCode:ctCountry.currencyCode]];
	//[localeCurrencyLabel setText:ctCountry.currencyCode];
	DLog(@"Saving %@", ctCountry.currencyCode);
	[self saveUserPrefs];
}

- (void) saveCountryChoice {
	[countryPickerView setHidden:YES];
	[localeLabel setText:[NSString stringWithFormat:kLocaleLabelStringFormat, ctCountry.isoCountryName, ctCountry .isoCountryCode]];
	DLog(@"Saving %@", ctCountry.isoCountryCode);
	[self saveUserPrefs];
}

- (void) showCurrencyPickerView {
	currencyPicker.frame = CGRectMake(0.0, 61.0, 312, 216);
	[countryPickerView addSubview:currencyPicker];
	
	UIImageView *pickerOutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"currencyPickerPop.png"]];
	[countryPickerView addSubview:pickerOutline];
	[countryPickerView bringSubviewToFront:pickerOutline];
	
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(255, 25, 50, 30);
    [doneButton addTarget:self action:@selector(saveCurrencyChoice) forControlEvents:UIControlEventTouchUpInside];
    [countryPickerView addSubview:doneButton];
	
	[countryPickerView setHidden:NO];
}

- (void) showCountryPickerView {
	countryPicker.frame = CGRectMake(0.0, 61.0, 312, 216);
	[countryPickerView addSubview:countryPicker];

	UIImageView *pickerOutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"countryPickerPop.png"]];
	[countryPickerView addSubview:pickerOutline];
	[countryPickerView bringSubviewToFront:pickerOutline];
	
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(255, 25, 50, 30);
    [doneButton addTarget:self action:@selector(saveCountryChoice) forControlEvents:UIControlEventTouchUpInside];
    [countryPickerView addSubview:doneButton];
	
	[countryPickerView setHidden:NO];
}

#pragma mark -
#pragma mark UIPickerViews

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

// We don't need another copy of these array's in memory here, pulling them from the AD is fine.

- (NSInteger) pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (thePickerView == countryPicker) {
		return [appDelegate.preloadedCountryList count];
	} else {
		return [appDelegate.preloadedCurrencyList count];
	}
}

- (NSString *) pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (thePickerView == countryPicker) {
		CTCountry *country = (CTCountry *)[preloadedCountryList objectAtIndex:row];
		return country.isoCountryName;
	} else {
		CTCurrency *currency = (CTCurrency *)[appDelegate.preloadedCurrencyList objectAtIndex:row];
		return currency.currencyName;
	}	
}

- (void) pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (thePickerView == countryPicker) {
		CTCountry *temp = (CTCountry *)[preloadedCountryList objectAtIndex:row];
		ctCountry.isoCountryCode = temp.isoCountryCode;
		ctCountry.isoCountryName = temp.isoCountryName;
		// We purposely don't check currency here as country and currency can be different.
		
	} else {
		CTCurrency *currency = (CTCurrency *)[appDelegate.preloadedCurrencyList objectAtIndex:row];
		ctCountry.currencyCode = currency.currencyCode;
		DLog(@"You selected %@", currency.currencyName);
	}

}

#pragma mark -
#pragma mark Save/Load Settings

- (void) saveUserPrefs {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	[prefs setObject:ctCountry.isoCountryName forKey:@"ctCountry.isoCountryName"];
	[prefs setObject:ctCountry.isoCountryCode forKey:@"ctCountry.isoCountryCode"];
	[prefs setObject:ctCountry.isoDialingCode forKey:@"ctCountry.isoDialingCode"];
	[prefs setObject:ctCountry.currencyCode forKey:@"ctCountry.currencyCode"];
	[prefs setObject:ctCountry.currencySymbol forKey:@"ctCountry.currencySymbol"];
	
	[prefs synchronize];
}

- (void) loadUserPrefs {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	ctCountry = [[CTCountry alloc] init];
	ctCountry.isoCountryName = [prefs objectForKey:@"ctCountry.isoCountryName"];
	ctCountry.isoCountryCode = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	ctCountry.isoDialingCode = [prefs objectForKey:@"ctCountry.isoDialingCode"];
	
	ctCountry.currencyCode = [prefs objectForKey:@"ctCountry.currencyCode"];
	// The code here is the most important, the symbol is only for display.
	ctCountry.currencySymbol = [prefs objectForKey:@"ctCountry.currencySymbol"];

	if (ctCountry.isoCountryName == nil){
		ctCountry.isoCountryName = [CTHelper getLocaleDisplayName];
		ctCountry.isoCountryCode = [CTHelper getLocaleCode];
		[self saveUserPrefs];
	}
	
	if (ctCountry.currencyCode == nil) {
		ctCountry.currencyCode = [CTHelper getLocaleCurrencyCode];
		ctCountry.currencySymbol = [CTHelper getLocaleCurrencySymbol];
		
		[self saveUserPrefs];
	}
	
	[localeLabel setText:[NSString stringWithFormat:kLocaleLabelStringFormat, ctCountry.isoCountryName, ctCountry.isoCountryCode]];
	[localeCurrencyLabel setText:ctCountry.currencyCode];
	//[localeCurrencyLabel setText:[CTHelper getCurrencyNameForCode:ctCountry.currencyCode]];
	
}

@end
