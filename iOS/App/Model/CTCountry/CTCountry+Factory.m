//
//  CTCountry+Factory.m
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTCountry+Factory.h"

@implementation CTCountry (Factory)

- (instancetype) countryWithCurrencyCode:(NSString *)currencyCode
{
	return [self countryWithCurrencyCode:currencyCode andCurrencySymbol:self.currencySymbol];
}
- (instancetype) countryWithCurrencyCode:(NSString *)currencyCode andCurrencySymbol:(NSString *)currencySymbol
{
	CTCountry *newCountry = [[CTCountry alloc] initWithCurrencyName:self.currencyName currencyCode:currencyCode currencySymbol:currencySymbol isoCountryName:self.isoCountryName isoCountryCode:self.isoCountryCode andIsoDialingCode:self.isoDialingCode];
	return newCountry;
}
- (instancetype) countryWithIsoCountryName:(NSString *)isoCountryName andIsoCountryCode:(NSString *)isoCountryCode
{
	return [self countryWithIsoCountryName:isoCountryName isoCountryCode:isoCountryCode andIsoDailingCode:self.isoDialingCode];
}
- (instancetype) countryWithIsoCountryName:(NSString *)isoCountryName isoCountryCode:(NSString *)isoCountryCode andIsoDailingCode:(NSString *)isoDailingCode
{
	CTCountry *newCountry = [[CTCountry alloc] initWithCurrencyName:self.currencyName currencyCode:self.currencyCode currencySymbol:self.currencySymbol isoCountryName:isoCountryName isoCountryCode:isoCountryCode andIsoDialingCode:isoDailingCode];
	return newCountry;
}

@end
