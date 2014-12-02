//
//  ReceiptView.h
//  CarTrawler
//

#import <MessageUI/MessageUI.h>

@class Booking;

@interface ReceiptView : UIViewController <UIAlertViewDelegate>
{
	Booking		*theBooking;

	UIImageView	*vendorImage;
	UIImageView	*carImage;
	
	UILabel		*vendorReferenceNumberLabel;
	UILabel		*ctReferenceNumberLabel;
	UILabel		*ctConfNumberLabel;
	UILabel		*vendorNameLabel;
	UILabel		*pickupLocationNameLabel;
	
	UILabel		*pickUpLocationPhoneNumberLabel;
	UILabel		*customCarePhoneNumberLabel;
	
	UILabel		*puDateTimeLabel;
	UILabel		*doDateTimeLabel;

	UILabel		*carTypeLabel;
	
	UILabel		*totalPriceLabel;
	
	UIButton	*callDeskBtn;
	UIButton	*callCustomerCareBtn;
	NSString	*selectedNumberToCall;
	
	UILabel		*amendBookingLabel;
	UILabel		*ammendBookingLabelUnderLine;
	
	UIButton	*amendBookingButton;
}

@property (nonatomic, retain) IBOutlet UIButton *amendBookingButton;
@property (nonatomic, retain) IBOutlet UILabel *amendBookingLabel;
@property (nonatomic, retain) IBOutlet UILabel *ammendBookingLabelUnderLine;
@property (nonatomic, copy) NSString *selectedNumberToCall;
@property (nonatomic, retain) IBOutlet UIButton *callCustomerCareBtn;
@property (nonatomic, retain) IBOutlet UIButton *callDeskBtn;
@property (nonatomic, retain) IBOutlet UILabel *vendorNameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *vendorImage;
@property (nonatomic, retain) IBOutlet UIImageView *carImage;
@property (nonatomic, retain) IBOutlet UILabel *vendorReferenceNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *ctReferenceNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *ctConfNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *pickupLocationNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *pickUpLocationPhoneNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *puDateTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *doDateTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *customCarePhoneNumberLabel;
@property (nonatomic, retain) IBOutlet UILabel *carTypeLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalPriceLabel;
@property (nonatomic, retain) Booking *theBooking;


- (IBAction) amendBookingButtonPressed;
- (IBAction) requestEmail;
- (IBAction) callPhoneNumber;
- (IBAction) showLocationOnMap;
- (IBAction) showActionSheet:(id)sender;
- (IBAction) deleteReceipt;

@end
