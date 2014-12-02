//
//  ReceiptViewController.m
//  CarTrawler
//
//

#import "ReceiptViewController.h"
#import "Booking.h"
#import "CarTrawlerAppDelegate.h"

@implementation ReceiptViewController

@synthesize refLabel;
@synthesize exitBtn;
@synthesize theBooking;
@synthesize emailLabel;

#pragma mark -
#pragma mark Exit button

- (IBAction)exitBtnPressed:(id)sender {
	[self.tabBarController setSelectedIndex:0];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Lifecycle stuff

- (id) init {
    self=[super initWithNibName:@"ReceiptViewController" bundle:nil];
    return self;
}

- (id) initWithNibName:(NSString *)n bundle:(NSBundle *)b {
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationController.navigationBar.tintColor = appDelegate.governingTintColor;
    
	self.title = @"Thank you";
	self.navigationItem.titleView = [CTHelper getNavBarLabelWithTitle:@"Thank you"];
	self.navigationItem.hidesBackButton = YES;
	
	[emailLabel setText:theBooking.customerEmail];
    
    if (theBooking.vendorBookingRef) {
        [refLabel setText:theBooking.vendorBookingRef];
    } else {
        [refLabel setText:theBooking.confID];
    }

	
	UIButton *homeButton = [CTHelper getGreenUIButtonWithTitle:@"Back to home"];
	[homeButton setFrame:CGRectMake(23, 268, 272, 46)];
	[homeButton addTarget:self action:@selector(exitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:homeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    /*
	[emailLabel release];
	emailLabel = nil;

	[theBooking release];
	theBooking = nil;

	[exitBtn release];
	exitBtn = nil;

	[refLabel release];
	refLabel = nil;

    [super dealloc];
    //self=nil;
     */
}


@end
