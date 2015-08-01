//
//  Vendor.m
//  CarTrawler
//

#import "Vendor.h"
#import "Car.h"

@implementation Vendor

@synthesize vendorCode;
@synthesize vendorName;
@synthesize vendorDivision;
@synthesize venLogo;
@synthesize vendorID;		// Not used
@synthesize availableCars;	// NSMutableArray
@synthesize atAirport;		//BOOL
@synthesize locationCode;
@synthesize venLocationName;
@synthesize venAddress;
@synthesize venCountryCode;
@synthesize venPhone;
@synthesize dropoffVendor;

- (id)initFromVehVendorAvailsDictionary:(NSDictionary *)vehVendorAvails withLocation:(NSDictionary*)locationDetailsDict{
	Vendor *vendor = [[Vendor alloc] init];
	vendor.vendorCode = [[vehVendorAvails objectForKey:@"Vendor"] objectForKey:@"@Code"];
	vendor.vendorName = [[vehVendorAvails objectForKey:@"Vendor"] objectForKey:@"@CompanyShortName"];
	vendor.vendorDivision = [[vehVendorAvails objectForKey:@"Vendor"] objectForKey:@"@Division"];
	
	vendor.locationCode = [locationDetailsDict objectForKey:@"@Code"];
	vendor.atAirport = [[locationDetailsDict objectForKey:@"@AtAirport"] boolValue];
	vendor.venLocationName = [locationDetailsDict objectForKey:@"@Name"];
	vendor.venAddress = [[locationDetailsDict objectForKey:@"Address"] objectForKey:@"AddressLine"];
	vendor.venCountryCode = [[[locationDetailsDict objectForKey:@"Address"] objectForKey:@"CountryName"] objectForKey:@"@Code"];
	vendor.venPhone = [[locationDetailsDict objectForKey:@"Telephone"] objectForKey:@"@PhoneNumber"];
	
	availableCars = [[NSMutableArray alloc] init];
	
	NSMutableArray *cars = (NSMutableArray *)[vehVendorAvails objectForKey:@"VehAvails"];
	for (int i = 0; i < [cars count]; i++) 
	{
		Car *car = [[Car alloc] initFromVehicleDictionary:[cars objectAtIndex:i]];
		[availableCars addObject:car];
	}
	vendor.venLogo = [[[vehVendorAvails objectForKey:@"Info"] objectForKey:@"TPA_Extensions"] objectForKey:@"VendorPictureURL"];
	return vendor;
}

- (id)initFromVehVendorAvailsDictionary:(NSDictionary *)vehVendorAvails {
	if ([[[vehVendorAvails objectForKey:@"Info"] objectForKey:@"LocationDetails"] isKindOfClass:[NSMutableArray class]]){
		// dropoff differs from pickup location
		if ([[[vehVendorAvails objectForKey:@"Info"] objectForKey:@"LocationDetails"] count]>1){
			NSDictionary *locationDetailsDict = [[[vehVendorAvails objectForKey:@"Info"] objectForKey:@"LocationDetails"] objectAtIndex:0];
			NSDictionary *dropoffLocationDetailsDict = [[[vehVendorAvails objectForKey:@"Info"] objectForKey:@"LocationDetails"] objectAtIndex:1];
			self = [self initFromVehVendorAvailsDictionary:vehVendorAvails withLocation:locationDetailsDict];
			self.dropoffVendor = [self initFromVehVendorAvailsDictionary:vehVendorAvails withLocation:dropoffLocationDetailsDict];
		} else{
			DLog(@"We have an array containing one location item returned. We should have a location item instead.")
		}
	} else {
		// dropoff same as pickup location
		NSDictionary *locationDetailsDict = [[vehVendorAvails objectForKey:@"Info"] objectForKey:@"LocationDetails"];
		self = [self initFromVehVendorAvailsDictionary:vehVendorAvails withLocation:locationDetailsDict];
		self.dropoffVendor = [self initFromVehVendorAvailsDictionary:vehVendorAvails withLocation:locationDetailsDict];
	}

	return self;
}


@end
