//
//  LocationListViewController.m
//  CarTrawler



#import "LocationListViewController.h"
#import "CTLocation.h"
#import "NSString+CSVParser.h"

@implementation LocationListViewController

- (void) viewDidLoad {
	self.filteredResults = [[NSMutableArray alloc] init];
	
    [super viewDidLoad];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
	self.self.filteredResults = nil;
	self.locationsTable = nil;
    [super viewDidUnload];
}

- (void) updateResults:(NSMutableArray *)results {
	self.self.filteredResults = results;
	[self.locationsTable reloadData];
}

#pragma mark -
#pragma mark UITableView Stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.filteredResults count] > 0) {
		return [self.filteredResults count];
	} else {
		return 1;
	}
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SearchItemCell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)  {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	[[cell textLabel] setFont:[UIFont boldSystemFontOfSize:14.0]];

	// the reson we're checking for 1 before checking to see if we're greater than 0 is that sometimes
	// a rogue entry ends up in the self.filteredResults with null values

	if ([self.filteredResults count] == 0 || self.filteredResults == nil) {
		[cell.textLabel setText:@"No results, try again."];
		cell.userInteractionEnabled = NO;
	} else {
		cell.userInteractionEnabled = YES;
		CTLocation *loc = (CTLocation *)[self.filteredResults objectAtIndex:indexPath.row];
		[cell.textLabel setText:[loc.locationName capitalizedString]];
	}

/*
	if ([self.filteredResults count] > 0) {
		if ([self.filteredResults count] == 1) {
			CTLocation *loc = (CTLocation *)[self.filteredResults objectAtIndex:0];
			if (loc.title == nil) {
				[cell.textLabel setText:@"No results, try again."];
				cell.userInteractionEnabled = NO;
			}
		} else {
			cell.userInteractionEnabled = YES;
			CTLocation *loc = (CTLocation *)[self.filteredResults objectAtIndex:indexPath.row];
			[cell.textLabel setText:[loc.locationName capitalizedString]];
		}
	} else {
		
	}
*/
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			
			CTLocation *loc = (CTLocation *)[self.filteredResults objectAtIndex:indexPath.row];
			
			NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
			
			[dict setObject:loc forKey:@"selectedLocation"];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"CTLocationSelected" object:self userInfo:dict];
			//[dict release];
}



@end
