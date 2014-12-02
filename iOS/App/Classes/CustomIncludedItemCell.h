//
//  CustomIncludedItemCell.h
//  CarTrawler
//
//

@interface CustomIncludedItemCell : UITableViewCell {
	UILabel		*itemLabel;
	UIImageView	*isIncludedImage;
	
	UILabel		*totalPrice;
	UILabel		*totalPriceLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *itemLabel;
@property (nonatomic, retain) IBOutlet UIImageView *isIncludedImage;

@end
