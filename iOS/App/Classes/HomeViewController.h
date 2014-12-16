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
