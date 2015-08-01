//
//  Fee+NSDictionary.m
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "Fee+NSDictionary.h"

@implementation Fee (NSDictionary)

+ (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
	NSString *amount = [dictionary objectForKey:@"@Amount"];
	NSString *currencyCode = [dictionary objectForKey:@"@CurrencyCode"];
	NSString *purpose = [dictionary objectForKey:@"@Purpose"];
	NSString *purposeDescription = nil;
	
	if ([purpose isEqualToString:@"22"]) {
		purposeDescription = @"Deposit fee, taken at confirmation.";
	} else if ([purpose isEqualToString:@"23"]) {
		purposeDescription = @"Fee to pay on arrival.";
	} else if ([purpose isEqualToString:@"6"]) {
		purposeDescription = @"Cartrawler booking fee.";
	}
	
	Fee *fee = [[Fee alloc] initWithAmount:amount currencyCode:currencyCode andPurpose:purpose andPurposeDescription:purposeDescription];
	return fee;
}

@end
