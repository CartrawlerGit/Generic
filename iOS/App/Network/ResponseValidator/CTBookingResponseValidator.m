//
//  CTBookingResponseValidator.m
//  CarTrawler
//
//  Created by Igor Ferreira on 8/2/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTBookingResponseValidator.h"
#import "Booking+RetrievedBooking.h"
#import "CTError+ResponseValidator.h"

@implementation CTBookingResponseValidator

+ (id)validateResponseObject:(id)response
{
	if ([[[response objectForKey:@"VehRetResRSCore"] objectForKey:@"VehReservation"] objectForKey:@"@Status"]) {
		NSString *statusStr = [[[response objectForKey:@"VehRetResRSCore"] objectForKey:@"VehReservation"] objectForKey:@"@Status"];
		
		if ([statusStr isEqualToString:@"Confirmed"]) {
			Booking *b = [[Booking alloc] initFromRetrievedBookingDictionary:[[response objectForKey:@"VehRetResRSCore"] objectForKey:@"VehReservation"]];
			return b;
		}
	}
	
	return nil;
}

+ (void)validateCompleteResponse:(id)response withSuccess:(CTBookingResponseValidatorSuccess)sucess andError:(CTBookingResponseValidatorError)error
{
	NSArray *errorObject = [CTError validateResponseObject:response];
	if (errorObject) {
		if (error) {
			error(errorObject);
		}
		return;
	}
	
	Booking *booking = [self validateResponseObject:response];
	
	if (sucess) {
		sucess(booking);
	}
}

@end
