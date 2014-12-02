//
//  HomeViewController.h
//  CarTrawler
//
//

#import "CTCountry.h"
#import "CTCurrency.h"

@interface HomeViewController : UIViewController {
	UIButton			*makeReservationButton;
	UIButton			*nearbyLocationsButton;
	UIButton			*manageReservationButton;
	UIButton			*callUsButton;
	
	UILabel				*localeLabel;
	UIButton			*localeButton;
	
	UILabel				*localeCurrencyLabel;
	UIButton			*localeCurrencyButton;

	UIView				*countryPickerView;
	UIPickerView		*countryPicker;
	UIPickerView		*currencyPicker; 

	CTCountry			*ctCountry;
	CTCurrency			*ctCurrency;
	NSMutableArray		*preloadedCountryList;

}

@property (nonatomic, retain) CTCountry *ctCountry;

@property (nonatomic, retain) IBOutlet UILabel *localeCurrencyLabel;
@property (nonatomic, retain) IBOutlet UIButton *localeCurrencyButton;
@property (nonatomic, retain) IBOutlet UILabel *localeLabel;
@property (nonatomic,retain) IBOutlet UIButton *makeReservationButton;
@property (nonatomic,retain) IBOutlet UIButton *nearbyLocationsButton;
@property (nonatomic,retain) IBOutlet UIButton *manageReservationButton;
@property (nonatomic,retain) IBOutlet UIButton *callUsButton;
@property (nonatomic,retain) IBOutlet UIButton *localeButton;

@property (nonatomic,retain) IBOutlet UIView *countryPickerView;

@property (nonatomic,retain) IBOutlet UIPickerView *countryPicker;	
@property (nonatomic, retain) IBOutlet UIPickerView *currencyPicker;

@property (nonatomic,retain) IBOutlet NSMutableArray *preloadedCountryList;

- (IBAction) showCurrencyList;
- (IBAction) showCountryList;

- (IBAction) makeReservationButton:(id)sender;
- (IBAction) nearbyLocationsButton:(id)sender;
- (IBAction) manageReservationButton:(id)sender;
- (IBAction) callUsButton:(id)sender;
- (IBAction) changeLocaleButton:(id)sender;
- (IBAction) changeCurrencyButton:(id)sender;
- (void) showCurrencyPickerView;
- (void) saveCurrencyChoice;


@end
