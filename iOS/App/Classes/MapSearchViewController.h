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
//  MapSearchViewController.h
//  CarTrawler
//
//
#import "CTForwardGeocoder.h"

@interface MapSearchViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, CTForwardGeocoderDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate> {
	MKMapView			*searchMap;
	UISearchBar			*theSearchBar;
	UIImageView			*geocodeResultsMask;
	UITableView			*geocodeResultsTable;
	UITableView			*listTable;
	
	CLLocationManager	*locationManager;
	UISegmentedControl	*segmentedControl;
	UIBarButtonItem		*searchBtn;
	CTForwardGeocoder	*forwardGeocoder;
	
	BOOL				searchingNearby;
	BOOL				usingSearchBar;
	BOOL				modalMode;

	NSMutableArray		*locationResults;
	
	NSUInteger			referringFieldValue;	// This is the int (tag) passed from the SearchViewController's pick up or drop off field.

	UINavigationBar		*modalNavBar;
	UIBarButtonItem		*modalSearchLocation;
	UIBarButtonItem		*modalSearchName;
	UIButton			*settingsButton;
}

@property (nonatomic, strong) IBOutlet UIButton *settingsButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *modalSearchLocation;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *modalSearchName;
@property (nonatomic, strong) IBOutlet UINavigationBar *modalNavBar;


@property (nonatomic, assign) NSUInteger referringFieldValue;
@property (nonatomic, assign) BOOL modalMode;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *searchBtn;
@property (nonatomic, strong) NSMutableArray *locationResults;

@property (nonatomic, assign) BOOL usingSearchBar;
@property (nonatomic, assign) BOOL searchingNearby;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CTForwardGeocoder *forwardGeocoder;

@property (nonatomic, strong) IBOutlet UITableView *listTable;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet UITableView *geocodeResultsTable;
@property (nonatomic, strong) IBOutlet UIImageView *geocodeResultsMask;
@property (nonatomic, strong) IBOutlet UISearchBar *theSearchBar;
@property (nonatomic, strong) IBOutlet MKMapView *searchMap;

- (IBAction) dismissModalView;
- (IBAction) settingsButtonPressed;
- (IBAction) searchButtonPressed;
- (IBAction) currentLocationSearchBtnPressed;

@end