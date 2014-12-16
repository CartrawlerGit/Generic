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
