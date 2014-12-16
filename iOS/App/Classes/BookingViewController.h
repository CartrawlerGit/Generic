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
	UITableView		*bookingTable;
	
	UITextField		*namePrefixTB;
	UITextField		*givenNameTB;
	UITextField		*surnameTB;
	UITableViewCell	*costCell;
	
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
	
	UITableViewCell *overViewCell;
	UILabel			*carCategoryLabel;
	UILabel			*pickUpLocationLabel;
	UILabel			*dropOffLocationLabel;
	UILabel			*totalCostLabel;
	UIImageView		*vendorLogo;
	UIImageView		*carLogo;
	UILabel			*pickUpDateLabel;
	UILabel			*dropOffDateLabel;	
	UILabel			*numberOfPeopleLabel;
	UILabel			*baggageLabel;
	UILabel			*numberOfDoorsLabel;
	UILabel			*extraFeaturesLabel;
	
	// Cost Cell Layout
	
	UILabel			*dropOffHeaderLabel;
	UILabel			*depositLabel;
	UILabel			*bookingFeeLabel;
	UILabel			*extrasLabel;
	UILabel			*extrasCostLabel;
	UILabel			*totalLabel;
	UILabel			*arrivalAmountLabel;
	
	UILabel			*extrasTitleLabel;
	
	UITableViewCell	*termsCell;
	
	BOOL			acceptedRentalTerms;
	BOOL			acceptedEngineTerms;
	BOOL			acceptedConditions;
	
	UIButton		*acceptConditionsButton;
	
	BOOL			haveGivenName;
	BOOL			haveSurname;
	BOOL			haveEmailAddress;
	BOOL			haveAddress;
	BOOL			haveFlightNumber;
	BOOL			havePhoneNumber;
	
	BOOL			hasAlternateDropOff;
	
	UILabel			*insuranceLabelForCostSection;
	UILabel			*insuranceCostTitleLabel;
	
	NSString		*selectedCardType;

}

@property (nonatomic, copy) NSString *selectedCardType;
@property (nonatomic, retain) IBOutlet UILabel *insuranceCostTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *insuranceLabelForCostSection;
@property (nonatomic, retain) IBOutlet UILabel *dropOffHeaderLabel;
@property (nonatomic, assign) BOOL hasAlternateDropOff;
@property (nonatomic, assign) BOOL haveGivenName;
@property (nonatomic, assign) BOOL haveSurname;
@property (nonatomic, assign) BOOL haveEmailAddress;
@property (nonatomic, assign) BOOL haveAddress;
@property (nonatomic, assign) BOOL haveFlightNumber;
@property (nonatomic, assign) BOOL havePhoneNumber;
@property (nonatomic, retain) IBOutlet UILabel *extrasTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *extrasCostLabel;
@property (nonatomic, retain) IBOutlet UITableViewCell *costCell;
@property (nonatomic, retain) IBOutlet UILabel *pickUpDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *dropOffDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *numberOfPeopleLabel;
@property (nonatomic, retain) IBOutlet UILabel *baggageLabel;
@property (nonatomic, retain) IBOutlet UILabel *numberOfDoorsLabel;
@property (nonatomic, retain) IBOutlet UILabel *extraFeaturesLabel;
@property (nonatomic, retain) IBOutlet UILabel *depositLabel;
@property (nonatomic, retain) IBOutlet UILabel *bookingFeeLabel;
@property (nonatomic, retain) IBOutlet UILabel *extrasLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;
@property (nonatomic, retain) IBOutlet UILabel *arrivalAmountLabel;
@property (nonatomic, retain) IBOutlet UIButton *acceptConditionsButton;
@property (nonatomic, assign) BOOL acceptedConditions;
@property (nonatomic, assign) BOOL acceptedRentalTerms;
@property (nonatomic, assign) BOOL acceptedEngineTerms;
@property (nonatomic, retain) IBOutlet UITableViewCell *termsCell;
@property (nonatomic, retain) IBOutlet UIImageView *vendorLogo;
@property (nonatomic, retain) IBOutlet UIImageView *carLogo;
@property (nonatomic, retain) IBOutlet UILabel *carCategoryLabel;
@property (nonatomic, retain) IBOutlet UITableViewCell *overViewCell;
@property (nonatomic, retain) IBOutlet UILabel *pickUpLocationLabel;
@property (nonatomic, retain) IBOutlet UILabel *dropOffLocationLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalCostLabel;
@property (nonatomic, retain) UISegmentedControl *visaMasterSegment;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) RentalSession *session;

@property (nonatomic, retain) UITextField *givenNameTB;
@property (nonatomic, retain) UITextField *namePrefixTB;
@property (nonatomic, retain) UITextField *surnameTB;

@property (nonatomic, retain) UITextField *nameTB;  // The name is being put in as a single box, we can loose the other 3.

@property (nonatomic, retain) UITextField *phoneAreaCodeTB;
@property (nonatomic, retain) UITextField *phoneNumberTB;
@property (nonatomic, retain) UITextField *emailAddressTB;
@property (nonatomic, retain) UITextField *addressTB;
@property (nonatomic, retain) UITextField *countryCodeTB;
@property (nonatomic, retain) UITextField *ccHolderNameTB;
@property (nonatomic, retain) UITextField *ccNumberTB;
@property (nonatomic, retain) UITextField *ccExpDateTB;
@property (nonatomic, retain) UITextField *ccSeriesCodeTB;
@property (nonatomic, retain) UITextField *flightNumberTB;
@property (nonatomic, retain) IBOutlet UITableView *bookingTable;

- (void) resetPersonalDetails;
- (void) saveUserPrefs;
- (void) loadUserPrefs;

- (IBAction) acceptedConditionButtonPressed:(id)sender;
- (IBAction) readRentalConditionsPressed:(id)sender;
- (IBAction) readEngineConditionsPressed:(id)sender;
	
@end
