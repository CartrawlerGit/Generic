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
//  SettingsViewController.h
//  CarTrawler
//

#import "CTCountry.h"
#import "CTCurrency.h"

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>  
{
	/*NSMutableArray		*preloadedCountryList;
	NSMutableArray		*preloadedCurrencyList;
	NSString			*homeCountryCode;
	NSString			*homeCurrencyCode;
	
	//vars for holding the users prefs. Saved to user defaults
	CTCountry *ctCountry;
	CTCurrency *ctCurrency;
	bool airports;
	bool fromMap;*/
	
}

@property (nonatomic, weak) IBOutlet UINavigationBar *modalNavbar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *modalDoneButton;
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@property (nonatomic, assign) bool fromMap;
@property (nonatomic, copy) NSString *homeCountryCode;
@property (nonatomic, copy) NSString *homeCurrencyCode;
@property (nonatomic, strong) CTCountry *ctCountry;
@property (nonatomic, strong) CTCurrency *ctCurrency;
@property (nonatomic, weak) IBOutlet UISwitch *aSwitch;
@property (nonatomic, weak) IBOutlet UISlider *aSlider;
@property (nonatomic, weak) IBOutlet UISlider *metricSlider;
@property (nonatomic, weak) IBOutlet UILabel *radiusLabel;
@property (nonatomic, weak) IBOutlet UILabel *kmLabel;
@property (nonatomic, weak) IBOutlet UILabel *milesLabel;
@property (nonatomic, weak) IBOutlet UILabel *countryLabel;
@property (nonatomic, weak) IBOutlet UILabel *currencyLabel;
@property (nonatomic, weak) IBOutlet UITableView *settingsTable;
@property (nonatomic, strong) NSMutableArray		*preloadedCountryList;
@property (nonatomic, strong) NSMutableArray		*preloadedCurrencyList;
@property (nonatomic, weak) IBOutlet UIView *pickerView;
@property (nonatomic, weak) IBOutlet UIView *countryPickerView;
@property (nonatomic, weak) IBOutlet UIView *currencyPickerView;
@property (nonatomic, weak) IBOutlet UILabel *pickerModeLabel;
@property (nonatomic, weak) IBOutlet UIPickerView *countryPicker;
@property (nonatomic, weak) IBOutlet UIPickerView *currencyPicker;

- (IBAction)dismissModalView:(id)sender;

@end
 
