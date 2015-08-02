//
//  CTBookingRequester.m
//  CarTrawler
//
//  Created by Igor Ferreira on 8/2/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTBookingRequester.h"

@implementation CTBookingRequester

+ (ASIHTTPRequest *) requestBookingWithEmail:(NSString *)bookingEmail bookingId:(NSString *)bookingId andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
	NSString *jsonString = [NSString stringWithFormat:@"{%@%@}", [CTRQBuilder buildHeader:kGetExistingBookingHeader], [CTRQBuilder OTA_VehRetResRQ:bookingEmail bookingRefID:bookingId]];
	
	if (kShowResponse) {
		DLog(@"Request is \n\n%@\n\n", jsonString);
	}
	
	NSData *requestData = [NSData dataWithBytes: [jsonString UTF8String] length: [jsonString length]];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kCTTestAPI, KOTA_VehRetResRQ]];
	
	return [super postRequestWitUrl:url data:requestData andDelegate:delegate];
}

@end
