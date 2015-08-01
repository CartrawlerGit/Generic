//
//  CTCountry.m
//  CarTrawler
//
//

#import "CTCountry.h"


@implementation CTCountry

- (instancetype) initWithIsoCountryName:(NSString *)isoCountryName isoCountryCode:(NSString *)isoCountryCode andIsoDialingCode:(NSString *)isoDailingCode
{
	return [self initWithCurrencyName:nil currencyCode:nil currencySymbol:nil isoCountryName:isoCountryName isoCountryCode:isoCountryCode andIsoDialingCode:isoDailingCode];
}

- (instancetype) initWithCurrencyName:(NSString *)currencyName currencyCode:(NSString *)currencyCode currencySymbol:(NSString *)currencySymbol isoCountryName:(NSString *)isoCountryName isoCountryCode:(NSString *)isoCountryCode andIsoDialingCode:(NSString *)isoDailingCode
{
	self = [super init];
	if (self) {
		_currencyName = currencyName;
		_currencyCode = currencyCode;
		_currencySymbol = currencySymbol;
		
		_isoCountryName = isoCountryName;
		_isoCountryCode = isoCountryCode;
		_isoDialingCode = isoDailingCode;
	}
	return self;
}

@end
