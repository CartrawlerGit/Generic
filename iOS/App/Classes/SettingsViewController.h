//
//  SettingsViewController.h
//  CarTrawler
//

#import "CTCountry.h"
#import "CTCurrency.h"

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>  
{
	
	UITableView		*settingsTable;
	UILabel			*radiusLabel;
	UILabel			*kmLabel;
	UILabel			*milesLabel;
	UILabel			*countryLabel;
	UILabel			*currencyLabel;
	
	UILabel			*pickerModeLabel;
	
	UISwitch		*aSwitch;
	UISlider		*aSlider;
	UISlider		*metricSlider;
	
	IBOutlet UIPickerView	*countryPicker;
	UIPickerView	*currencyPicker;
	UIView				*countryPickerView;
	UIView				*currencyPickerView;
	UIView				*pickerView;
	NSMutableArray		*preloadedCountryList;
	NSMutableArray		*preloadedCurrencyList;
	NSString			*homeCountryCode;
	NSString			*homeCurrencyCode;
	
	UISegmentedControl *mileKMSegment;
	UISegmentedControl *radiusSegment;
	
	//vars for holding the users prefs. Saved to user defaults
	CTCountry *ctCountry;
	CTCurrency *ctCurrency;
	NSInteger searchRadius;
	NSInteger metric;
	NSInteger radius;
	bool airports;
	bool fromMap;
	
	UILabel		*infoLabel;
	
	UINavigationBar		*modalNavbar;
	UIBarButtonItem		*modalDoneButton;
	
}

@property (nonatomic, retain) IBOutlet UINavigationBar *modalNavbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *modalDoneButton;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
@property (nonatomic, assign) bool fromMap;
@property (nonatomic, copy) NSString *homeCountryCode;
@property (nonatomic, copy) NSString *homeCurrencyCode;
@property (nonatomic, retain) CTCountry *ctCountry;
@property (nonatomic, retain) CTCurrency *ctCurrency;
@property (nonatomic, retain) IBOutlet UISwitch *aSwitch;
@property (nonatomic, retain) IBOutlet UISlider *aSlider;
@property (nonatomic, retain) IBOutlet UISlider *metricSlider;
@property (nonatomic, retain) IBOutlet UILabel *radiusLabel;
@property (nonatomic, retain) IBOutlet UILabel *kmLabel;
@property (nonatomic, retain) IBOutlet UILabel *milesLabel;
@property (nonatomic, retain) IBOutlet UILabel *countryLabel;
@property (nonatomic, retain) IBOutlet UILabel *currencyLabel;
@property (nonatomic, retain) IBOutlet UITableView *settingsTable;
@property (nonatomic, retain) NSMutableArray		*preloadedCountryList;
@property (nonatomic, retain) NSMutableArray		*preloadedCurrencyList;
@property (nonatomic, retain) IBOutlet UIView *pickerView;
@property (nonatomic, retain) IBOutlet UIView *countryPickerView;
@property (nonatomic, retain) IBOutlet UIView *currencyPickerView;
@property (nonatomic, retain) IBOutlet UILabel *pickerModeLabel;
@property (nonatomic, retain) IBOutlet UIPickerView *countryPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *currencyPicker;

- (IBAction)dismissModalView:(id)sender;

@end
 
