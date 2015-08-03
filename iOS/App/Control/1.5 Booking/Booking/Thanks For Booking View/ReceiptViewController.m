//
//  ReceiptViewController.m
//  CarTrawler
//
//

#import "ReceiptViewController.h"
#import "Booking.h"
#import "CarTrawlerAppDelegate.h"

@implementation ReceiptViewController

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
	
	[self.emailLabel setText:self.theBooking.customerEmail];
    
    if (self.theBooking.vendorBookingRef) {
        [self.refLabel setText:self.theBooking.vendorBookingRef];
    } else {
        [self.refLabel setText:self.theBooking.confID];
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


@end
