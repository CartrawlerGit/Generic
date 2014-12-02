
@interface CustomLocationCell : UITableViewCell {
	
	UIImageView		*locationIcon;
	UILabel			*locationNameLabel;
	UILabel			*locationAddressLabel;
	UILabel			*locationDistanceLabel;
	UIButton		*selectBtn;
	
}

@property (nonatomic, retain) IBOutlet UILabel *locationNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationAddressLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationDistanceLabel;
@property (nonatomic, retain) IBOutlet UIButton *selectBtn;
@property (nonatomic, retain) IBOutlet UIImageView *locationIcon;

-(IBAction) cellPressed;

@end
