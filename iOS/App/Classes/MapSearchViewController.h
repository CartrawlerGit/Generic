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

@property (nonatomic, retain) IBOutlet UIButton *settingsButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *modalSearchLocation;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *modalSearchName;
@property (nonatomic, retain) IBOutlet UINavigationBar *modalNavBar;


@property (nonatomic, assign) NSUInteger referringFieldValue;
@property (nonatomic, assign) BOOL modalMode;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *searchBtn;
@property (nonatomic, retain) NSMutableArray *locationResults;

@property (nonatomic, assign) BOOL usingSearchBar;
@property (nonatomic, assign) BOOL searchingNearby;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CTForwardGeocoder *forwardGeocoder;

@property (nonatomic, retain) IBOutlet UITableView *listTable;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UITableView *geocodeResultsTable;
@property (nonatomic, retain) IBOutlet UIImageView *geocodeResultsMask;
@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;
@property (nonatomic, retain) IBOutlet MKMapView *searchMap;

- (IBAction) dismissModalView;
- (IBAction) settingsButtonPressed;
- (IBAction) searchButtonPressed;
- (IBAction) currentLocationSearchBtnPressed;

@end