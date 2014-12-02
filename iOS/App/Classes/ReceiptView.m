//
//  ReceiptView.m
//  CarTrawler
//

#import "ReceiptView.h"
#import "Booking.h"
#import "CTTableViewAsyncImageView.h"
#import "Fee.h"
#import "CarTrawlerAppDelegate.h"
#import "ShowLocationViewController.h"
#import "FindBookingViewController.h"

@implementation ReceiptView

@synthesize amendBookingButton;
@synthesize amendBookingLabel;
@synthesize ammendBookingLabelUnderLine;
@synthesize selectedNumberToCall;
@synthesize callCustomerCareBtn;
@synthesize callDeskBtn;
@synthesize vendorNameLabel;
@synthesize vendorImage;
@synthesize carImage;
@synthesize vendorReferenceNumberLabel;
@synthesize ctReferenceNumberLabel;
@synthesize ctConfNumberLabel;
@synthesize pickupLocationNameLabel;
@synthesize pickUpLocationPhoneNumberLabel;
@synthesize puDateTimeLabel;
@synthesize doDateTimeLabel;
@synthesize customCarePhoneNumberLabel;
@synthesize carTypeLabel;
@synthesize totalPriceLabel;
@synthesize theBooking;

- (id) init {
    self=[super initWithNibName:@"ReceiptView" bundle:nil];
    return self;
}

- (id) initWithNibName:(NSString *)n bundle:(NSBundle *)b {
    return [self init];
}

- (NSString *) readableDate:(NSString *)oldDate {
	NSString *newDateStr = [oldDate substringWithRange:NSMakeRange(0, 10)];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];

	
	NSDate *date = [dateFormat dateFromString:newDateStr];
	[dateFormat setDateFormat:@"MMM d, yyyy"];
	return [dateFormat stringFromDate:date];
}

- (void) viewDidLoad {
	
	[super viewDidLoad];
	
	// Check the global controls 
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)([[UIApplication sharedApplication] delegate]);
	if (!appDelegate.canAmendBookings) {
		[self.amendBookingButton setHidden:YES];
		//[self.amendBookingLabel setHidden:YES];
		[self.ammendBookingLabelUnderLine setHidden:YES];
	}
	
	// The rest
	
    vendorNameLabel.numberOfLines = 0;
    if (theBooking.tpaConfID) {
        self.vendorReferenceNumberLabel.text = [NSString stringWithFormat:@"Confirmation: \n%@", theBooking.tpaConfID];
    } else {
        self.vendorReferenceNumberLabel.text = [NSString stringWithFormat:@"Reservation: \n%@", theBooking.confID];
    }
    if (theBooking.confID) {
        self.ctReferenceNumberLabel.text = [NSString stringWithFormat:@"(Reservation ID: %@)", theBooking.confID];
    } else {
        self.ctReferenceNumberLabel.text = @"";
    }
	

	self.vendorNameLabel.text = theBooking.vendorName;
	self.carTypeLabel.text = theBooking.vehMakeModelName;
	
	self.pickupLocationNameLabel.text = [NSString stringWithFormat:@"%@, %@", theBooking.locationName, theBooking.locationAddress];
	
	self.pickUpLocationPhoneNumberLabel.text = theBooking.locationPhoneNumber;
	self.customCarePhoneNumberLabel.text = theBooking.supportNumber;
	
	self.puDateTimeLabel.text = [NSString stringWithFormat:@"%@ to %@", [self readableDate:theBooking.puDateTime], [self readableDate:theBooking.doDateTime]];
	self.doDateTimeLabel.text = [self readableDate:theBooking.doDateTime];
	
	CTTableViewAsyncImageView *thisImage = [[CTTableViewAsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 57.0, 28.0)];
	thisImage.contentMode = UIViewContentModeScaleAspectFit;
	vendorImage.contentMode = UIViewContentModeScaleAspectFit;
	
	[vendorImage addSubview:thisImage];
	NSURL *url = [NSURL URLWithString:theBooking.vendorImageURL];
	[thisImage loadImageFromURL:url];
	
	CTTableViewAsyncImageView *carThumb = [[CTTableViewAsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 64.0, 40.0)];
	[carImage addSubview:carThumb];
	NSURL *thumbUrl = [NSURL URLWithString:theBooking.vehPictureUrl];
	[carThumb loadImageFromURL:thumbUrl];
	
	if (theBooking.wasRetrievedFromWebBOOL || [theBooking.wasRetrievedFromWeb isEqualToString:@"YES"]) {
		carThumb.hidden = YES;
	}
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) dealloc {
    /*
	[vendorImage release];
	vendorImage = nil;
	[carImage release];
	carImage = nil;
	[vendorReferenceNumberLabel release];
	vendorReferenceNumberLabel = nil;
	[ctReferenceNumberLabel release];
	ctReferenceNumberLabel = nil;
	[pickupLocationNameLabel release];
	pickupLocationNameLabel = nil;
	[pickUpLocationPhoneNumberLabel release];
	pickUpLocationPhoneNumberLabel = nil;
	[puDateTimeLabel release];
	puDateTimeLabel = nil;
	[doDateTimeLabel release];
	doDateTimeLabel = nil;
	[customCarePhoneNumberLabel release];
	customCarePhoneNumberLabel = nil;
	[carTypeLabel release];
	carTypeLabel = nil;
	[totalPriceLabel release];
	totalPriceLabel = nil;
	[vendorNameLabel release];
	vendorNameLabel = nil;
	[callDeskBtn release];
	callDeskBtn = nil;
	[callCustomerCareBtn release];
	callCustomerCareBtn = nil;
	[selectedNumberToCall release];
	selectedNumberToCall = nil;
	[amendBookingLabel release];
	amendBookingLabel = nil;
	[ammendBookingLabelUnderLine release];
	ammendBookingLabelUnderLine = nil;
	[amendBookingButton release];
	amendBookingButton = nil; 	    
     [super dealloc];*/

    
}

#pragma mark -
#pragma mark IBActions

- (IBAction) amendBookingButtonPressed {
	
//	[FlurryAPI logEvent:@"Manage Booking: Amending booking through in-app web portal."];
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)([[UIApplication sharedApplication] delegate]);
	FindBookingViewController *fbvc = [[FindBookingViewController alloc] init];
	[fbvc setB:theBooking];
	[appDelegate.tabBarController presentViewController:fbvc animated:YES completion:nil];
	//[fbvc release];
}

- (IBAction) deleteReceipt {
	
//	[FlurryAPI logEvent:@"Manage Booking: Deleted receipt from app."];
	
	NSDictionary *theBookingID;
	theBookingID = [NSDictionary dictionaryWithObject:theBooking.confID forKey:@"bookingID"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"deleteReceipt" object:self userInfo:theBookingID];
}

#pragma mark -
#pragma mark Call Phone Number

- (IBAction) callPhoneNumber {
	
	//[FlurryAPI logEvent:[NSString stringWithFormat:@"Manage Booking: Called support number %@", selectedNumberToCall]];
	
	NSString *number = [NSString stringWithFormat:@"tel://%@", self.selectedNumberToCall];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}

#pragma mark -
#pragma mark UIMessage Methods

- (IBAction) showLocationOnMap {
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)([[UIApplication sharedApplication] delegate]);
	
	ShowLocationViewController *slmvc = [[ShowLocationViewController alloc] init];
	
//	[FlurryAPI logEvent:@"Manage Booking: Show pickup location on map."];
	
	[slmvc setCoordString:theBooking.coordString];
	[appDelegate.tabBarController presentViewController:slmvc animated:YES completion:nil];
	
	//[slmvc release];
}

#pragma mark -
#pragma mark UIMessage Methods

CTHudViewController *hud;

- (void) emailAlert {

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation has been sent" message:[NSString stringWithFormat:@"Your booking confirmation has been sent to %@", theBooking.customerEmail] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alert show];
	//[alert release];
}

#pragma mark -
#pragma mark Cancel Booking API call

- (IBAction) requestEmail {
	hud = [[CTHudViewController alloc] initWithTitle:@"Emailing"];
	[hud show];
	
//	[FlurryAPI logEvent:@"Manage Booking: Requested email confirmation."];
	
	NSString *requestString = [CTRQBuilder CT_VehCancelRQ:theBooking.confID emailAddress:theBooking.customerEmail];
	
	ASIHTTPRequest *request = [CTHelper makeCancelBookingRequest:@"OTA_VehModifyRQ" tail:requestString];
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *)request {
	NSString *responseString = [request responseString];
	
	DLog(@"Response is \n\n%@\n\n", responseString);
	
	[self emailAlert];
	
	[hud hide];
	//[hud autorelease];
	hud = nil;
}

- (void) requestFailed:(ASIHTTPRequest *)request {
	[hud hide];
	//[hud autorelease];
	hud = nil;
	NSError *error = [request error];
	DLog(@"Error is %@", error);
}

#pragma mark -
#pragma mark UIActionSheet delegate Methods

- (IBAction)showActionSheet:(id)sender {
	//self.selectedNumberToCall = nil;
	NSString *number;
	if (sender == callDeskBtn) {
		number = theBooking.locationPhoneNumber;

        //  call first number if more
        if ([number rangeOfString:@","].location != NSNotFound) {
            number = [number substringToIndex:[number rangeOfString:@","].location];
        }
        
        //  if not international number
        if ([number rangeOfString:@"+"].location != 0 ) {
            CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
            NSMutableArray *preloadedCountryList = appDelegate.preloadedCountryList;
            
            for (CTCountry *c in preloadedCountryList) {
                if ([c.isoCountryCode isEqualToString:theBooking.locationCountryName]) {
                    
                    //  if dialing code not at the beginning of string
                    if  ([number rangeOfString:c.isoDialingCode].location != 0 ) {
                        //  number becomes +<countryDialingCode>-<number>
                        number = [NSString stringWithFormat:@"+%@-%@", c.isoDialingCode,
                                  number];
                    }
                }
            }
            
        }
        
	} else {
        if (theBooking.supportNumber) {
            number = theBooking.supportNumber;
            

            
        } else {

            number = [(CarTrawlerAppDelegate *) [[UIApplication sharedApplication] delegate] getSupportNumber];
            
        }
	}
    
    //  Replace all spaces in number with dashes
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
    
	self.selectedNumberToCall = number;
	
	NSString *titleWithNumber = [NSString stringWithFormat:@"You are about to leave this app to dial %@, would you like to continue?", number];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:titleWithNumber delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
	//[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[self callPhoneNumber];
    } else {
		DLog(@"hit %li", (long)buttonIndex);
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
		[self callPhoneNumber];
    } else {
		
	}
}


@end
