//
//  CTCareNumber.m
//  CarTrawler
//
//

#import "CTCareNumber.h"


@implementation CTCareNumber

@synthesize isoCountryCode;
@synthesize countryName;
@synthesize careNumber;

- (id) initFromInfoDictionary:(NSDictionary *)dict {
	
	// Sample Dictionary
	// {"code": "IE", "name": "Ireland", "number": "+353-1-12345678"}
	
	self.isoCountryCode = [dict objectForKey:@"code"];
	self.countryName = [dict objectForKey:@"name"];
	self.careNumber = [dict objectForKey:@"number"];
	
	return self;
}

- (void)dealloc {
    /*
	[isoCountryCode release];
	isoCountryCode = nil;
	[countryName release];
	countryName = nil;
	[careNumber release];
	careNumber = nil;
	[super dealloc];
     */
}

@end
