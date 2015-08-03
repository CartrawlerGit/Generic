//
//  CTCountry+Coding.m
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTCountry+Coding.h"

@implementation CTCountry (Coding)

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.isoCountryName forKey:@"ctCountry.isoCountryName"];
	[aCoder encodeObject:self.isoCountryCode forKey:@"ctCountry.isoCountryCode"];
	[aCoder encodeObject:self.isoDialingCode forKey:@"ctCountry.isoDialingCode"];
	[aCoder encodeObject:self.currencyCode forKey:@"ctCountry.currencyCode"];
	[aCoder encodeObject:self.currencySymbol forKey:@"ctCountry.currencySymbol"];
	[aCoder encodeObject:self.currencyName forKey:@"ctCountry.currencyName"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
	NSString *isoCountryName = [aDecoder decodeObjectForKey:@"ctCountry.isoCountryName"];
	NSString *isoCountryCode = [aDecoder decodeObjectForKey:@"ctCountry.isoCountryCode"];
	NSString *isoDialingCode = [aDecoder decodeObjectForKey:@"ctCountry.isoDialingCode"];
	NSString *currencyCode = [aDecoder decodeObjectForKey:@"ctCountry.currencyCode"];
	NSString *currencySymbol = [aDecoder decodeObjectForKey:@"ctCountry.currencySymbol"];
	NSString *currencyName = [aDecoder decodeObjectForKey:@"ctCountry.currencyName"];
	
	return [self initWithCurrencyName:currencyName currencyCode:currencyCode currencySymbol:currencySymbol isoCountryName:isoCountryName isoCountryCode:isoCountryCode andIsoDialingCode:isoDialingCode];
}

@end
