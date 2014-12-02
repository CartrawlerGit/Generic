
#import "CustomLocationCell.h"


@implementation CustomLocationCell

@synthesize locationNameLabel;
@synthesize locationAddressLabel;
@synthesize locationDistanceLabel;
@synthesize selectBtn;
@synthesize locationIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    /*
	[locationIcon release];

	[locationNameLabel release];
	[locationAddressLabel release];
	[locationDistanceLabel release];
	[selectBtn release];

    [super dealloc];
     */
}

- (IBAction) cellPressed { }

@end
