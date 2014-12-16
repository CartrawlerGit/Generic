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
//  SearchViewController.h
//  CarTrawler
//
//

@class LocationListViewController, RentalSession, CTLocation,CTSearchDefaults, CTCountry, CTSearchDefaults;

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ASIHTTPRequestDelegate> 
{ 
	BOOL				isFromNearbySearch;
	BOOL				isFromCitySearch;
	BOOL				isFromAirportSearch;
	
	UITableView			*searchTable;
	
	NSString			*pickUpDateTime;
	NSString			*returnDateTime;
	NSString			*pickUpLocationCode;
	NSString			*pickUpLocationName;
	NSString			*dropOffLocationName;
	NSString			*returnLocationCode;
	NSString			*driverAge;
	NSString			*passengerQty;
	NSString			*homeCountryCode;
	NSString			*formattedPickupString;
	NSString			*formattedDropoffString;
	
	UITextField			*pickupTextField;
	UITextField			*dropoffTextField;
	UITextField			*ageTextField;
	UITextField			*numberOfPassengersTextField;
	
	UILabel				*pickupDateLabel;
	UILabel				*dropoffDateLabel;
	UILabel				*countryLabel;
	UILabel				*currencyLabel;
	UILabel				*dateDisplayLabel;
	UILabel				*pickerModeLabel;
	
	UIView				*containerView;
	UIView				*pickerView;
	UIView				*calendarView;
	UIView				*alternateLocationFooterView;
	UIView				*headerView;
	UIView				*selectLocationView;
	UIView				*countryPickerView;
	UIView				*currencyPickerView;
	UIView				*footerView;
	
	UIDatePicker		*timePicker;
	UIPickerView		*countryPicker;
	UIPickerView		*currencyPicker;
	
	UIButton			*alternativeBtn;
	BOOL				frontViewIsVisible;
	BOOL				alternateDrop;
	BOOL				searchingAlternateDropOffLocationFromMapView;
	NSMutableArray		*preloadedLocations;
	NSMutableArray		*preloadedCountryList;
	NSMutableArray		*preloadedCurrencyList;

	NSDate				*theDateFromPicker;
	
	LocationListViewController *llvc;
	
	RentalSession		*session;
	
	BOOL				canShowList;
	BOOL				showListNow;
	BOOL				pickupDateSet;
	BOOL				dropoffDateSet;
	BOOL				pickupLocationSet;
	BOOL				dropoffLocationSet;
	BOOL				isSettingPickup; // I stupidly used these for setting the DATE when i meant to use them for location.
	BOOL				isSettingDropoff;
	BOOL				isSettingDropoffLocation;
	
	BOOL				isSelectingByMap;
	
	BOOL				setFromLocations;
	
	CTLocation			*selectedNearbyLocation;
	
	CTSearchDefaults	*ctSearchDefaults;
	
	CTCountry			*ctCountry;
	//CTCurrency *ctCurrency;
	
	UIButton			*dismissLocationPopUpButton;
	UIButton			*showMapButton;
	UIButton			*showDOMapButton;
	
}

@property (nonatomic, retain) IBOutlet UIButton *showDOMapButton;
@property (nonatomic, retain) IBOutlet UIButton *showMapButton;
@property (nonatomic, assign) BOOL setFromLocations;
@property (nonatomic, retain) UIButton *dismissLocationPopUpButton;
@property (nonatomic, retain) CTSearchDefaults *ctSearchDefaults;
@property (nonatomic, retain) CTCountry *ctCountry;
//@property (nonatomic, retain) CTCurrency *ctCurrency;

@property (nonatomic, assign) BOOL isSettingDropoffLocation;
@property (nonatomic, retain) CTLocation *selectedNearbyLocation;
@property (nonatomic, retain) RentalSession *session;
@property (nonatomic, assign) BOOL isFromNearbySearch;
@property (nonatomic, assign) BOOL isFromCitySearch;
@property (nonatomic, assign) BOOL isFromAirportSearch;
@property (nonatomic, copy) NSString *formattedPickupString;
@property (nonatomic, copy) NSString *formattedDropoffString;


@property (nonatomic, copy) NSString *pickUpLocationName;
@property (nonatomic, copy) NSString *dropOffLocationName;
@property (nonatomic, copy) NSString *pickUpDateTime;
@property (nonatomic, copy) NSString *returnDateTime;

@property (nonatomic, copy) NSString *pickUpLocationCode;
@property (nonatomic, copy) NSString *returnLocationCode;
@property (nonatomic, copy) NSString *driverAge;
@property (nonatomic, copy) NSString *passengerQty;
@property (nonatomic, copy) NSString *homeCountryCode;

@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) NSDate *theDateFromPicker;

@property (nonatomic, retain) NSMutableArray *preloadedCurrencyList;
@property (nonatomic, retain) NSMutableArray *preloadedLocations;
@property (nonatomic, retain) NSMutableArray *preloadedCountryList;

@property (nonatomic, retain) IBOutlet UIPickerView *countryPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *currencyPicker;
@property (nonatomic, retain) IBOutlet UIDatePicker *timePicker;

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) UIView *calendarView;
@property (nonatomic, retain) IBOutlet UIView *containerView;
@property (nonatomic, retain) IBOutlet UIView *pickerView;
@property (nonatomic, retain) IBOutlet UIView *alternateLocationFooterView;
@property (nonatomic, retain) IBOutlet UIView *selectLocationView;
@property (nonatomic, retain) IBOutlet UIView *countryPickerView;
@property (nonatomic, retain) IBOutlet UIView *currencyPickerView;

@property (nonatomic, retain) IBOutlet UIButton *alternativeBtn;

@property (nonatomic, retain) IBOutlet UILabel *dateDisplayLabel;
@property (nonatomic, retain) IBOutlet UILabel *pickerModeLabel;
@property (nonatomic, retain) UILabel *pickupDateLabel;
@property (nonatomic, retain) UILabel *dropoffDateLabel;

@property (nonatomic, retain) IBOutlet UITableView *searchTable;

@property (nonatomic, retain) UITextField *pickupTextField;
@property (nonatomic, retain) UITextField *dropoffTextField;
@property (nonatomic, retain) UITextField *ageTextField;
@property (nonatomic, retain) UITextField *numberOfPassengersTextField;

@property (assign) BOOL frontViewIsVisible;
@property (assign) BOOL alternateDrop;
@property (nonatomic, assign) BOOL showListNow;
@property (nonatomic, assign) BOOL canShowList;
@property (nonatomic, assign) BOOL pickupDateSet;
@property (nonatomic, assign) BOOL dropoffDateSet;
@property (nonatomic, assign) BOOL pickupLocationSet;
@property (nonatomic, assign) BOOL dropoffLocationSet;
@property (nonatomic, assign) BOOL isSettingPickup;
@property (nonatomic, assign) BOOL isSettingDropoff;

- (void) dismissCalendarAndPickerViews;
- (IBAction) clearData:(id)sender;
- (void)loadHomeCountryFromMemory;
- (void)processSelectedDates;
- (void)realignFieldInCell:(UIView*)field;
- (void)updateFieldColors;
- (void)saveUserPrefs;
- (void)loadUserPrefs;
- (void)updateAccessoryViewsInTableView;
- (void)showAccessoryTickForCell:(UITableViewCell*)cell withValue:(NSString*)value enabled:(BOOL)enabled;
- (void)showMapButtonPressed:(id)sender;

@end
