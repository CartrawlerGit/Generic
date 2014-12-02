//
//  CTHudViewController.m
//  CarTrawler
//
//

#import "CTHudViewController.h"
#import <QuartzCore/QuartzCore.h>
#define kRoundedRectWidth 160.0
#define kRoundedRectHeight 160.0

#ifdef NSFoundationVersionNumber_iOS_6_1
#define SD_IS_IOS6 (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
#else
#define SD_IS_IOS6 YES
#endif

@implementation CTHudViewController
@synthesize alerttitle;

#pragma mark -
#pragma mark Initialization

- (id) initWithTitle:(NSString *)_t 
{
	self = [super init];
	if (self != nil) 
	{
		self.alerttitle = _t;
	}
	return self;
}

-(void)show 
{
	[self performSelectorInBackground:@selector(_show) withObject:nil];
}


-(void) resizeTitleLabel {
	[titleLabel sizeToFit];
	if (titleLabel.frame.size.width > roundRectView.frame.size.width) {
		CGRect frame = titleLabel.frame;
		frame.size.width = roundRectView.frame.size.width-10;
		frame.origin.x = roundRectView.frame.origin.x+5;
		titleLabel.frame = frame;
	}	
}

-(void)_show {
	
	
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UIWindow *w = [[UIApplication sharedApplication] keyWindow];
	
                if (SD_IS_IOS6) {
                        blankingView = [[UIView alloc] initWithFrame:self.view.frame];
                } else {
                        blankingView = [[UIView alloc] initWithFrame:w.bounds];
                }
	
	blankingView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
	blankingView.alpha = 0.0;
	
	roundRectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRoundedRectWidth, kRoundedRectHeight)];
	roundRectView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];

	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	spinner.center = CGPointMake(floor(roundRectView.center.x), floor(roundRectView.center.y));
	spinner.frame = CGRectMake(floor(spinner.frame.origin.x), floor(spinner.frame.origin.y), floor(spinner.frame.size.width), floor(spinner.frame.size.height));
	
	titleLabel = [[UILabel alloc] initWithFrame:blankingView.bounds];
	
	if(alerttitle == nil) {
		titleLabel.text = @"";
	} else {
		titleLabel.text = [NSString stringWithFormat:@"%@…", self.alerttitle];
	}
	
	titleLabel.opaque = NO;
	titleLabel.backgroundColor = nil;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
	titleLabel.adjustsFontSizeToFitWidth = YES;
	
	[self resizeTitleLabel];
	
	roundRectView.center = blankingView.center;
	roundRectView.layer.cornerRadius = 10.0;
	roundRectView.layer.borderWidth = 0.0;
	//roundRectView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.7].CGColor;
	
	[blankingView addSubview:roundRectView];
	
	titleLabel.center = CGPointMake(spinner.center.x, floor(spinner.center.y+spinner.frame.size.height));
	
	[roundRectView addSubview:titleLabel];
	[roundRectView addSubview:spinner];
	[roundRectView popIn:0.5f delegate:self];

	[spinner startAnimating];
	[spinner release];
	
	[w addSubview:blankingView];
	[blankingView release];
	
	roundRectView.transform = CGAffineTransformMakeScale(0.5, 0.5);
		
	[UIView beginAnimations:@"Blank" context:nil];
	blankingView.alpha = 1.0;
	roundRectView.transform = CGAffineTransformMakeScale(1.0, 1.0);

	[UIView commitAnimations];	
	//[pool release];
}

-(void)hide
{	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDidStopSelector:@selector(_hide)];
	blankingView.alpha = 0.0;
	[UIView commitAnimations];	
}

-(void)_hide
{
	[blankingView removeFromSuperview];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(void) setAlerttitle:(NSString *)_t {
	alerttitle = _t;
	titleLabel.text = [NSString stringWithFormat:@"%@…", self.alerttitle];
	[self resizeTitleLabel];
}
@end

