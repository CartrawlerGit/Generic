//
//  FindBookingViewController.m
//  CarTrawler
//

#import "FindBookingViewController.h"
#import "CarTrawlerAppDelegate.h"
#import "Booking.h"

@interface FindBookingViewController (Private)

- (void) setUpWebView;

@end

@implementation FindBookingViewController

- (void)webViewDidStartLoad:(UIWebView *)wv {
    DLog (@"webViewDidStartLoad");
    [self.spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    DLog (@"webViewDidFinishLoad");
    [self.spinner stopAnimating];
	[self.spinner setHidden:YES];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    DLog (@"webView:didFailLoadWithError");
    [self.spinner stopAnimating];
    if (error != NULL) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle: [error localizedDescription]
								   message: [error localizedFailureReason]
								   delegate:nil
								   cancelButtonTitle:@"OK" 
								   otherButtonTitles:nil];
        [errorAlert show];
        //[errorAlert release];
    }
	[self.spinner setHidden:YES];
}

#pragma mark -
#pragma mark UIWebView PDF Loading

- (void) setUpWebView {
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 322, 418)];
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)([[UIApplication sharedApplication] delegate]);

	NSString *urlString = appDelegate.amendBookingsLink;
	urlString = [urlString stringByReplacingOccurrencesOfString:@"CT_RESID" withString:self.b.confID];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"CT_EMAIL" withString:self.b.customerEmail];
	NSURL *targetURL = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
	[webView loadRequest:request];
	
	[self.view addSubview:webView];
	//[webView release];
}

#pragma mark -
#pragma mark UIVC life cycle stuff

- (id) init {
    self=[super initWithNibName:@"FindBookingViewController" bundle:nil];
    return self;
}

- (id) initWithNibName:(NSString *)n bundle:(NSBundle *)b {
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setUpWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) dismissView {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
