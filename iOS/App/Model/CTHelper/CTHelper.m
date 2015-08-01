//
//  CTHelper.m
//  CarTrawler
//
//

#import "CarTrawlerAppDelegate.h"
#import "CTHelper.h"
#import "CTLocation.h"
#import "CTCountry.h"
#import "CTCurrency.h"
#import "VehAvailRSCore.h"
#import "Booking.h"
#import "Fee.h"
#import "termsAndConditions.h"
#import "RentalSession.h"
#import "Car.h"
#import "Fee.h"
#import "InsuranceObject.h"

@implementation CTHelper

#pragma mark -
#pragma mark UIAlertView

+ (void) showAlert:(NSString *)_t message:(NSString *)_m {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_t message:_m delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alert show];
}

#pragma mark -
#pragma mark Getters and Converters

+ (NSString *) getCurrencySymbolFromString:(NSString *)currency {
	if ([currency isEqualToString:@"EUR"]) {
		return @"EUR";
		//return @"€";
	} else if ([currency isEqualToString:@"USD"]) {
		return @"USD";
		//return @"$";
	} else if ([currency isEqualToString:@"GBP"]) {
		return @"GBP";
		//return @"£";
	} else {
		return currency;
	}
}

+ (NSNumber *) convertStringToNumber:(NSString *)s {
	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	
	NSNumber *myNumber = [f numberFromString:s];
	
	return myNumber;
}

+ (NSNumber *) convertFeeFromStringToNumber:(Fee *)fee {
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterCurrencyStyle];
    [f setLocale:locale];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	
    //NSLog(@"fee.feeAmount = %@" , fee.feeAmount);

    NSNumber * myNumber = [f numberFromString:fee.feeAmount];
	
    //NSLog(@"myNumber = %@" , myNumber);
	return myNumber;
}

+ (NSString *) getVehcileCategoryStringFromNumber:(NSString *)vehCatStr {
	if ([vehCatStr isEqualToString:@"1"]) {
		return @"Mini";	
	} else if ([vehCatStr isEqualToString:@"2"]) {
		return @"Subcompact";
	} else if ([vehCatStr isEqualToString:@"3"]) {
		return @"Economy";
	} else if ([vehCatStr isEqualToString:@"4"]) {
		return @"Compact";
	} else if ([vehCatStr isEqualToString:@"5"]) {
		return @"Midsize";
	} else if ([vehCatStr isEqualToString:@"6"]) {
		return @"Intermediate";
	} else if ([vehCatStr isEqualToString:@"7"]) {
		return @"Standard";
	} else if ([vehCatStr isEqualToString:@"8"]) {
		return @"Fullsize";
	} else if ([vehCatStr isEqualToString:@"9"]) {
		return @"Luxury";
	} else if ([vehCatStr isEqualToString:@"10"]) {
		return @"Premium";
	} else if ([vehCatStr isEqualToString:@"11"]) {
		return @"Minivan";
	} else if ([vehCatStr isEqualToString:@"12"]) {
		return @"12 Passenger Van";
	} else if ([vehCatStr isEqualToString:@"13"]) {
		return @"Moving Van";
	} else if ([vehCatStr isEqualToString:@"14"]) {
		return @"15 Passenger Van";
	} else if ([vehCatStr isEqualToString:@"15"]) {
		return @"Cargo Van";
	} else if ([vehCatStr isEqualToString:@"16"]) {
		return @"12 Foot Truck";
	} else if ([vehCatStr isEqualToString:@"17"]) {
		return @"20 Foot Truck";
	} else if ([vehCatStr isEqualToString:@"18"]) {
		return @"24 Foot Truck";
	} else if ([vehCatStr isEqualToString:@"19"]) {
		return @"26 Foot Truck";
	} else if ([vehCatStr isEqualToString:@"20"]) {
		return @"Moped";
	} else if ([vehCatStr isEqualToString:@"21"]) {
		return @"Stretch";
	} else if ([vehCatStr isEqualToString:@"22"]) {
		return @"Regular";
	} else if ([vehCatStr isEqualToString:@"23"]) {
		return @"Unique";
	} else if ([vehCatStr isEqualToString:@"24"]) {
		return @"Exotic";
	} else if ([vehCatStr isEqualToString:@"25"]) {
		return @"Small/Medium Truck";
	} else if ([vehCatStr isEqualToString:@"26"]) {
		return @"Large Truck";
	} else if ([vehCatStr isEqualToString:@"27"]) {
		return @"Small SUV";
	} else if ([vehCatStr isEqualToString:@"28"]) {
		return @"Medium SUV";
	} else if ([vehCatStr isEqualToString:@"29"]) {
		return @"Large SUV";
	} else if ([vehCatStr isEqualToString:@"30"]) {
		return @"Exotic SUV";
	} else if ([vehCatStr isEqualToString:@"31"]) {
		return @"Four Wheel Drive";
	} else if ([vehCatStr isEqualToString:@"32"]) {
		return @"Special";
	} else if ([vehCatStr isEqualToString:@"33"]) {
		return @"Mini Elite";
	} else if ([vehCatStr isEqualToString:@"34"]) {
		return @"Economy Elite";
	} else if ([vehCatStr isEqualToString:@"35"]) {
		return @"Compact Elite";
	} else if ([vehCatStr isEqualToString:@"36"]) {
		return @"Intermediate Elite";
	} else if ([vehCatStr isEqualToString:@"37"]) {
		return @"Standard Elite";
	} else if ([vehCatStr isEqualToString:@"38"]) {
		return @"Fullsize Elite";
	} else if ([vehCatStr isEqualToString:@"39"]) {
		return @"Premium Elite";
	} else if ([vehCatStr isEqualToString:@"40"]) {
		return @"Luxury Elite";
	} else if ([vehCatStr isEqualToString:@"41"]) {
		return @"Oversize";
	} else {
		return @"Unknown";
	}
}

+ (NSString *) assetPath: (NSString *)asset {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:asset];
	return path;
}

#pragma mark -
#pragma mark ASI Request Builder

+ (ASIHTTPRequest *) makeRequestWithoutBuiltInHeader:(NSString *)rqCommand tail:(NSString *)rqTail {
	
	NSString *jsonString = [NSString stringWithFormat:@"%@", rqTail];
	
	// DLog(@"JSON RQ is \n\n%@\n\n", jsonString);
	
	NSData *requestData = [NSData dataWithBytes: [jsonString UTF8String] length: [jsonString length]];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kCTTestAPI, rqCommand]];
	
	// DLog(@"URL is %@", url);
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request appendPostData:requestData];
	[request setRequestMethod:@"POST"];
	[request setShouldStreamPostDataFromDisk:YES];
	[request setAllowCompressedResponse:YES];
	return request;
}

+ (ASIHTTPRequest *) makeRequest:(NSString *)rqCommand withSpecificHeader:(NSString *)header tail:(NSString *)rqTail {
	NSString *jsonString = [NSString stringWithFormat:@"{%@%@}", header, rqTail];

    BOOL isSecure = [rqCommand isEqual:@"OTA_VehResRQ" ];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", isSecure ? kCTTestAPISecure : kCTTestAPI, rqCommand]];
	
	NSData *requestData = [NSData dataWithBytes: [jsonString UTF8String] length: [jsonString length]];
	
	if (kShowResponse) {
		DLog(@"URL is %@", url);
		DLog(@"JSON RQ is \n\n%@\n\n", jsonString);
	}
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request appendPostData:requestData];
	[request setRequestMethod:@"POST"];
	[request setShouldStreamPostDataFromDisk:YES];
	[request setAllowCompressedResponse:YES];
	return request;
}

+ (ASIHTTPRequest *) makeRequest:(NSString *)rqCommand tail:(NSString *)rqTail {
	
	// The currency is being set here, so we have to deviate from the kMobileHeader.
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)([[UIApplication sharedApplication] delegate]);
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	CTCountry *ctCountry = [[CTCountry alloc] init];
	ctCountry.isoCountryName = [prefs objectForKey:@"ctCountry.isoCountryName"];
	ctCountry.isoCountryCode = [prefs objectForKey:@"ctCountry.isoCountryCode"];
	ctCountry.isoDialingCode = [prefs objectForKey:@"ctCountry.isoDialingCode"];
	
	ctCountry.currencyCode = [prefs objectForKey:@"ctCountry.currencyCode"];
	// The code here is the most important, the symbol is only for display.
	ctCountry.currencySymbol = [prefs objectForKey:@"ctCountry.currencySymbol"];
	
	if (ctCountry.isoCountryName == nil){
		ctCountry.isoCountryName = [CTHelper getLocaleDisplayName];
		ctCountry.isoCountryCode = [CTHelper getLocaleCode];
	}
	
	if (ctCountry.currencyCode == nil) {
		ctCountry.currencyCode = [CTHelper getLocaleCurrencyCode];
		ctCountry.currencySymbol = [CTHelper getLocaleCurrencySymbol];
	}
	// Header string takes a specific currency with this line.
	
	NSString *headerString = [NSString stringWithFormat:@"\"@xmlns\":\"http://www.opentravel.org/OTA/2003/05\",\"@xmlns:xsi\": \"http://www.w3.org/2001/XMLSchema-instance\",\"@Version\": \"1.005\",\"@Target\": \"%@\",\"POS\": {\"Source\": {\"@ERSP_UserID\": \"MO\",\"@ISOCurrency\":\"%@\",\"RequestorID\": {\"@Type\": \"16\",\"@ID\": \"%@\",\"@ID_Context\": \"CARTRAWLER\"}}},", kTarget, ctCountry.currencyCode, appDelegate.clientID];
	//return [CTHelper makeRequest:rqCommand withSpecificHeader:kMobileHeader tail:rqTail];
	
	return [CTHelper makeRequest:rqCommand withSpecificHeader:headerString tail:rqTail];
}

+ (ASIHTTPRequest *) makeCancelBookingRequest:(NSString *)rqCommand tail:(NSString *)rqTail {
	return [CTHelper makeRequest:rqCommand withSpecificHeader:[CTRQBuilder buildHeader:kCancelHeader] tail:rqTail];
}

#pragma mark Request Validators

+ (id) validatePredictiveLocationsResponse:(NSDictionary *) response {
	
	if ([[[response objectForKey:@"VehMatchedLocs"] objectForKey:@"LocationDetail"] isKindOfClass:[NSArray class]]) {
		if ([[[response objectForKey:@"VehMatchedLocs"] objectForKey:@"LocationDetail"] count] == 0) {
			[self showAlert:@"No Results Found" message:@"No Results have been found for this area, please try again."];
			return nil;
		} else {
			return [self predictiveLocations:[[response objectForKey:@"VehMatchedLocs"] objectForKey:@"LocationDetail"]];
		}
	} else if ([response objectForKey:@"Errors"]) {
		return nil;
	} else {
		
		NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:1];
		CTLocation *loc = [[CTLocation alloc] initShortLocationFromDictionary:[[response objectForKey:@"VehMatchedLocs"] objectForKey:@"LocationDetail"]];

		[locations addObject:loc];
		return locations;
	}
}

+ (id) validateResponse:(NSDictionary *)response {
	
	if ([[response allKeys] containsObject:@"VehMatchedLocs"]) 
	{
		DLog(@"VehMatchedLocsRS.");
		if ([[response objectForKey:@"VehMatchedLocs"] isKindOfClass:[NSArray class]]) 
		{
			
			// Need to check for arrays of zero length, some lat/long configurations can produce this
			
			if ([[response objectForKey:@"VehMatchedLocs"] count] == 0) 
			{
				[self showAlert:@"No Results Found" message:@"No Results have been found for this area, please try again."];
				return nil;
			} 
			else 
			{
				return [self vehMatchedLocs:[response objectForKey:@"VehMatchedLocs"]];
			}
		} 
		else 
		{
			NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:1];
			CTLocation *loc = [[CTLocation alloc] initFromDictionary:[[response objectForKey:@"VehMatchedLocs"] objectForKey:@"VehMatchedLoc"]];
			[locations addObject:loc];
			return locations;
		}
		
	}
	else if ([[response allKeys] containsObject:@"LocationDetail"]) 
		
	{
		DLog(@"VehLocDetailRS.");
		return nil;
	}
	else if ([[response allKeys] containsObject:@"VehAvailRSCore"]) 
	{
		if (kShowResponse) {
			DLog(@"VehAvailRSCore \n\n%@\n\n", [response JSONRepresentation]);
		}
		
		return [self vehAvailRSCore:[response objectForKey:@"VehAvailRSCore"]];
		
	}
	else if ([[response allKeys] containsObject:@"Errors"]) 
	{
		DLog(@"Have Error!");
		
		NSMutableArray *actualErrors = [[NSMutableArray alloc] init];
		
		if ([[response objectForKey:@"Errors"] isKindOfClass:[NSArray class]]) 
		{
			DLog(@"There is more than one error");
			NSArray *errors = (NSArray *)[response objectForKey:@"Errors"];
			
			for (NSDictionary *dict in errors) 
			{
				[actualErrors addObject:[self errorResponse:[dict objectForKey:@"Error"]]];
			}
			
			return actualErrors;
			
		} 
		else 
		{
			DLog(@"There is only one error");
			[actualErrors addObject:[self errorResponse:[[response objectForKey:@"Errors"] objectForKey:@"Error"]]];
			return actualErrors;
		}
	
	}
	else if ([[response allKeys] containsObject:@"VehResRSCore"]) 
	{
		if (kShowResponse) {
			DLog(@"\n\n\nBooking response is:\n%@\n\n\n", [response JSONRepresentation]);
		}
		
		return [self vehResRSCore:[[response objectForKey:@"VehResRSCore"] objectForKey:@"VehReservation"]];
	}
	else if ([[response allKeys] containsObject:@"RentalConditions"]) {
		
		if ([[response objectForKey:@"RentalConditions"] isKindOfClass:[NSArray class]]) {		
			
			if ([[response objectForKey:@"RentalConditions"] count] == 0) {
				return nil;
			} 
			else {	
				return [self rentalTermsAndConditions:[response objectForKey:@"RentalConditions"]];
			}
		} 	
	}
	else if ([[response allKeys] containsObject:@"VehRetResRSCore"]) {
		if (kShowResponse) {
			DLog(@"\n\n\nBooking response is:\n%@\n\n\n", [response JSONRepresentation]);
		}
		
		return [[response objectForKey:@"VehRetResRSCore"] objectForKey:@"VehReservation"];
		//return [self retrievedVehResRSCore:[[response objectForKey:@"VehRetResRSCore"] objectForKey:@"VehReservation"]];
	}
	else 
	{
		if (kShowResponse) {
			DLog(@"NEW RESPONSE. IT was %@", response);
		}
		
		NSMutableArray *array = [[NSMutableArray alloc] init];
		return array;
	}
	
	return nil;
}

#pragma mark -
#pragma mark Responders

+ (Booking *) retrievedVehResRSCore:(NSDictionary *)info {
	Booking *b = [[Booking alloc] initFromRetrievedBookingDictionary:info];
	return b;
}

+ (Booking *) vehResRSCore:(NSDictionary *)info {
	Booking *b = [[Booking alloc] initFromVehReservationDictionary:info];
	return b;
}

+ (CTError *) errorResponse:(NSDictionary *)err {
	CTError *error = [[CTError alloc] initFromErrorRS:err];
	return error;
}

+ (VehAvailRSCore *) vehAvailRSCore:(NSDictionary *) info {
	
	VehAvailRSCore *result = [[VehAvailRSCore alloc] initFromVehAvailRSCoreDictionary:info];
	
	return result;
}

+ (NSMutableArray *) rentalTermsAndConditions:(NSDictionary *) theTermsAndConditions {
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	for (NSDictionary *aDict in theTermsAndConditions)  
	{
		termsAndConditions *tAndQ = [[termsAndConditions alloc] initFromDictionary:aDict];
		[array addObject:tAndQ];
	}
	return array;	
}

+ (NSMutableArray *) vehMatchedLocs:(NSDictionary *) locations {

	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	for (NSDictionary *aDict in locations)  
	{
		CTLocation *loc = [[CTLocation alloc] initFromDictionary:aDict];
		[array addObject:loc];
	}
	return array;	
}

+ (NSMutableArray *) predictiveLocations:(NSDictionary *) locations {
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	for (NSDictionary *aDict in locations)  {
		CTLocation *loc = [[CTLocation alloc] initShortLocationFromDictionary:aDict];
		[array addObject:loc];
	}
	return array;	
}

#pragma mark -
#pragma mark locale detection

+ (NSString *) getCurrencyNameForCode:(NSString *)isoCurrencyCode {
	NSString *currency;
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	for (CTCurrency *c in appDelegate.preloadedCurrencyList) {
		if ([c.currencyCode isEqualToString:isoCurrencyCode]) {
			currency = c.currencyName;
			return currency;
		} else {
			currency = @"Touch here to select a currency.";
		}
	}
	return currency;
}

+ (NSString *) getLocaleCurrencyCode {
	NSLocale *locale = [NSLocale currentLocale];
	DLog(@"%@", [locale objectForKey: NSLocaleCurrencyCode]);
	return [locale objectForKey: NSLocaleCurrencyCode];
}

+ (NSString *) getLocaleCurrencySymbol {
	NSLocale *locale = [NSLocale currentLocale];
	DLog(@"%@", [locale objectForKey: NSLocaleCurrencySymbol]);
	return [locale objectForKey: NSLocaleCurrencySymbol];
}

+ (NSString *) getLocaleDisplayName {
	NSLocale *locale = [NSLocale currentLocale];
	NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
	return [locale displayNameForKey: NSLocaleCountryCode value: countryCode];
}

+ (NSString *) getLocaleCode {
	NSLocale *locale = [NSLocale currentLocale];
	return [locale objectForKey: NSLocaleCountryCode];
}

#pragma mark -
#pragma mark Price Division

+ (NSString *) calculatePricePerDay:(RentalSession *)s price:(NSNumber *)p {

	NSTimeInterval endDiff = [s.endDate timeIntervalSinceNow];
	NSTimeInterval startDiff = [s.startDate timeIntervalSinceNow];
	NSTimeInterval dateDiff = (endDiff - startDiff);
	
	NSInteger days = dateDiff/86400;
	NSString *pricePerDayString;
	
    
	if (days) {
		pricePerDayString = [NSString stringWithFormat:@"%.02f",[p doubleValue]/days];
	} else {
		pricePerDayString = [NSString stringWithFormat:@"%.02f",[p doubleValue]];
	}
	
	//NSLog(@"price = %.02f, pricePerDayString is %@", [p doubleValue], pricePerDayString);
	
	return pricePerDayString;
}

#pragma mark -
#pragma mark UINavigationBar Title Label

+ (UILabel *) getNavBarLabelWithTitle:(NSString *)t {
	CGRect frame = CGRectMake(0, 0, 155, 44);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	
	//label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor colorWithRed:0.067 green:0.314 blue:0.576 alpha:1.000];
	label.text = t;
	return label;
}

#pragma mark -
#pragma mark Green UIButton

+ (UIButton *) getGreenUIButtonWithTitle:(NSString *)t {
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setBackgroundImage:[UIImage imageNamed:@"greenbutton.png"] forState:UIControlStateNormal];
	[btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[btn setContentEdgeInsets:UIEdgeInsetsMake(0, 19, 0, 0)];
	[btn setTitle:t forState:UIControlStateNormal];
	[btn.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
	[btn setTitleShadowColor:[UIColor colorWithHexString:@"#808285"] forState:UIControlStateNormal];
	[[btn titleLabel] setShadowOffset:CGSizeMake(0, -1)];
	[btn setFrame:CGRectMake(11, 10, 272, 46)];
	return btn;
}

+ (UIButton *) getSmallGreenUIButtonWithTitle:(NSString *)t {
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn setBackgroundImage:[UIImage imageNamed:@"smallGreenButton.png"] forState:UIControlStateNormal];
	[btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[btn setContentEdgeInsets:UIEdgeInsetsMake(0, 19, 0, 0)];
	[btn setTitle:t forState:UIControlStateNormal];
	[[btn titleLabel] setFont:[UIFont boldSystemFontOfSize:22]];
	[btn setTitleShadowColor:[UIColor colorWithHexString:@"#808285"] forState:UIControlStateNormal];
	[[btn titleLabel] setShadowOffset:CGSizeMake(0,-1)];
	[btn setFrame:CGRectMake(11, 10, 152, 46)];
	return btn;
}

#pragma mark -
#pragma mark Blue Tint for the App

+ (UIColor *) blueColor {
	return [UIColor colorWithRed:0.000 green:0.609 blue:0.964 alpha:1.000];
}

+ (UIColor *) greyColor {
	return [UIColor colorWithRed:0.500 green:0.500 blue:0.500 alpha:1.000];
}

#pragma mark -
#pragma mark Get Session Fee Totals

+ (NSString *) getTotalFeesFromSession:(RentalSession *)session {
	NSNumber *total = [NSNumber numberWithDouble:0.00];
	
	if (session.hasBoughtInsurance) {
		total = [NSNumber numberWithDouble:([[CTHelper convertStringToNumber:session.insurance.premiumAmount] doubleValue] + [total doubleValue])];
	}
	
	NSString *currentCurrency;
	
	if ([session.theCar.fees count] > 0) {
		for (Fee *f in session.theCar.fees) {
			NSString *cs = [CTHelper getCurrencySymbolFromString:f.feeCurrencyCode];
			currentCurrency = cs;
			
			if ([f.feePurpose isEqualToString:@"22"]) {
				// Deposit
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
			} else if ([f.feePurpose isEqualToString:@"23"]) {
				// Pay on Arrival
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
				
			} else if ([f.feePurpose isEqualToString:@"6"]) {
				// Booking Fee amount is added to the deposit.
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
			}
		}
		
		return [NSString stringWithFormat:@"%@ %.2f", currentCurrency, [total doubleValue]];
		
	} else {
		return @"No fees.";
	}

}

+ (NSString *) getTotalFeesWithNoCurrencyFromSession:(RentalSession *)session {
	NSNumber *total = [NSNumber numberWithDouble:0.00];
	
	if (session.hasBoughtInsurance) {
		total = [NSNumber numberWithDouble:([[CTHelper convertStringToNumber:session.insurance.premiumAmount] doubleValue] + [total doubleValue])];
	}
	
	if ([session.theCar.fees count] > 0) {
		for (Fee *f in session.theCar.fees) {
			
			if ([f.feePurpose isEqualToString:@"22"]) {
				// Deposit
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
				
			} else if ([f.feePurpose isEqualToString:@"23"]) {
				// Pay on Arrival
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
				
			} else if ([f.feePurpose isEqualToString:@"6"]) {
				// Booking Fee amount is added to the deposit.
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
			}
		}
		
		return [NSString stringWithFormat:@"%.2f", [total doubleValue]];
		
	} else {
		return @"No fees.";
	}
	
}

#pragma mark -
#pragma mark Get Info JSON

@end
