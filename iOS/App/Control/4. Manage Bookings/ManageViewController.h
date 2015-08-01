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
//  ManageViewController.h
//  CarTrawler
//

@class Booking;

@interface ManageViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
	
    /*BOOL			pageControlIsChangingPage;
	NSMutableArray	*arrayOfBookings;
	NSMutableArray	*arrayOfReceiptViewControllers;
	
	UIBarButtonItem *storedBtn;
	UIBarButtonItem *downloadBtn;
	
	NSNotification *n;*/
}

@property (nonatomic, strong) NSNotification *n;
@property (nonatomic, strong) UIBarButtonItem *storedBtn;
@property (nonatomic, strong) UIBarButtonItem *downloadBtn;
@property (nonatomic, weak) IBOutlet UITextField *bookingEmailTB;
@property (nonatomic, weak) IBOutlet UITextField *bookingIDTB;
@property (nonatomic, weak) IBOutlet UIView *getBookingView;
@property (nonatomic, strong) NSMutableArray *arrayOfReceiptViewControllers;
@property (nonatomic, strong) NSMutableArray *arrayOfBookings;

@property (nonatomic, weak) IBOutlet UILabel *noBookingsLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UILabel *numBookingsLabel;


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