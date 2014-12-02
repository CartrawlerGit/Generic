//
//  LocationListViewController.h
//  CarTrawler
//
//

@interface LocationListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView		*locationsTable;
	NSMutableArray	*filteredResults;
	UIActivityIndicatorView	*spinner;
	BOOL			noResults;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) NSMutableArray *filteredResults;
@property (nonatomic, retain) IBOutlet UITableView *locationsTable;

- (void) updateResults:(NSMutableArray *)results;

@end
