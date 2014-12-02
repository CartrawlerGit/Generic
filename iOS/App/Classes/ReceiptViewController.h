//
//  ReceiptViewController.h
//  CarTrawler
//
//

@class Booking;

@interface ReceiptViewController : UIViewController {
	UILabel		*emailLabel;
	UILabel		*refLabel;
	Booking		*theBooking;
	UIButton	*exitBtn;
}

@property (nonatomic, retain) IBOutlet UILabel *refLabel;
@property (nonatomic, retain) IBOutlet UIButton *exitBtn;
@property (nonatomic, retain) Booking *theBooking;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;

- (IBAction)exitBtnPressed:(id)sender;

@end
