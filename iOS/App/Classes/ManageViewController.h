//
//  ManageViewController.h
//  CarTrawler
//

@class Booking;

@interface ManageViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {	
	UIScrollView	*scrollView;
	UIPageControl	*pageControl;
	
    BOOL			pageControlIsChangingPage;
	NSMutableArray	*arrayOfBookings;
	NSMutableArray	*arrayOfReceiptViewControllers;
	NSInteger		numBookings;
	
	UILabel			*numBookingsLabel;
	
	UILabel			*noBookingsLabel;
	
	UIView			*getBookingView;
	UITextField		*bookingEmailTB;
	UITextField		*bookingIDTB;
	
	UIBarButtonItem *storedBtn;
	UIBarButtonItem *downloadBtn;
	
	NSNotification *n;
}

@property (nonatomic, retain) NSNotification *n;
@property (nonatomic, retain) UIBarButtonItem *storedBtn;
@property (nonatomic, retain) UIBarButtonItem *downloadBtn;
@property (nonatomic, retain) IBOutlet UITextField *bookingEmailTB;
@property (nonatomic, retain) IBOutlet UITextField *bookingIDTB;
@property (nonatomic, retain) IBOutlet UIView *getBookingView;
@property (nonatomic, retain) NSMutableArray *arrayOfReceiptViewControllers;
@property (nonatomic, retain) NSMutableArray *arrayOfBookings;

@property (nonatomic, retain) IBOutlet UILabel *noBookingsLabel;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UILabel *numBookingsLabel;


- (Booking *) loadCustomObjectWithKey:(NSString *)key dictionary:(NSDictionary *)bookings;
- (IBAction) changePage:(id)sender;
- (IBAction) searchButtonPressed;
- (void) setupPage;
- (void) checkForBookings; 
- (void) resetArrayofReceiptViewControllers;

- (IBAction) getBookingInfo;
- (IBAction) showGetBookingInfoView;
- (IBAction) hideGetBookingInfoView;

@end