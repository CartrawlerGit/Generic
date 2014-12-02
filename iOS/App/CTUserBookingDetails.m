//
//  CTUserBookingDetails.m
//  CarTrawler
//
//

#import "CTUserBookingDetails.h"

@implementation CTUserBookingDetails 

@synthesize namePrefix;
@synthesize givenName;
@synthesize surname;
@synthesize phoneAreaCode;
@synthesize phoneNumber;
@synthesize emailAddress;
@synthesize address;
@synthesize countryCode;

@synthesize ccHolderName;
@synthesize ccNumber;
@synthesize ccExpDate;
@synthesize ccSeriesCode;
@synthesize cardType;

-(NSString*)description{
	return [NSString stringWithFormat:@"\n\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n\n%@\n%@\n%@\n%@\n%ld\n\n",
			namePrefix,
			givenName,
			surname,
			phoneAreaCode,
			phoneNumber,
			emailAddress,
			address,
			countryCode,

			ccHolderName,
			ccNumber,
			ccExpDate,
			ccSeriesCode,
			(long)cardType];
			
}

@end
