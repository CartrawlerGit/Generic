//
//  CTCountry.m
//  CarTrawler
//
//

#import "CTCountry.h"


@implementation CTCountry

@synthesize currencyName;
@synthesize currencyCode;
@synthesize currencySymbol;
@synthesize isoCountryName;
@synthesize isoCountryCode;
@synthesize isoDialingCode;

- (id) initFromArray:(NSMutableArray *)csvRow {
	// The csvArray takes the format of 0: isoCountry, 1: countryCode, 2: diallingCode.
	self.isoCountryName = [csvRow objectAtIndex:0];
	self.isoCountryCode = [csvRow objectAtIndex:1];
	self.isoDialingCode = [csvRow objectAtIndex:2];
	
	return self;
}


@end
