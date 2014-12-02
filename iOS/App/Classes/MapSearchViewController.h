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