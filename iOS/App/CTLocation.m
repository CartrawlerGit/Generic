//
//  CTLocation.m
//  CarTrawler
//
//

#import "CTLocation.h"

@implementation CTLocation

@synthesize iconImage;
@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize locationCityName;
@synthesize iataCode;
@synthesize atAirport;
@synthesize locationCode;
@synthesize codeContext;
@synthesize locationName;
@synthesize addressLine;
@synthesize countryCode;
@synthesize location;
@synthesize distance;
@synthesize distanceMetric;

- (id) initFromDictionary:(NSDictionary *)response {

	self.atAirport = [[[response objectForKey:@"LocationDetail"] objectForKey:@"@AtAirport"] boolValue];
	self.locationCode = [[response objectForKey:@"LocationDetail"] objectForKey:@"@Code"];
	self.locationName = [[response objectForKey:@"LocationDetail"] objectForKey:@"@Name"];
	self.addressLine = [[[response objectForKey:@"LocationDetail"] objectForKey:@"Address"] objectForKey:@"AddressLine"];
	if ([[response objectForKey:@"LocationDetail"] objectForKey:@"@CountryCode"]) {
		self.countryCode = [[response objectForKey:@"LocationDetail"] objectForKey:@"@CountryCode"];
	} else {
		self.countryCode = [[[[response objectForKey:@"LocationDetail"] objectForKey:@"Address"] objectForKey:@"CountryName"] objectForKey:@"@Code"];
	}
	self.distance = [[[[[response objectForKey:@"LocationDetail"] objectForKey:@"AdditionalInfo"] objectForKey:@"TPA_Extensions"] objectForKey:@"SearchRef"] objectForKey:@"@Distance"];
	self.distanceMetric = [[[[[response objectForKey:@"LocationDetail"] objectForKey:@"AdditionalInfo"] objectForKey:@"TPA_Extensions"] objectForKey:@"SearchRef"] objectForKey:@"@DistanceMeasure"];
	
	location = [[CLLocation alloc] initWithLatitude:[[[[[[response objectForKey:@"LocationDetail"] objectForKey:@"AdditionalInfo"] objectForKey:@"TPA_Extensions"] objectForKey:@"Position"] objectForKey:@"@Latitude"] doubleValue]
												 longitude:[[[[[[response objectForKey:@"LocationDetail"] objectForKey:@"AdditionalInfo"] objectForKey:@"TPA_Extensions"] objectForKey:@"Position"] objectForKey:@"@Longitude"] doubleValue]];
    
	
	self.title = locationName;
	self.subtitle = [NSString stringWithFormat:@"%@%@", distance, distanceMetric];
	if (atAirport) {
		self.iconImage = @"pointer_red.png";
	} else {
		self.iconImage = @"pointer_blue.png";
	}

	self.coordinate = location.coordinate;
	
	if ([[response allKeys] containsObject:@"@AirportCode"]) {
		self.atAirport = YES;
		self.iataCode = [response objectForKey:@"@AirportCode"];
	}
	
	return self;
}

- (id) initShortLocationFromDictionary:(NSDictionary *)response {
	self.locationName = [response objectForKey:@"@Name"];
	self.countryCode = [response objectForKey:@"@CountryCode"];
	self.locationCode = [response objectForKey:@"@Code"];
	
	if ([[response allKeys] containsObject:@"@AirportCode"]) {
		self.atAirport = YES;
		self.iataCode = [response objectForKey:@"@AirportCode"];
	}
	return self;
}


@end
