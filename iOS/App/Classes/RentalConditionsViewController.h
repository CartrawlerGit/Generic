//
//  RentalConditionsViewController.h
//  CarTrawler
//
//

@class RentalSession;

@interface RentalConditionsViewController : UIViewController <UIWebViewDelegate> {
	
	RentalSession		*session;
	NSMutableArray		*termsArray;
	UIButton			*acceptButton;
	UIButton			*rejectButton;
	UIWebView			*aWebView;
	
	BOOL				bookingEngineTermsAndConditions;
	
	UIActivityIndicatorView	*spinner;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, assign) BOOL bookingEngineTermsAndConditions;
@property (nonatomic, retain) NSMutableArray	*termsArray;
@property (nonatomic, retain) RentalSession		*session;
@property (nonatomic, retain) UIButton			*acceptButton;
@property (nonatomic, retain) UIButton			*rejectButton;

- (IBAction)sendAcceptNotification:(id)sender;
- (void) initUIWebView;
- (IBAction) dismissView;

@end
