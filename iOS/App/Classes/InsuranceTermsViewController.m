//
//  InsuranceTermsViewController.m
//  CarTrawler
//
//

#import "InsuranceTermsViewController.h"
#import "InsuranceObject.h"

@interface InsuranceTermsViewController (Private)

- (void) setUpWebView;

@end

@implementation InsuranceTermsViewController

@synthesize spinner;
@synthesize ins;

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
	NSURL *targetURL = [NSURL URLWithString:ins.detailURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
	[webView loadRequest:request];
	
	[self.view addSubview:webView];
	//[webView release];
	
}

#pragma mark -
#pragma mark UIVC life cycle stuff

- (id) init {
    self=[super initWithNibName:@"InsuranceTermsViewController" bundle:nil];
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
/*
- (void)dealloc {
	[ins release];
	ins = nil;
	[spinner release];
	spinner = nil;
    [super dealloc];
}
*/
#pragma mark -
#pragma mark IBActions

- (IBAction) dismissView {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
