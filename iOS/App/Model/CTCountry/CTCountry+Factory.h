//
//  CTCountry+Factory.h
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTCountry.h"

@interface CTCountry (Factory)

- (instancetype) countryWithCurrencyCode:(NSString *)currencyCode;
- (instancetype) countryWithCurrencyCode:(NSString *)currencyCode andCurrencySymbol:(NSString *)currencySymbol;
- (instancetype) countryWithIsoCountryName:(NSString *)isoCountryName andIsoCountryCode:(NSString *)isoCountryCode;
- (instancetype) countryWithIsoCountryName:(NSString *)isoCountryName isoCountryCode:(NSString *)isoCountryCode andIsoDailingCode:(NSString *)isoDailingCode;

@end
