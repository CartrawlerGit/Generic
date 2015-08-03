//
//  CTCountry+NSArray.m
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTCountry+NSArray.h"

@implementation CTCountry (NSArray)

+ (instancetype) countryFromArray:(NSMutableArray *)csvRow
{
	NSString *isoCountryName = [csvRow objectAtIndex:0];
	NSString *isoCountryCode = [csvRow objectAtIndex:1];
	NSString *isoDialingCode = [csvRow objectAtIndex:2];
	
	CTCountry *ctCountry = [[CTCountry alloc] initWithIsoCountryName:isoCountryName isoCountryCode:isoCountryCode andIsoDialingCode:isoDialingCode];
	return ctCountry;
}

@end
