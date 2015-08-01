//
//  ManageViewController.m
//  CarTrawler
//

#import "ManageViewController.h"
#import "Booking.h"
#import "ReceiptView.h"
#import "CarTrawlerAppDelegate.h"
#import "CTHudViewController.h"
#import "FindBookingViewController.h"

@interface ManageViewController()

@property (nonatomic, strong) CTHudViewController *hud;
@property (nonatomic, assign) NSInteger		numBookings;
@property (nonatomic, assign) BOOL pageControlIsChangingPage;

@end

@implementation ManageViewController

#pragma mark -
#pragma mark CT API Calls

- (void) saveCustomObject:(Booking *)obj {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([[[defaults dictionaryRepresentation] allKeys] containsObject:@"Bookings"]) 
	{
		NSMutableDictionary *allBookings = [[defaults objectForKey:@"Bookings"] mutableCopy];
		NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
		[allBookings setObject:myEncodedObject forKey:obj.confID];
		[defaults setObject:[allBookings copy] forKey:@"Bookings"];
	} 
	else 
	{
		NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];	
		NSDictionary *bookingDict = [NSDictionary dictionaryWithObject:myEncodedObject forKey:obj.confID];
		[defaults setObject:bookingDict forKey:@"Bookings"];
	}
	[defaults synchronize];
}

- (void) getBookingDetails:(NSString *)bookingEmail bookingID:(NSString *)bookingID {
	
	NSString *jsonString = [NSString stringWithFormat:@"{%@%@}", [CTRQBuilder buildHeader:kGetExistingBookingHeader], [CTRQBuilder OTA_VehRetResRQ:bookingEmail bookingRefID:bookingID]];
	
	if (kShowResponse) {
		DLog(@"Request is \n\n%@\n\n", jsonString);
	}
	
	NSData *requestData = [NSData dataWithBytes: [jsonString UTF8String] length: [jsonString length]];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kCTTestAPI, KOTA_VehRetResRQ]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request appendPostData:requestData];
	[request setRequestMethod:@"POST"];
	[request setShouldStreamPostDataFromDisk:YES];
	[request setAllowCompressedResponse:YES];
	
	self.hud = [[CTHudViewController alloc] initWithTitle:@"Searching"];
	[self.hud show];
	
	[request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *)request {
	NSString *responseString = [request responseString];
	
	if (kShowResponse) {
		DLog(@"Response is \n\n%@\n\n", responseString);
	}
	
	id response = [responseString JSONValue];
	
	[self.hud hide];
	//[hud autorelease];
	self.hud = nil;
	
	if ([[CTHelper validateResponse:response] isKindOfClass:[NSMutableArray class]]) {
		// We have errors
		NSMutableArray *temp = (NSMutableArray *)[CTHelper validateResponse:response];
		for (CTError *er in temp) 
		{
			if ([er.errorShortTxt isEqualToString:@"No matching bookings found"]) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No matching bookings found" message:@"Check your Booking ID and Email Address and try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
				[alert show];
				//[alert release];
			} else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:er.errorShortTxt delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
				[alert show];
				//[alert release];
			}
		}
	} else {
		if ([[[response objectForKey:@"VehRetResRSCore"] objectForKey:@"VehReservation"] objectForKey:@"@Status"]) {
			NSString *statusStr = [[[response objectForKey:@"VehRetResRSCore"] objectForKey:@"VehReservation"] objectForKey:@"@Status"];
				
			if ([statusStr isEqualToString:@"Confirmed"]) {
				Booking *b = [[Booking alloc] initFromRetrievedBookingDictionary:[[response objectForKey:@"VehRetResRSCore"] objectForKey:@"VehReservation"]];
				[b setCustomerEmail:self.bookingEmailTB.text];
				[self saveCustomObject:b];
				[self.arrayOfBookings addObject:b];
				DLog(@"Break");
				[self setupPage];
				[self hideGetBookingInfoView];
			} else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your booking has either been cancelled or is currently unconfirmed." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
				[alert show];
				//[alert release];
			}
		}
		
	}
}

- (void) requestFailed:(ASIHTTPRequest *)request {
	
	if (kShowResponse) {
		DLog(@"Response is %@", [request responseString]);
	}
	
	[self.hud hide];
	//[hud autorelease];
	self.hud = nil;
	NSError *error = [request error];
	DLog(@"Error is %@", error);
}

- (IBAction) getBookingInfo {
	//DLog(@"Requesting %@ & %@", self.self.bookingIDTB.text, self.bookingEmailTB.text);
	
	//[self getBookingDetails:@"ahicks@cartrawler.com" bookingID:@"AU265413880"];
	//[self getBookingDetails:@"PEPSOLA@PEPSOLA.JAZZTEL.ES" bookingID:@"IE226600320"];
	
	if ([self.bookingIDTB.text isEqualToString:@""]) {
		[CTHelper showAlert:@"Reference number required." message:@"Your reference number is required to use this facility."];
	} else if ([self.bookingEmailTB.text isEqualToString:@""]){
		[CTHelper showAlert:@"Email address required." message:@"Your email address is required to use this facility."];
	} else if ([self.bookingEmailTB.text isEqualToString:@""] && [self.bookingIDTB.text isEqualToString:@""]) {
		[CTHelper showAlert:@"Information missing." message:@"Enter your reference number & email address to download your booking details."];
	} else if (!([self.bookingEmailTB.text isEqualToString:@""] && [self.bookingIDTB.text isEqualToString:@""])) {
		[self getBookingDetails:self.bookingEmailTB.text bookingID:self.bookingIDTB.text];
		
	//	[FlurryAPI logEvent:@"Manage Booking: Has retrieved booking from web."];
		
	}
}

- (IBAction) showGetBookingInfoView {
	[self.bookingIDTB setReturnKeyType:UIReturnKeyNext];
	[self.bookingEmailTB setReturnKeyType:UIReturnKeyGo];
	[self.bookingIDTB setText:@""];
	[self.bookingEmailTB setText:@""];
	
	[self.scrollView slideOutTo:2 duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
	[self.pageControl slideOutTo:2 duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
	[self.getBookingView slideInFrom:0 duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
	
	self.navigationItem.rightBarButtonItem = self.storedBtn;
	//self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (IBAction) hideGetBookingInfoView {
	[self.getBookingView slideOutTo:0 duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
	[self.scrollView slideInFrom:2 duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
	[self.pageControl slideInFrom:2 duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
	
	self.navigationItem.rightBarButtonItem = self.downloadBtn;
	
	//self.navigationItem.rightBarButtonItem.enabled = YES;
	[self.bookingIDTB resignFirstResponder];
	[self.bookingEmailTB resignFirstResponder];
}

#pragma mark -
#pragma mark Search Button Actions

- (IBAction) searchButtonPressed {
	FindBookingViewController *fbvc = [[FindBookingViewController alloc] init];
	[self.navigationController presentViewController:fbvc animated:YES completion:nil];
	//[fbvc release];
}

#pragma mark -
#pragma mark Delete Receipts

- (void) actuallyDeleteReceipt:(NSNotification *)notify {
	NSDictionary *theBookingID = [notify userInfo];
	
	NSString * bookingID = [[theBookingID objectForKey:@"bookingID"] mutableCopy];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([[[defaults dictionaryRepresentation] allKeys] containsObject:@"Bookings"]) 
	{
		NSMutableDictionary *allBookings = [[defaults objectForKey:@"Bookings"] mutableCopy];
		[allBookings removeObjectForKey:bookingID];
		[defaults setObject:[allBookings copy] forKey:@"Bookings"];
		[defaults synchronize];
	} 
	
	[self checkForBookings];
	[self setupPage ];
	[self resetArrayofReceiptViewControllers];
}

- (void) deleteReceipt:(NSNotification *)notify {
	self.n = notify;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Remove receipt?" message:@"You are about to remove this receipt from the app, receipts can be added using the download button at the top right of the screen." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
	//[alert release];
}

#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		// No (Cancel)
	} else {
		// Yes (Delete booking)
		[self actuallyDeleteReceipt:self.n];
	}
}

#pragma mark -
#pragma mark Check for Bookings

- (void) checkForBookings {
	
	// Flush the array first
	
	[self.arrayOfBookings removeAllObjects];
	
	// Check for bookings
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"Bookings"]) {
		
		NSDictionary *bookingsDictionary = [defaults objectForKey:@"Bookings"];
		for (id key in bookingsDictionary) {
			Booking *b = [self loadCustomObjectWithKey:key dictionary:[defaults objectForKey:@"Bookings"]];
			[self.arrayOfBookings addObject:b];
		}
	}
}

#pragma mark -
#pragma mark UIViewController Lifecycle

- (void) awakeFromNib {
	self.arrayOfBookings = [[NSMutableArray alloc] init];
	
	[self checkForBookings];
}

- (void) viewDidUnload {
	self.arrayOfBookings = nil;
	self.scrollView = nil;
	self.pageControl = nil;
	[super viewDidUnload];
}

- (void) viewDidLoad {
    [super viewDidLoad];
	self.title = @"My Bookings";
    
    CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationController.navigationBar.tintColor = appDelegate.governingTintColor;
    
	self.navigationItem.titleView = [CTHelper getNavBarLabelWithTitle:@"My Bookings"];
	[self.getBookingView setHidden:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteReceipt:) name:@"deleteReceipt" object:nil];
	
	self.storedBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cabinetIcon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(hideGetBookingInfoView)];
	
	self.downloadBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"inboxIcon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showGetBookingInfoView)];
	self.navigationItem.rightBarButtonItem = self.downloadBtn;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
	[self checkForBookings];
	[self setupPage];
}

#pragma mark -
#pragma mark Loading Bookings

- (Booking *) loadCustomObjectWithKey:(NSString *)key dictionary:(NSDictionary *)bookings {
    Booking *b;
	
	NSData *myEncodedObject = [bookings objectForKey: key];
	b = (Booking *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	
	return b;
}

#pragma mark -
#pragma mark The Guts

- (void) resetArrayofReceiptViewControllers {

	//[self.arrayOfReceiptViewControllers release];
	self.arrayOfReceiptViewControllers = [[NSMutableArray alloc] initWithCapacity:[self.arrayOfBookings count]];
	
	for (UIView *view in [self.scrollView subviews]) //remove all receipts from the view
	{
		[view removeFromSuperview];
	} 

	CGFloat cx = 0;
	for (Booking *b in self.arrayOfBookings) // add receipts to the view
	{
		ReceiptView *rv = [[ReceiptView alloc] init];
		rv.theBooking = b;
		
		CGRect rect = rv.view.frame;
		//rect.size.height = 320.0;
		rect.size.height = 290.0;
		rect.size.width = 320.0;
		rect.origin.x = ((self.scrollView.frame.size.width - 290.0) / 2) + cx;
		rect.origin.y = ((self.scrollView.frame.size.height - 290.0) / 2);
		
		rv.view.frame = rect;
		[self.scrollView addSubview:rv.view];
		[self.arrayOfReceiptViewControllers addObject:rv];
		//[rv release];
		cx += self.scrollView.frame.size.width;
		
	}
	self.pageControl.numberOfPages = [self.arrayOfBookings count];
	[self.scrollView setContentSize:CGSizeMake(cx, [self.scrollView bounds].size.height)];
}

- (void) setupPage {
	self.scrollView.delegate = self;
	
	[self.scrollView setBackgroundColor:[UIColor clearColor]];
	[self.scrollView setCanCancelContentTouches:NO];
	
	self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.clipsToBounds = YES;
	self.scrollView.scrollEnabled = YES;
	self.scrollView.pagingEnabled = YES;
	CGFloat cx = 0;
	
	CGFloat pageWidth = self.scrollView.frame.size.width;
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	self.numBookingsLabel.text = [NSString stringWithFormat:@"Page %d of %ld saved bookings",page+1 ,(long)self.numBookings ];

	self.arrayOfReceiptViewControllers = [[NSMutableArray alloc] initWithCapacity:[self.arrayOfBookings count]];
	for (Booking *b in self.arrayOfBookings) 
	{
		ReceiptView *rv = [[ReceiptView alloc] init];
		rv.theBooking = b;

		CGRect rect = rv.view.frame;
		//rect.size.height = 320.0;
		rect.size.height = 290.0;
		rect.size.width = 320.0;
		rect.origin.x = ((self.scrollView.frame.size.width - 290.0) / 2) + cx;
		rect.origin.y = ((self.scrollView.frame.size.height - 320.0) / 2);
		
		rv.view.frame = rect;
		[self.scrollView addSubview:rv.view];
		[self.arrayOfReceiptViewControllers addObject:rv];
		//[rv release];
		cx += self.scrollView.frame.size.width;
		
	}

	self.pageControl.numberOfPages = [self.arrayOfBookings count];
	[self.scrollView setContentSize:CGSizeMake(cx, [self.scrollView bounds].size.height)];
	
	if ([self.arrayOfBookings count] == 0) {
		[self.noBookingsLabel setHidden:NO];
	} else {
		[self.noBookingsLabel setHidden:YES];
	}

}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
	if (self.pageControlIsChangingPage) {
        return;
    }
	
	// We switch page at 50% across
	
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.numBookingsLabel.text = [NSString stringWithFormat:@"Page %d of %ld saved bookings",page+1 ,(long)self.numBookings ];
    self.pageControl.currentPage = page;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlIsChangingPage = NO;
}

#pragma mark -
#pragma mark PageControl stuff

- (IBAction) changePage:(id)sender {
	 
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
	
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
	self.pageControlIsChangingPage = YES;
}

#pragma mark UITextView delegate

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	if (textField == self.bookingIDTB) {
		[self.bookingIDTB resignFirstResponder];
		[self.bookingEmailTB becomeFirstResponder];
	} else {
		[self.bookingEmailTB resignFirstResponder];
		[self getBookingInfo];
	}
	return YES;
}

@end
