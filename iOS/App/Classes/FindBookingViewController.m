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

@synthesize b;
@synthesize spinner;

- (void)webViewDidStartLoad:(UIWebView *)wv {
    DLog (@"webViewDidStartLoad");
    [spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    DLog (@"webViewDidFinishLoad");
    [spinner stopAnimating];
	[spinner setHidden:YES];
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    DLog (@"webView:didFailLoadWithError");
    [spinner stopAnimating];
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
	[spinner setHidden:YES];
}

#pragma mark -
#pragma mark UIWebView PDF Loading

- (void) setUpWebView {
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 322, 418)];
	webView.delegate = self;
	webView.scalesPageToFit = YES;
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)([[UIApplication sharedApplication] delegate]);

	NSString *urlString = appDelegate.amendBookingsLink;
	urlString = [urlString stringByReplacingOccurrencesOfString:@"CT_RESID" withString:b.confID];
	urlString = [urlString stringByReplacingOccurrencesOfString:@"CT_EMAIL" withString:b.customerEmail];
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

- (void)dealloc {
	/*[spinner release];
	spinner = nil;
	[b release];
	b = nil;
    [super dealloc];*/
}

#pragma mark -
#pragma mark IBActions

- (IBAction) dismissView {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
