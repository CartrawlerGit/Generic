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
@property (nonatomic, strong) IBOutlet UILabel *insuranceCostTitleLabel;
@property (nonatomic, strong) IBOutlet UIView *insuranceDetailView;
@property (nonatomic, strong) IBOutlet UIButton *findOutMoreButton;
@property (nonatomic, assign) BOOL wantsMoreInsuranceInfo;
@property (nonatomic, strong) IBOutlet UILabel *dropOffHeaderLabel;
@property (nonatomic, strong) IBOutlet UILabel *insuranceLabelForCostSection;
@property (nonatomic, assign) BOOL wantsInsuranceCover;
@property (nonatomic, strong) IBOutlet UILabel *extrasTitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *buyInsuranceButton;
@property (nonatomic, strong) IBOutlet UIButton *insuranceTermsButton;
@property (nonatomic, strong) IBOutlet UILabel *basePremiumPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *insurancePriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *calculatingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *insuranceSpinner;
@property (nonatomic, assign) BOOL hasAlternateDropOff;
@property (nonatomic, assign) BOOL showInsurance;
@property (nonatomic, assign) BOOL acceptedRentalTerms;
@property (nonatomic, assign) BOOL acceptedEngineTerms;
@property (nonatomic, assign) BOOL showExtras;
@property (nonatomic, assign) BOOL acceptedConditions;
@property (nonatomic, strong) IBOutlet UILabel *extraFeaturesLabel;
@property (nonatomic, strong) IBOutlet UILabel *pickUpDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *dropOffDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberOfPeopleLabel;
@property (nonatomic, strong) IBOutlet UILabel *dropOffLocationLabel;
@property (nonatomic, strong) IBOutlet UILabel *pickUpLocationLabel;
@property (nonatomic, strong) IBOutlet UILabel *extrasCostLabel;
@property (nonatomic, strong) IBOutlet UIButton *readConditionsButton;
@property (nonatomic, strong) IBOutlet UIButton *acceptConditionsButton;
@property (nonatomic, strong) IBOutlet UILabel *arrivalAmountLabel;
@property (nonatomic, strong) IBOutlet UILabel *depositLabel;
@property (nonatomic, strong) IBOutlet UILabel *bookingFeeLabel;
@property (nonatomic, strong) IBOutlet UILabel *extrasLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalLabel;
@property (nonatomic, strong) IBOutlet UILabel *carCategoryLabel;
@property (nonatomic, strong) IBOutlet UIImageView *vendorImageView;
@property (nonatomic, strong) IBOutlet UILabel *carMakeModelLabel;
@property (nonatomic, strong) IBOutlet UIImageView *carImageView;
@property (nonatomic, strong) IBOutlet UIImageView *transmissionType;
@property (nonatomic, strong) IBOutlet UIImageView *fuelTypeImageView;
@property (nonatomic, strong) IBOutlet UIImageView *acImageView;
@property (nonatomic, strong) IBOutlet UILabel *fuelLabel;
@property (nonatomic, strong) IBOutlet UILabel *baggageLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberOfDoorsLabel;
@property (nonatomic, strong) IBOutlet UITableViewCell *costCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *extrasCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *termsCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *vehicleCell;
@property (nonatomic, strong) IBOutlet UITableView *confirmationTable;
@property (nonatomic, strong) IBOutlet UITableViewCell *insuranceCell;
@property (nonatomic, strong) RentalSession *session;
@property (nonatomic, copy) NSString *extrasString;

- (IBAction) bookThisThing:(id)sender;
- (IBAction) acceptedConditionButtonPressed:(id)sender;
- (IBAction) readRentalConditionsPressed:(id)sender;
- (IBAction) readEngineConditionsPressed:(id)sender;
- (IBAction) presentInuranceTerms;
- (IBAction) buyInsurance;
- (IBAction) wantsMoreInsuranceInfoAction;

@end
