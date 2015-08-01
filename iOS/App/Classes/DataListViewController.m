//
//  DataListViewController.m
//  CarTrawler
//
//

#import "DataListViewController.h"
#import "CTCurrency.h"
#import "CTCountry.h"

@interface DataListViewController (Private)

- (void) saveUserPrefs;
- (void) loadUserPrefs;
- (NSMutableArray *) arrangeIndex;

@end

@implementation DataListViewController

- (id) init {
    self=[super initWithNibName:@"DataListViewController" bundle:nil];
	self.tableIndex = [[NSMutableArray alloc] init];
	self.data = [[NSMutableArray alloc] init];
	self.indexedTableContents = [[NSMutableArray alloc] init];
	
    return self;
}

- (id) initWithNibName:(NSString *)n bundle:(NSBundle *)b {
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (self.countryMode) {
		self.indexedTableContents = [self arrangeIndex];
		[self.aTitleLabel setText:@"Country of Residence"];
	}
	if (self.currencyMode) {
		[self.aTitleLabel setText:@"Your Currency"];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.dataTable = nil;
	self.tableContents = nil;
	self.aTitleLabel = nil;
}
#pragma mark -
#pragma mark Table Index Formation

- (void) buildIndex {
	[self.tableIndex removeAllObjects];
	for (CTCountry *c in self.tableContents) {
		NSString *firstLetter = [c.isoCountryName substringToIndex:1];
		
		if (![self.tableIndex containsObject:firstLetter]) {
			[self.tableIndex addObject:firstLetter];
		} 
	}
	// DLog(@"Index array is %@", index);
}

- (NSMutableArray *) arrangeIndex {
	
	NSMutableArray *content = [NSMutableArray new];
	
	[self buildIndex];
	
	for (NSString *indexLetter in self.tableIndex) {
		
		NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
		NSMutableArray		*countries = [[NSMutableArray alloc] init];
		
		for (CTCountry *c in self.tableContents) {
			NSString *firstLetter = [c.isoCountryName substringToIndex:1];
			
			if ([firstLetter isEqualToString:indexLetter]) {
				[countries addObject:c];
			}
		}
		[row setValue:indexLetter forKey:@"headerTitle"];
		[row setValue:countries forKey:@"rowValues"];
		// DLog(@"Row %@ is \n\n%@\n\n", indexLetter, countries);
		[content addObject:row];
	}
	
	return content;
}

#pragma mark -
#pragma mark Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.countryMode) {
		return [self.indexedTableContents valueForKey:@"headerTitle"];
	} else {
		return nil;
	}
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (self.countryMode) {
		return [self.tableIndex indexOfObject:title];
	} else {
		return 0;
	}
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	if (self.countryMode) {
		return [[self.indexedTableContents objectAtIndex:section] objectForKey:@"headerTitle"];
	} else {
		return nil;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.countryMode) {
		return [self.indexedTableContents count];
	} else {
		return 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.countryMode) {
		return [[[self.indexedTableContents objectAtIndex:section] objectForKey:@"rowValues"] count] ;
	} else {
		return [self.tableContents count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	if (self.currencyMode) {
		CTCurrency *currency = (CTCurrency *)[self.tableContents objectAtIndex:indexPath.row];
		cell.textLabel.text = currency.currencyName;
	} 
	
	if (self.countryMode) {
		CTCountry *country = (CTCountry *)[[[self.indexedTableContents objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
		cell.textLabel.text = country.isoCountryName;
	}

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Open up defaults
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	if (self.currencyMode) {
		CTCurrency *currency = (CTCurrency *)[self.tableContents objectAtIndex:indexPath.row];
		
		[prefs setObject:currency.currencyCode forKey:@"ctCountry.currencyCode"];
		// We don't actually have access to the symbol unless we use locale detection, which is a bit dodgy.
		//[prefs setObject:currency.currencySymbol forKey:@"ctCountry.currencySymbol"];
		[self dismissView];
	}
	
	if (self.countryMode) {
		CTCountry *country = (CTCountry *)[[[self.indexedTableContents objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
		//CTCountry *country = (CTCountry *)[self.tableContents objectAtIndex:indexPath.row];
		[prefs setObject:country.isoCountryName forKey:@"ctCountry.isoCountryName"];
		[prefs setObject:country.isoCountryCode forKey:@"ctCountry.isoCountryCode"];
		[prefs setObject:country.isoDialingCode forKey:@"ctCountry.isoDialingCode"];
		[self dismissView];
	}
}

#pragma mark -
#pragma mark IBActions

- (IBAction) dismissView {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
