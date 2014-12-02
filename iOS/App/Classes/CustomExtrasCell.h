//
//  CustomExtrasCell.h
//  CarTrawler
//
//


@interface CustomExtrasCell : UITableViewCell {
	UILabel		*extraNameLabel;
	UILabel		*extraCurrencyLabel;
	UILabel		*extraCostLabel;
	UILabel		*extraQtyLabel;
	
	UIButton	*plusBtn;
	UIButton	*minusBtn;
}

@property (nonatomic, retain) IBOutlet UILabel *extraQtyLabel;
@property (nonatomic, retain) IBOutlet UILabel *extraNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *extraCurrencyLabel;
@property (nonatomic, retain) IBOutlet UILabel *extraCostLabel;
@property (nonatomic, retain) IBOutlet UIButton *plusBtn;
@property (nonatomic, retain) IBOutlet UIButton *minusBtn;

- (IBAction)increaseQty:(id)sender;
- (IBAction)decreaseQty:(id)sender;
@end
