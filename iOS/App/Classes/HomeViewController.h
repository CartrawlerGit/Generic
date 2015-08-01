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
//  HomeViewController.h
//  CarTrawler
//
//

#import "CTCountry.h"
#import "CTCurrency.h"

@interface HomeViewController : UIViewController {

	/*CTCountry			*ctCountry;
	CTCurrency			*ctCurrency;*/

}

@property (nonatomic, strong) CTCountry *ctCountry;

@property (nonatomic, weak) IBOutlet UILabel *localeCurrencyLabel;
@property (nonatomic, weak) IBOutlet UIButton *localeCurrencyButton;
@property (nonatomic, weak) IBOutlet UILabel *localeLabel;
@property (nonatomic,weak) IBOutlet UIButton *makeReservationButton;
@property (nonatomic,weak) IBOutlet UIButton *nearbyLocationsButton;
@property (nonatomic,weak) IBOutlet UIButton *manageReservationButton;
@property (nonatomic,weak) IBOutlet UIButton *callUsButton;
@property (nonatomic,weak) IBOutlet UIButton *localeButton;

@property (nonatomic,weak) IBOutlet UIView *countryPickerView;

@property (nonatomic,weak) IBOutlet UIPickerView *countryPicker;	
@property (nonatomic, weak) IBOutlet UIPickerView *currencyPicker;

@property (nonatomic,weak) IBOutlet NSMutableArray *preloadedCountryList;

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
