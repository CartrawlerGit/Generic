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