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
//  BookingViewController.h
//  CarTrawler
//
//

@class RentalSession,CTUserBookingDetails;

@interface BookingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, ASIHTTPRequestDelegate> {
	
	/*UITextField		*namePrefixTB;
	UITextField		*givenNameTB;
	UITextField		*surnameTB;
	
	UITextField		*nameTB;
	
	UITextField		*phoneAreaCodeTB;
	UITextField		*phoneNumberTB;
	UITextField		*emailAddressTB;
	UITextField		*addressTB;
	UITextField		*countryCodeTB;
	UITextField		*flightNumberTB;
	UITextField		*ccHolderNameTB;
	UITextField		*ccNumberTB;
	UITextField		*ccExpDateTB;
	UITextField		*ccSeriesCodeTB;
	UISegmentedControl *visaMasterSegment;
	UIButton		*visaButton;
	UIButton		*mastercardButton;
	
	RentalSession	*session;
	
	UIView			*footerView;
	CTUserBookingDetails *ctUserBookingDetails;
	
	BOOL			acceptedRentalTerms;
	BOOL			acceptedEngineTerms;
	BOOL			acceptedConditions;
	
	BOOL			haveGivenName;
	BOOL			haveSurname;
	BOOL			haveEmailAddress;
	BOOL			haveAddress;
	BOOL			haveFlightNumber;
	BOOL			havePhoneNumber;
	
	BOOL			hasAlternateDropOff;
	
	NSString		*selectedCardType;*/

}

@property (nonatomic, copy) NSString *selectedCardType;
@property (nonatomic, weak) IBOutlet UILabel *insuranceCostTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *insuranceLabelForCostSection;
@property (nonatomic, weak) IBOutlet UILabel *dropOffHeaderLabel;
@property (nonatomic, assign) BOOL hasAlternateDropOff;
@property (nonatomic, assign) BOOL haveGivenName;
@property (nonatomic, assign) BOOL haveSurname;
@property (nonatomic, assign) BOOL haveEmailAddress;
@property (nonatomic, assign) BOOL haveAddress;
@property (nonatomic, assign) BOOL haveFlightNumber;
@property (nonatomic, assign) BOOL havePhoneNumber;
@property (nonatomic, weak) IBOutlet UILabel *extrasTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *extrasCostLabel;
@property (nonatomic, weak) IBOutlet UITableViewCell *costCell;
@property (nonatomic, weak) IBOutlet UILabel *pickUpDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *dropOffDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *numberOfPeopleLabel;
@property (nonatomic, weak) IBOutlet UILabel *baggageLabel;
@property (nonatomic, weak) IBOutlet UILabel *numberOfDoorsLabel;
@property (nonatomic, weak) IBOutlet UILabel *extraFeaturesLabel;
@property (nonatomic, weak) IBOutlet UILabel *depositLabel;
@property (nonatomic, weak) IBOutlet UILabel *bookingFeeLabel;
@property (nonatomic, weak) IBOutlet UILabel *extrasLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, weak) IBOutlet UILabel *arrivalAmountLabel;
@property (nonatomic, weak) IBOutlet UIButton *acceptConditionsButton;
@property (nonatomic, assign) BOOL acceptedConditions;
@property (nonatomic, assign) BOOL acceptedRentalTerms;
@property (nonatomic, assign) BOOL acceptedEngineTerms;
@property (nonatomic, weak) IBOutlet UITableViewCell *termsCell;
@property (nonatomic, weak) IBOutlet UIImageView *vendorLogo;
@property (nonatomic, weak) IBOutlet UIImageView *carLogo;
@property (nonatomic, weak) IBOutlet UILabel *carCategoryLabel;
@property (nonatomic, weak) IBOutlet UITableViewCell *overViewCell;
@property (nonatomic, weak) IBOutlet UILabel *pickUpLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *dropOffLocationLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalCostLabel;
@property (nonatomic, strong) UISegmentedControl *visaMasterSegment;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) RentalSession *session;

@property (nonatomic, strong) UITextField *givenNameTB;
@property (nonatomic, strong) UITextField *namePrefixTB;
@property (nonatomic, strong) UITextField *surnameTB;

@property (nonatomic, strong) UITextField *nameTB;  // The name is being put in as a single box, we can loose the other 3.

@property (nonatomic, strong) UITextField *phoneAreaCodeTB;
@property (nonatomic, strong) UITextField *phoneNumberTB;
@property (nonatomic, strong) UITextField *emailAddressTB;
@property (nonatomic, strong) UITextField *addressTB;
@property (nonatomic, strong) UITextField *countryCodeTB;
@property (nonatomic, strong) UITextField *ccHolderNameTB;
@property (nonatomic, strong) UITextField *ccNumberTB;
@property (nonatomic, strong) UITextField *ccExpDateTB;
@property (nonatomic, strong) UITextField *ccSeriesCodeTB;
@property (nonatomic, strong) UITextField *flightNumberTB;
@property (nonatomic, weak) IBOutlet UITableView *bookingTable;

- (void) resetPersonalDetails;
- (void) saveUserPrefs;
- (void) loadUserPrefs;

- (IBAction) acceptedConditionButtonPressed:(id)sender;
- (IBAction) readRentalConditionsPressed:(id)sender;
- (IBAction) readEngineConditionsPressed:(id)sender;
	
@end
