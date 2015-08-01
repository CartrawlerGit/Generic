//
// Copyright 2014 Etrawler
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//
//  AdvancedFilterViewController.h
//  CarTrawler
//

@protocol AdvancedFilterViewControllerDelegate;
@class CTSearchFilters;

@interface AdvancedFilterViewController : UIViewController <UITableViewDataSource, UITableViewDataSource> {
	id <AdvancedFilterViewControllerDelegate> __weak delegate;

	UITableView *filterTable;
	UISegmentedControl *peopleSegCtrl;
	UISegmentedControl *fuelSegCtrl;
	UISegmentedControl *transmissionSegCtrl;
	UISegmentedControl *airConSegCtrl;

	CTSearchFilters *ctSearchFilters;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic,strong) CTSearchFilters *ctSearchFilters;
@property (nonatomic,strong) IBOutlet UITableView *filterTable;
@property (nonatomic,strong) UISegmentedControl *peopleSegCtrl;
@property (nonatomic,strong) UISegmentedControl *fuelSegCtrl;
@property (nonatomic,strong) UISegmentedControl *transmissionSegCtrl;
@property (nonatomic,strong) UISegmentedControl *airConSegCtrl;

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
