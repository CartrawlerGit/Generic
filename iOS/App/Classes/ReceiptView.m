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

@interface ReceiptView()

@property (nonatomic, strong) CTHudViewController *hud;

@end

@implementation ReceiptView

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
	
    self.vendorNameLabel.numberOfLines = 0;
    if (self.theBooking.tpaConfID) {
        self.vendorReferenceNumberLabel.text = [NSString stringWithFormat:@"Confirmation: \n%@", self.theBooking.tpaConfID];
    } else {
        self.vendorReferenceNumberLabel.text = [NSString stringWithFormat:@"Reservation: \n%@", self.theBooking.confID];
    }
    if (self.theBooking.confID) {
        self.ctReferenceNumberLabel.text = [NSString stringWithFormat:@"(Reservation ID: %@)", self.theBooking.confID];
    } else {
        self.ctReferenceNumberLabel.text = @"";
    }
	

	self.vendorNameLabel.text = self.theBooking.vendorName;
	self.carTypeLabel.text = self.theBooking.vehMakeModelName;
	
	self.pickupLocationNameLabel.text = [NSString stringWithFormat:@"%@, %@", self.theBooking.locationName, self.theBooking.locationAddress];
	
	self.pickUpLocationPhoneNumberLabel.text = self.theBooking.locationPhoneNumber;
	self.customCarePhoneNumberLabel.text = self.theBooking.supportNumber;
	
	self.puDateTimeLabel.text = [NSString stringWithFormat:@"%@ to %@", [self readableDate:self.theBooking.puDateTime], [self readableDate:self.theBooking.doDateTime]];
	self.doDateTimeLabel.text = [self readableDate:self.theBooking.doDateTime];
	
	CTTableViewAsyncImageView *thisImage = [[CTTableViewAsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 57.0, 28.0)];
	thisImage.contentMode = UIViewContentModeScaleAspectFit;
	self.vendorImage.contentMode = UIViewContentModeScaleAspectFit;
	
	[self.vendorImage addSubview:thisImage];
	NSURL *url = [NSURL URLWithString:self.theBooking.vendorImageURL];
	[thisImage loadImageFromURL:url];
	
	CTTableViewAsyncImageView *carThumb = [[CTTableViewAsyncImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 64.0, 40.0)];
	[self.carImage addSubview:carThumb];
	NSURL *thumbUrl = [NSURL URLWithString:self.theBooking.vehPictureUrl];
	[carThumb loadImageFromURL:thumbUrl];
	
	if (self.theBooking.wasRetrievedFromWebBOOL || [self.theBooking.wasRetrievedFromWeb isEqualToString:@"YES"]) {
		carThumb.hidden = YES;
	}
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) amendBookingButtonPressed {
	
//	[FlurryAPI logEvent:@"Manage Booking: Amending booking through in-app web portal."];
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)([[UIApplication sharedApplication] delegate]);
	FindBookingViewController *fbvc = [[FindBookingViewController alloc] init];
	[fbvc setB:self.theBooking];
	[appDelegate.tabBarController presentViewController:fbvc animated:YES completion:nil];
	//[fbvc release];
}

- (IBAction) deleteReceipt {
	
//	[FlurryAPI logEvent:@"Manage Booking: Deleted receipt from app."];
	
	NSDictionary *theBookingID;
	theBookingID = [NSDictionary dictionaryWithObject:self.theBooking.confID forKey:@"bookingID"];
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
	
	[slmvc setCoordString:self.theBooking.coordString];
	[appDelegate.tabBarController presentViewController:slmvc animated:YES completion:nil];
	
	//[slmvc release];
}

#pragma mark -
#pragma mark UIMessage Methods

- (void) emailAlert {

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation has been sent" message:[NSString stringWithFormat:@"Your booking confirmation has been sent to %@", self.theBooking.customerEmail] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alert show];
	//[alert release];
}

#pragma mark -
#pragma mark Cancel Booking API call

- (IBAction) requestEmail {
	self.hud = [[CTHudViewController alloc] initWithTitle:@"Emailing"];
	[self.hud show];
	
//	[FlurryAPI logEvent:@"Manage Booking: Requested email confirmation."];
	
	NSString *requestString = [CTRQBuilder CT_VehCancelRQ:self.theBooking.confID emailAddress:self.theBooking.customerEmail];
	
	ASIHTTPRequest *request = [CTHelper makeCancelBookingRequest:@"OTA_VehModifyRQ" tail:requestString];
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *)request {
	NSString *responseString = [request responseString];
	
	DLog(@"Response is \n\n%@\n\n", responseString);
	
	[self emailAlert];
	
	[self.hud hide];
	//[hud autorelease];
	self.hud = nil;
}

- (void) requestFailed:(ASIHTTPRequest *)request {
	[self.hud hide];
	//[hud autorelease];
	self.hud = nil;
	NSError *error = [request error];
	DLog(@"Error is %@", error);
}

#pragma mark -
#pragma mark UIActionSheet delegate Methods

- (IBAction)showActionSheet:(id)sender {
	//self.selectedNumberToCall = nil;
	NSString *number;
	if (sender == self.callDeskBtn) {
		number = self.theBooking.locationPhoneNumber;

        //  call first number if more
        if ([number rangeOfString:@","].location != NSNotFound) {
            number = [number substringToIndex:[number rangeOfString:@","].location];
        }
        
        //  if not international number
        if ([number rangeOfString:@"+"].location != 0 ) {
            CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
            NSMutableArray *preloadedCountryList = appDelegate.preloadedCountryList;
            
            for (CTCountry *c in preloadedCountryList) {
                if ([c.isoCountryCode isEqualToString:self.theBooking.locationCountryName]) {
                    
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
        if (self.theBooking.supportNumber) {
            number = self.theBooking.supportNumber;
            

            
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
