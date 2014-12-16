//
// Copyright 2014 Etrawler
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
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
