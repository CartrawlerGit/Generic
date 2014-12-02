//
//  SearchResultsViewController.h
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

@class VehAvailRSCore, Car, RentalSession,UISegmentedControl,CTSearchFilters,AdvancedFilterViewController;

@interface SearchResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView				*resultsTable;
	VehAvailRSCore			*resultsCore;
	Car						*activeCar;
	RentalSession			*session;
	
	UITableViewCell			*noResultsCell;
	
	NSMutableArray			*carResultsArrayOriginalQuery;
	NSMutableArray			*carResultsArray;
	
	NSTimeInterval			dayCount;
	
	UISegmentedControl		*segmentedControl;
	NSInteger				selectedSegmentIndex;
	BOOL					ascending;
	BOOL					hideCompanyFilter;
	CTSearchFilters			*searchFilters;
	
	UILabel					*noresultsLabel;
	
	BOOL					hasSetFiltersAlready;
	
	BOOL					sortedPriceAsc;
	BOOL					sortedPriceDesc;
	BOOL					sortedTypeAsc;
	BOOL					sortedTypeDesc;
}

@property (nonatomic, assign) BOOL sortedPriceAsc;
@property (nonatomic, assign) BOOL sortedPriceDesc;
@property (nonatomic, assign) BOOL sortedTypeAsc;
@property (nonatomic, assign) BOOL sortedTypeDesc;
@property (nonatomic, assign) BOOL hasSetFiltersAlready;
@property (nonatomic, retain) IBOutlet UILabel *noresultsLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, assign) NSTimeInterval dayCount;
@property (nonatomic, retain) NSMutableArray *carResultsArray;
@property (nonatomic, retain) IBOutlet UITableViewCell *noResultsCell;
@property (nonatomic, retain) RentalSession *session;
@property (nonatomic, retain) Car *activeCar;
@property (nonatomic, retain) VehAvailRSCore *resultsCore;
@property (nonatomic, retain) IBOutlet UITableView *resultsTable;
@property (nonatomic, retain) CTSearchFilters *searchFilters;

//- (NSComparisonResult)compareObject:(id)object1 toObject:(id)object2;

-(void)updateSegmentedControlLabels;
-(void)advancedFilterViewController:(AdvancedFilterViewController *)advancedFilterViewController didSaveFilterSettings:(CTSearchFilters*)ctSearchFilters;
//- (void) updateSegmentedControlLabels;//

@end
