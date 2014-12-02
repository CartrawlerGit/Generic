//
//  FindBookingViewController.h
//  CarTrawler
//

@class Booking;

@interface FindBookingViewController : UIViewController <UIWebViewDelegate> {
	UIActivityIndicatorView	*spinner;
	Booking *b;
}

@property (nonatomic, retain) Booking *b;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction) dismissView;

@end
