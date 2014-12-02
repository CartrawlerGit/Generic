//
//  RentalConditionsViewController.m
//  CarTrawler
//
//

#import "CarTrawlerAppDelegate.h"
#import "RentalConditionsViewController.h"
#import "BookingViewController.h"
#import "RentalSession.h"
#import "Car.h"
#import "termsAndConditions.h"
#import <UIKit/UIWebView.h>
#import "CarTrawlerAppDelegate.h"

#ifdef NSFoundationVersionNumber_iOS_6_1
#define SD_IS_IOS6 (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
#else
#define SD_IS_IOS6 YES
#endif

@implementation RentalConditionsViewController

@synthesize spinner;
@synthesize bookingEngineTermsAndConditions;
@synthesize session;
@synthesize termsArray;
@synthesize acceptButton;
@synthesize rejectButton;

#pragma mark -
#pragma mark API Stuff

CTHudViewController *hud;

- (void) makeRequest {
	NSString *requestString = [CTRQBuilder CT_RentalConditionsRQ:session.puDateTime doDateTime:session.doDateTime puLocationCode:session.puLocationCode doLocationCode:session.doLocationCode homeCountry:session.homeCountry refType:session.theCar.refType refID:session.theCar.refID refIDContext:session.theCar.refIDContext refURL:session.theCar.refURL];
	ASIHTTPRequest *request = [CTHelper makeRequest:kCT_RentalConditionsRQ withSpecificHeader:[CTRQBuilder buildHeader:kRentalReqHeader] tail:requestString];
	
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *) request {
	NSString *responseString = [request responseString];
	
	NSDictionary *responseDict = [responseString JSONValue];
	termsArray = [NSMutableArray arrayWithArray:[CTHelper validateResponse:responseDict]];
	
	[self initUIWebView];
}

- (void) requestFailed:(ASIHTTPRequest *) request {
	DLog(@"requestFailed");
	NSError *error = [request error];
	Error(@"%@", error);
} 

#pragma mark -
#pragma mark Pass to booking view

- (IBAction)sendAcceptNotification:(id)sender {
	if (bookingEngineTermsAndConditions) {
		DLog(@"Engine Terms & Conditions OK");
		[[NSNotificationCenter defaultCenter] postNotificationName:@"engineTermsAccepted" object:self userInfo:nil];
	} else {
		DLog(@"Rental Terms & Conditions OK");
		[[NSNotificationCenter defaultCenter] postNotificationName:@"termsAndConditionsAccepted" object:self userInfo:nil];
	}

	[self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -
#pragma mark UIWebView Delegate Methods

- (void)webViewDidStartLoad:(UIWebView *)wv {
    [spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    [spinner stopAnimating];
	[spinner setHidden:YES];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    [spinner stopAnimating];
    if (error != NULL) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle: [error localizedDescription]
								   message: [error localizedFailureReason]
								   delegate:nil
								   cancelButtonTitle:@"OK" 
								   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
    }
	[spinner setHidden:YES];
}

#pragma mark -
#pragma mark Lifecycle stuff

- (id) init {
    self=[super initWithNibName:@"RentalConditionsViewController" bundle:nil];
    
	// … give ivars initial values…
	//self.refLabel.text = theBooking.confID;
	
    return self;
}

- (id) initWithNibName:(NSString *)n bundle:(NSBundle *)b {
    return [self init];
}

- (void) viewDidLoad {
	[self makeRequest];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
	self.session = nil;
    [super viewDidUnload];
}

- (void) dealloc {
	[session release];
	[aWebView release];

	[spinner release];
	spinner = nil;
    [super dealloc];
}

- (void) initUIWebView {

            if (SD_IS_IOS6) {
                aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, [UIScreen mainScreen].bounds.size.height - 128 )];
            } else {
                aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - 128 )];
            }
	aWebView.autoresizesSubviews = YES;
	aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[aWebView setBackgroundColor:[UIColor clearColor]];
	[aWebView setOpaque:NO];
	
	[aWebView setDelegate:self];
	
	termsAndConditions *tsAndCs; 
	
	if (bookingEngineTermsAndConditions) {
		
		CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
		NSString *url = appDelegate.engineConditionsURL; //@"http://www.cartrawler.com/booking-conditions/mobile/?lang=EN";
		NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
		[aWebView loadRequest:theRequest];
		
	} else {
		NSMutableString *htmlString = [[NSMutableString alloc] init];
		
		NSInteger numberOfTermsAndConditions = [termsArray count];
		
		[htmlString appendString:@"<html><head><style type=\"text/css\">"
		 "html {-webkit-text-size-adjust:80%;background-image: BGD_480x480.png; color:black; background-color:transparent }"
		 "h1 {font-family:\"Helvetica\"; font-size:90%; color:black}"
		 "body {font-family:\"Helvetica\"}"
		 "</style></head><body><br/>"];
		
		
		for (int i=0; i<numberOfTermsAndConditions; i++)
		{
			tsAndCs = [termsArray objectAtIndex:i];
			[htmlString appendString:@"<h1>"];
			[htmlString appendString:tsAndCs.titleText];
			[htmlString appendString:@"</h1><p>"];
			[htmlString appendString:tsAndCs.bodyText];
			[htmlString appendString:@"</p><br/>"];
		}
		
		[htmlString appendString:@"<body></html>"];
		
		[aWebView loadHTMLString:htmlString baseURL:nil];
		[htmlString release];
	}
	
	[[self view] addSubview:aWebView];	
	
	acceptButton = [CTHelper getSmallGreenUIButtonWithTitle:@"Accept"];
            if (SD_IS_IOS6) {
                acceptButton.frame = CGRectMake(80, [[UIScreen mainScreen] bounds].size.height - acceptButton.frame.size.height - 30, 152, 43);
            } else {
                acceptButton.frame = CGRectMake(80, [[UIScreen mainScreen] bounds].size.height - acceptButton.frame.size.height - 10, 152, 43);
            }
	[acceptButton addTarget:self action:@selector(sendAcceptNotification:) forControlEvents:UIControlEventTouchUpInside];
	
	[[self view] addSubview:acceptButton];
	[self.view bringSubviewToFront:acceptButton];
} 

- (void) rejectPressed {
	[self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) dismissView {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
