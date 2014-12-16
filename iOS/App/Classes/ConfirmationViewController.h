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
//  ConfirmationViewController.h
//  CarTrawler
//
//

@class RentalSession;

@interface ConfirmationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate>{
	
	RentalSession	*session;
	
	UITableView		*confirmationTable;
	
	UITableViewCell	*vehicleCell;
	UITableViewCell	*costCell;
	UITableViewCell	*extrasCell;
	UITableViewCell	*termsCell;
	UITableViewCell	*insuranceCell;
	
	// Vehicle Cell Layout
	
	UIImageView		*vendorImageView;
	UIImageView		*carImageView;
	UIImageView		*transmissionType;
	UIImageView		*fuelTypeImageView;
	UIImageView		*acImageView;
	
	UILabel			*carMakeModelLabel;
	UILabel			*fuelLabel;
	UILabel			*baggageLabel;
	UILabel			*numberOfDoorsLabel;
	UILabel			*carCategoryLabel;
	UILabel			*extrasCostLabel;
	UILabel			*numberOfPeopleLabel;
	
	UILabel			*dropOffLocationLabel;
	UILabel			*pickUpLocationLabel;
	
	UILabel			*pickUpDateLabel;
	UILabel			*dropOffDateLabel;	
	
	UILabel			*extraFeaturesLabel;
	
	// Cost Cell Layout
	
	UILabel			*depositLabel;
	UILabel			*bookingFeeLabel;
	UILabel			*extrasLabel;
	UILabel			*totalLabel;
	UILabel			*arrivalAmountLabel;
	
	UILabel			*extrasTitleLabel;
	// Rental Conditions Layout
	
	UIButton		*readConditionsButton;
	UIButton		*acceptConditionsButton;
	BOOL			acceptedConditions;
	
	NSString		*extrasString;
	
	BOOL			hasAlternateDropOff;
	BOOL			showExtras;
	BOOL			showInsurance;
	BOOL			acceptedRentalTerms;
	BOOL			acceptedEngineTerms;
	BOOL			wantsInsuranceCover;	// YES when the person has hit the "But Insurance" button.
	BOOL			wantsMoreInsuranceInfo;
	
	UILabel			*dropOffHeaderLabel;
	
	// Insurance Control
	
	UIActivityIndicatorView	*insuranceSpinner;
	UILabel					*calculatingLabel;
	BOOL					hasInsuranceObject;
	UILabel					*insurancePriceLabel;
	UILabel					*basePremiumPriceLabel;
	UIButton				*insuranceTermsButton;
	UIButton				*buyInsuranceButton;
	UILabel					*insuranceLabelForCostSection;
	UIButton				*findOutMoreButton;
	UILabel					*insuranceCostTitleLabel;
	
	UIView					*insuranceDetailView;
	
	BOOL					noInsuranceForThisRegion;
}

@property (nonatomic, assign) BOOL noInsuranceForThisRegion;
@property (nonatomic, retain) IBOutlet UILabel *insuranceCostTitleLabel;
@property (nonatomic, retain) IBOutlet UIView *insuranceDetailView;
@property (nonatomic, retain) IBOutlet UIButton *findOutMoreButton;
@property (nonatomic, assign) BOOL wantsMoreInsuranceInfo;
@property (nonatomic, retain) IBOutlet UILabel *dropOffHeaderLabel;
@property (nonatomic, retain) IBOutlet UILabel *insuranceLabelForCostSection;
@property (nonatomic, assign) BOOL wantsInsuranceCover;
@property (nonatomic, retain) IBOutlet UILabel *extrasTitleLabel;
@property (nonatomic, retain) IBOutlet UIButton *buyInsuranceButton;
@property (nonatomic, retain) IBOutlet UIButton *insuranceTermsButton;
@property (nonatomic, retain) IBOutlet UILabel *basePremiumPriceLabel;
@property (nonatomic, retain) IBOutlet UILabel *insurancePriceLabel;
@property (nonatomic, retain) IBOutlet UILabel *calculatingLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *insuranceSpinner;
@property (nonatomic, assign) BOOL hasAlternateDropOff;
@property (nonatomic, assign) BOOL showInsurance;
@property (nonatomic, assign) BOOL acceptedRentalTerms;
@property (nonatomic, assign) BOOL acceptedEngineTerms;
@property (nonatomic, assign) BOOL showExtras;
@property (nonatomic, assign) BOOL acceptedConditions;
@property (nonatomic, retain) IBOutlet UILabel *extraFeaturesLabel;
@property (nonatomic, retain) IBOutlet UILabel *pickUpDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *dropOffDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *numberOfPeopleLabel;
@property (nonatomic, retain) IBOutlet UILabel *dropOffLocationLabel;
@property (nonatomic, retain) IBOutlet UILabel *pickUpLocationLabel;
@property (nonatomic, retain) IBOutlet UILabel *extrasCostLabel;
@property (nonatomic, retain) IBOutlet UIButton *readConditionsButton;
@property (nonatomic, retain) IBOutlet UIButton *acceptConditionsButton;
@property (nonatomic, retain) IBOutlet UILabel *arrivalAmountLabel;
@property (nonatomic, retain) IBOutlet UILabel *depositLabel;
@property (nonatomic, retain) IBOutlet UILabel *bookingFeeLabel;
@property (nonatomic, retain) IBOutlet UILabel *extrasLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;
@property (nonatomic, retain) IBOutlet UILabel *carCategoryLabel;
@property (nonatomic, retain) IBOutlet UIImageView *vendorImageView;
@property (nonatomic, retain) IBOutlet UILabel *carMakeModelLabel;
@property (nonatomic, retain) IBOutlet UIImageView *carImageView;
@property (nonatomic, retain) IBOutlet UIImageView *transmissionType;
@property (nonatomic, retain) IBOutlet UIImageView *fuelTypeImageView;
@property (nonatomic, retain) IBOutlet UIImageView *acImageView;
@property (nonatomic, retain) IBOutlet UILabel *fuelLabel;
@property (nonatomic, retain) IBOutlet UILabel *baggageLabel;
@property (nonatomic, retain) IBOutlet UILabel *numberOfDoorsLabel;
@property (nonatomic, retain) IBOutlet UITableViewCell *costCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *extrasCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *termsCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *vehicleCell;
@property (nonatomic, retain) IBOutlet UITableView *confirmationTable;
@property (nonatomic, retain) IBOutlet UITableViewCell *insuranceCell;
@property (nonatomic, retain) RentalSession *session;
@property (nonatomic, copy) NSString *extrasString;

- (IBAction) bookThisThing:(id)sender;
- (IBAction) acceptedConditionButtonPressed:(id)sender;
- (IBAction) readRentalConditionsPressed:(id)sender;
- (IBAction) readEngineConditionsPressed:(id)sender;
- (IBAction) presentInuranceTerms;
- (IBAction) buyInsurance;
- (IBAction) wantsMoreInsuranceInfoAction;

@end
