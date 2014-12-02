//
//  AdvancedFilterViewController.h
//  CarTrawler
//
//

@protocol AdvancedFilterViewControllerDelegate;
@class CTSearchFilters;

@interface AdvancedFilterViewController : UIViewController <UITableViewDataSource, UITableViewDataSource> {
	id <AdvancedFilterViewControllerDelegate> delegate;

	UITableView *filterTable;
	UISegmentedControl *peopleSegCtrl;
	UISegmentedControl *fuelSegCtrl;
	UISegmentedControl *transmissionSegCtrl;
	UISegmentedControl *airConSegCtrl;

	CTSearchFilters *ctSearchFilters;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic,retain) CTSearchFilters *ctSearchFilters;
@property (nonatomic,retain) IBOutlet UITableView *filterTable;
@property (nonatomic,retain) UISegmentedControl *peopleSegCtrl;
@property (nonatomic,retain) UISegmentedControl *fuelSegCtrl;
@property (nonatomic,retain) UISegmentedControl *transmissionSegCtrl;
@property (nonatomic,retain) UISegmentedControl *airConSegCtrl;

- (IBAction) dismissView:(id)sender;
- (IBAction) saveFilters:(id)sender;
- (IBAction) resetForm:(id)sender;
- (void) loadFilters:(id)sender;
- (void) setDefaultValues;
- (void) resetUIElements;

@end

@protocol AdvancedFilterViewControllerDelegate <NSObject>
-(void)advancedFilterViewController:(AdvancedFilterViewController *)advancedFilterViewController didSaveFilterSettings:(CTSearchFilters*)ctSearchFilters;
@end
