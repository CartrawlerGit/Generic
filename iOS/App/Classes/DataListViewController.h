//
//  DataListViewController.h
//  CarTrawler
//
//

@class CTCountry;

@interface DataListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	UITableView		*dataTable;
	NSMutableArray	*tableContents;
	NSMutableArray	*indexedTableContents;
	
	BOOL			countryMode;
	BOOL			currencyMode;
	
	UILabel			*aTitleLabel;
	
	NSMutableArray	*tableIndex;
	NSMutableArray	*data;
	
}

@property (nonatomic, retain) NSMutableArray *indexedTableContents;
@property (nonatomic, retain) NSMutableArray *tableIndex;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) IBOutlet UILabel *aTitleLabel;
@property (nonatomic, retain) NSMutableArray *tableContents;
@property (nonatomic, assign) BOOL countryMode;
@property (nonatomic, assign) BOOL currencyMode;
@property (nonatomic, retain) IBOutlet UITableView *dataTable;

- (IBAction) dismissView;
@end
