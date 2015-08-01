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

@property (nonatomic, weak) IBOutlet UIButton *amendBookingButton;
@property (nonatomic, weak) IBOutlet UILabel *amendBookingLabel;
@property (nonatomic, weak) IBOutlet UILabel *ammendBookingLabelUnderLine;
@property (nonatomic, copy) NSString *selectedNumberToCall;
@property (nonatomic, weak) IBOutlet UIButton *callCustomerCareBtn;
@property (nonatomic, weak) IBOutlet UIButton *callDeskBtn;
@property (nonatomic, weak) IBOutlet UILabel *vendorNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *vendorImage;
@property (nonatomic, weak) IBOutlet UIImageView *carImage;
@property (nonatomic, weak) IBOutlet UILabel *vendorReferenceNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *ctReferenceNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *ctConfNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickupLocationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickUpLocationPhoneNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *puDateTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *doDateTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *customCarePhoneNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *carTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalPriceLabel;
@property (nonatomic, strong) Booking *theBooking;


- (IBAction) amendBookingButtonPressed;
- (IBAction) requestEmail;
- (IBAction) callPhoneNumber;
- (IBAction) showLocationOnMap;
- (IBAction) showActionSheet:(id)sender;
- (IBAction) deleteReceipt;

@end
