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

@property (nonatomic, weak) IBOutlet UIButton *showDOMapButton;
@property (nonatomic, weak) IBOutlet UIButton *showMapButton;
@property (nonatomic, assign) BOOL setFromLocations;
@property (nonatomic, strong) UIButton *dismissLocationPopUpButton;
@property (nonatomic, strong) CTSearchDefaults *ctSearchDefaults;
@property (nonatomic, strong) CTCountry *ctCountry;
//@property (nonatomic, strong) CTCurrency *ctCurrency;

@property (nonatomic, assign) BOOL isSettingDropoffLocation;
@property (nonatomic, strong) CTLocation *selectedNearbyLocation;
@property (nonatomic, strong) RentalSession *session;
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

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSDate *theDateFromPicker;

@property (nonatomic, strong) NSMutableArray *preloadedCurrencyList;
@property (nonatomic, strong) NSMutableArray *preloadedLocations;
@property (nonatomic, strong) NSMutableArray *preloadedCountryList;

@property (nonatomic, weak) IBOutlet UIPickerView *countryPicker;
@property (nonatomic, weak) IBOutlet UIPickerView *currencyPicker;

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, strong) UIView *calendarView;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIView *pickerView;
@property (nonatomic, weak) IBOutlet UIView *alternateLocationFooterView;
@property (nonatomic, weak) IBOutlet UIView *selectLocationView;
@property (nonatomic, weak) IBOutlet UIView *countryPickerView;
@property (nonatomic, weak) IBOutlet UIView *currencyPickerView;

@property (nonatomic, weak) IBOutlet UIButton *alternativeBtn;

@property (nonatomic, weak) IBOutlet UILabel *dateDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickerModeLabel;
@property (nonatomic, strong) UILabel *pickupDateLabel;
@property (nonatomic, strong) UILabel *dropoffDateLabel;

@property (nonatomic, weak) IBOutlet UITableView *searchTable;

@property (nonatomic, strong) UITextField *pickupTextField;
@property (nonatomic, strong) UITextField *dropoffTextField;
@property (nonatomic, strong) UITextField *ageTextField;
@property (nonatomic, strong) UITextField *numberOfPassengersTextField;

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
