//
//  CustomCarDisplayCell.m
//  CarTrawler
//


#import "CustomCarDisplayCell.h"


@implementation CustomCarDisplayCell

@synthesize additionalExtrasLabel;
@synthesize numberOfPeopleLabel;
@synthesize currencyLabelBG;
@synthesize currencyLabel;
@synthesize vendorImageView;
@synthesize totalLabel;
@synthesize numberOfDoorsLabel;
@synthesize acImageView;
@synthesize fuelTypeImageView;
@synthesize transmissionType;
@synthesize fuelLabel;
@synthesize baggageLabel;
@synthesize moreInfoBtn;
@synthesize infoLabel;
@synthesize carMakeModelLabel;
@synthesize carImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    /*
	[carMakeModelLabel release];
	[carImageView release];
	[infoLabel release];
	[moreInfoBtn release];
	[transmissionType release];
	[fuelLabel release];
	[baggageLabel release];
	[fuelTypeImageView release];
	[acImageView release];
	[numberOfDoorsLabel release];
	[totalLabel release];
	[vendorImageView release];
	[currencyLabel release];
	[currencyLabelBG release];
	[numberOfPeopleLabel release];
	numberOfPeopleLabel = nil;
	[additionalExtrasLabel release];
	additionalExtrasLabel = nil;
    [super dealloc];*/
}


@end
