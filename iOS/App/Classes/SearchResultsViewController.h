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
	VehAvailRSCore			*resultsCore;
	Car						*activeCar;
	RentalSession			*session;
	
	NSMutableArray			*carResultsArrayOriginalQuery;
	NSMutableArray			*carResultsArray;
	
	NSTimeInterval			dayCount;
	NSInteger				selectedSegmentIndex;
	BOOL					ascending;
	BOOL					hideCompanyFilter;
	CTSearchFilters			*searchFilters;
	
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
@property (nonatomic, weak) IBOutlet UILabel *noresultsLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, assign) NSTimeInterval dayCount;
@property (nonatomic, retain) NSMutableArray *carResultsArray;
@property (nonatomic, weak) IBOutlet UITableViewCell *noResultsCell;
@property (nonatomic, retain) RentalSession *session;
@property (nonatomic, retain) Car *activeCar;
@property (nonatomic, retain) VehAvailRSCore *resultsCore;
@property (nonatomic, weak) IBOutlet UITableView *resultsTable;
@property (nonatomic, retain) CTSearchFilters *searchFilters;

//- (NSComparisonResult)compareObject:(id)object1 toObject:(id)object2;

-(void)updateSegmentedControlLabels;
-(void)advancedFilterViewController:(AdvancedFilterViewController *)advancedFilterViewController didSaveFilterSettings:(CTSearchFilters*)ctSearchFilters;
//- (void) updateSegmentedControlLabels;//

@end
