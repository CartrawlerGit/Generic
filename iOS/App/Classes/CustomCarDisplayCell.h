//
//  CustomCarDisplayCell.h
//  CarTrawler
//

#import <UIKit/UIKit.h>

@interface CustomCarDisplayCell : UITableViewCell {
	UILabel			*carMakeModelLabel;
	UILabel			*infoLabel;
	
	UIButton		*moreInfoBtn;
	
	UIImageView		*carImageView;
	UIImageView		*transmissionType;
	UIImageView		*fuelTypeImageView;
	UIImageView		*acImageView;
	UIImageView		*vendorImageView;
	
	UILabel			*fuelLabel;
	UILabel			*baggageLabel;
	UILabel			*numberOfDoorsLabel;
	UILabel			*totalLabel;
	UILabel			*currencyLabel;
	UILabel			*currencyLabelBG;
	UILabel			*numberOfPeopleLabel;
	UILabel			*additionalExtrasLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *additionalExtrasLabel;
@property (nonatomic, retain) IBOutlet UILabel *numberOfPeopleLabel;
@property (nonatomic, retain) IBOutlet UILabel *currencyLabelBG;
@property (nonatomic, retain) IBOutlet UILabel *currencyLabel;
@property (nonatomic, retain) IBOutlet UIImageView *vendorImageView;
@property (nonatomic, retain) IBOutlet UILabel *totalLabel;
@property (nonatomic, retain) IBOutlet UILabel *numberOfDoorsLabel;
@property (nonatomic, retain) IBOutlet UIImageView *acImageView;
@property (nonatomic, retain) IBOutlet UIImageView *fuelTypeImageView;
@property (nonatomic, retain) IBOutlet UIImageView *transmissionType;
@property (nonatomic, retain) IBOutlet UILabel *fuelLabel;
@property (nonatomic, retain) IBOutlet UILabel *baggageLabel;
@property (nonatomic, retain) IBOutlet UIButton *moreInfoBtn;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
@property (nonatomic, retain) IBOutlet UILabel *carMakeModelLabel;
@property (nonatomic, retain) IBOutlet UIImageView *carImageView;

@end
