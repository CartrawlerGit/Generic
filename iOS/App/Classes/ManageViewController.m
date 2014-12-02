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

@implementation ManageViewController

@synthesize n;
@synthesize storedBtn;
@synthesize downloadBtn;
@synthesize bookingEmailTB;
@synthesize bookingIDTB;
@synthesize getBookingView;
@synthesize noBookingsLabel;
@synthesize arrayOfBookings;
@synthesize scrollView;
@synthesize pageControl;
@synthesize numBookingsLabel;
@synthesize arrayOfReceiptViewControllers;

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

CTHudViewController *hud;

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
	
	hud = [[CTHudViewController alloc] initWithTitle:@"Searching"];
	[hud show];
	
	[request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *)request {
	NSString *responseString = [request responseString];
	
	if (kShowResponse) {
		DLog(@"Response is \n\n%@\n\n", responseString);
	}
	
	id response = [responseString JSONValue];
	
	[hud hide];
	//[hud autorelease];
	hud = nil;
	
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
				[arrayOfBookings addObject:b];
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
	
	[hud hide];
	//[hud autorelease];
	hud = nil;
	NSError *error = [request error];
	DLog(@"Error is %@", error);
}

- (IBAction) getBookingInfo {
	//DLog(@"Requesting %@ & %@", self.bookingIDTB.text, self.bookingEmailTB.text);
	
	//[self getBookingDetails:@"ahicks@cartrawler.com" bookingID:@"AU265413880"];
	//[self getBookingDetails:@"PEPSOLA@PEPSOLA.JAZZTEL.ES" bookingID:@"IE226600320"];
	
	if ([bookingIDTB.text isEqualToString:@""]) {
		[CTHelper showAlert:@"Reference number required." message:@"Your reference number is required to use this facility."];
	} else if ([bookingEmailTB.text isEqualToString:@""]){
		[CTHelper showAlert:@"Email address required." message:@"Your email address is required to use this facility."];
	} else if ([bookingEmailTB.text isEqualToString:@""] && [bookingIDTB.text isEqualToString:@""]) {
		[CTHelper showAlert:@"Information missing." message:@"Enter your reference number & email address to download your booking details."];
	} else if (!([bookingEmailTB.text isEqualToString:@""] && [bookingIDTB.text isEqualToString:@""])) {
		[self getBookingDetails:self.bookingEmailTB.text bookingID:self.bookingIDTB.text];
		
	//	[FlurryAPI logEvent:@"Manage Booking: Has retrieved booking from web."];
		
	}
}

- (IBAction) showGetBookingInfoView {
	[bookingIDTB setReturnKeyType:UIReturnKeyNext];
	[bookingEmailTB setReturnKeyType:UIReturnKeyGo];
	[bookingIDTB setText:@""];
	[bookingEmailTB setText:@""];
	
	[scrollView slideOutTo:2 duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
	[pageControl slideOutTo:2 duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
	[getBookingView slideInFrom:0 duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
	
	self.navigationItem.rightBarButtonItem = storedBtn;
	//self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (IBAction) hideGetBookingInfoView {
	[getBookingView slideOutTo:0 duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
	[scrollView slideInFrom:2 duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
	[pageControl slideInFrom:2 duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
	
	self.navigationItem.rightBarButtonItem = downloadBtn;
	
	//self.navigationItem.rightBarButtonItem.enabled = YES;
	[bookingIDTB resignFirstResponder];
	[bookingEmailTB resignFirstResponder];
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
	
	[arrayOfBookings removeAllObjects];
	
	// Check for bookings
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"Bookings"]) {
		
		NSDictionary *bookingsDictionary = [defaults objectForKey:@"Bookings"];
		for (id key in bookingsDictionary) {
			Booking *b = [self loadCustomObjectWithKey:key dictionary:[defaults objectForKey:@"Bookings"]];
			[arrayOfBookings addObject:b];
		}
	}
}

#pragma mark -
#pragma mark UIViewController Lifecycle

- (void) awakeFromNib {
	arrayOfBookings = [[NSMutableArray alloc] init];
	
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
	[getBookingView setHidden:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteReceipt:) name:@"deleteReceipt" object:nil];
	
	storedBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cabinetIcon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(hideGetBookingInfoView)];
	
	downloadBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"inboxIcon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showGetBookingInfoView)];
	self.navigationItem.rightBarButtonItem = downloadBtn;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
    /*
	[scrollView release];
	[pageControl release];
	[arrayOfBookings release];
	[arrayOfReceiptViewControllers release];
	[noBookingsLabel release];
	noBookingsLabel = nil;
	[getBookingView release];
	getBookingView = nil;
	[bookingEmailTB release];
	bookingEmailTB = nil;
	[bookingIDTB release];
	bookingIDTB = nil;
	[storedBtn release];
	storedBtn = nil;
	[downloadBtn release];
	downloadBtn = nil;
	[n release];
	n = nil;
    [super dealloc];
     */
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
	self.arrayOfReceiptViewControllers = [[NSMutableArray alloc] initWithCapacity:[arrayOfBookings count]];
	
	for (UIView *view in [scrollView subviews]) //remove all receipts from the view
	{
		[view removeFromSuperview];
	} 

	CGFloat cx = 0;
	for (Booking *b in arrayOfBookings) // add receipts to the view
	{
		ReceiptView *rv = [[ReceiptView alloc] init];
		rv.theBooking = b;
		
		CGRect rect = rv.view.frame;
		//rect.size.height = 320.0;
		rect.size.height = 290.0;
		rect.size.width = 320.0;
		rect.origin.x = ((scrollView.frame.size.width - 290.0) / 2) + cx;
		rect.origin.y = ((scrollView.frame.size.height - 290.0) / 2);
		
		rv.view.frame = rect;
		[scrollView addSubview:rv.view];
		[self.arrayOfReceiptViewControllers addObject:rv];
		//[rv release];
		cx += scrollView.frame.size.width;
		
	}
	self.pageControl.numberOfPages = [arrayOfBookings count];
	[scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
}

- (void) setupPage {
	scrollView.delegate = self;
	
	[self.scrollView setBackgroundColor:[UIColor clearColor]];
	[scrollView setCanCancelContentTouches:NO];
	
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	CGFloat cx = 0;
	
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	numBookingsLabel.text = [NSString stringWithFormat:@"Page %d of %ld saved bookings",page+1 ,(long)numBookings ];

	self.arrayOfReceiptViewControllers = [[NSMutableArray alloc] initWithCapacity:[arrayOfBookings count]];
	for (Booking *b in arrayOfBookings) 
	{
		ReceiptView *rv = [[ReceiptView alloc] init];
		rv.theBooking = b;

		CGRect rect = rv.view.frame;
		//rect.size.height = 320.0;
		rect.size.height = 290.0;
		rect.size.width = 320.0;
		rect.origin.x = ((scrollView.frame.size.width - 290.0) / 2) + cx;
		rect.origin.y = ((scrollView.frame.size.height - 320.0) / 2);
		
		rv.view.frame = rect;
		[scrollView addSubview:rv.view];
		[self.arrayOfReceiptViewControllers addObject:rv];
		//[rv release];
		cx += scrollView.frame.size.width;
		
	}

	self.pageControl.numberOfPages = [arrayOfBookings count];
	[scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
	
	if ([arrayOfBookings count] == 0) {
		[noBookingsLabel setHidden:NO];
	} else {
		[noBookingsLabel setHidden:YES];
	}

}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff

- (void) scrollViewDidScroll:(UIScrollView *)_scrollView {
    
	if (pageControlIsChangingPage) {
        return;
    }
	
	// We switch page at 50% across
	
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	numBookingsLabel.text = [NSString stringWithFormat:@"Page %d of %ld saved bookings",page+1 ,(long)numBookings ];
    pageControl.currentPage = page;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)_scrollView {
    pageControlIsChangingPage = NO;
}

#pragma mark -
#pragma mark PageControl stuff

- (IBAction) changePage:(id)sender {
	 
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
	
    [scrollView scrollRectToVisible:frame animated:YES];
    
	pageControlIsChangingPage = YES;
}

#pragma mark UITextView delegate

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	if (textField == bookingIDTB) {
		[bookingIDTB resignFirstResponder];
		[bookingEmailTB becomeFirstResponder];
	} else {
		[bookingEmailTB resignFirstResponder];
		[self getBookingInfo];
	}
	return YES;
}

@end
