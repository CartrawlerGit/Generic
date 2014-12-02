//
//  CustomExtrasCell.m
//  CarTrawler
//
//

#import "CustomExtrasCell.h"
#import "ExtraEquipment.h"

@implementation CustomExtrasCell

@synthesize extraQtyLabel;
@synthesize extraNameLabel;
@synthesize extraCurrencyLabel;
@synthesize extraCostLabel;
@synthesize plusBtn;
@synthesize minusBtn;


- (IBAction)increaseQty:(id)sender {
	UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
	UITableView *table = (UITableView *)[cell superview];
	NSIndexPath *path = [table indexPathForCell:cell];
	
	DLog(@"been pressed %ld is %ld",(long)path.section, (long)path.row);
}

- (IBAction)decreaseQty:(id)sender {
	DLog(@"Decrease");
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}

- (void)dealloc {
	[extraNameLabel release];
	extraNameLabel = nil;
	[extraCurrencyLabel release];
	extraCurrencyLabel = nil;
	[extraCostLabel release];
	extraCostLabel = nil;
	[plusBtn release];
	plusBtn = nil;
	[minusBtn release];
	minusBtn = nil;

	[extraQtyLabel release];
	extraQtyLabel = nil;

    [super dealloc];
}


@end
