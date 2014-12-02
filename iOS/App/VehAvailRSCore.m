//
//  VehAvailRSCore.m
//  CarTrawler
//
//

#import "VehAvailRSCore.h"
#import "Vendor.h"
#import "Car.h"

@implementation VehAvailRSCore

@synthesize puDate;
@synthesize doDate;
@synthesize puLocationCode;
@synthesize puLocationName;
@synthesize doLocationCode;
@synthesize doLocationName;
@synthesize availableVendors;

- (id) initFromVehAvailRSCoreDictionary:(NSDictionary *)vehAvailRSCoreDictionary {
	self.puDate = [[vehAvailRSCoreDictionary objectForKey:@"VehRentalCore"] objectForKey:@"@PickUpDateTime"];
	self.doDate = [[vehAvailRSCoreDictionary objectForKey:@"VehRentalCore"] objectForKey:@"@ReturnDateTime"];
	self.puLocationCode = [[[vehAvailRSCoreDictionary objectForKey:@"VehRentalCore"] objectForKey:@"PickUpLocation"] objectForKey:@"@LocationCode"];
	self.puLocationName = [[[vehAvailRSCoreDictionary objectForKey:@"VehRentalCore"] objectForKey:@"PickUpLocation"] objectForKey:@"@Name"];
	self.doLocationCode = [[[vehAvailRSCoreDictionary objectForKey:@"VehRentalCore"] objectForKey:@"ReturnLocation"] objectForKey:@"@LocationCode"];
	self.doLocationName = [[[vehAvailRSCoreDictionary objectForKey:@"VehRentalCore"] objectForKey:@"ReturnLocation"] objectForKey:@"@Name"];
	
	availableVendors = [[NSMutableArray alloc] init];
	
	if ([[vehAvailRSCoreDictionary objectForKey:@"VehVendorAvails"] isKindOfClass:[NSArray class]]) {
		NSMutableArray *rawVendorArray = (NSMutableArray *)[vehAvailRSCoreDictionary objectForKey:@"VehVendorAvails"];
		
		// Now, loop through the VehVendorAvails array (which contains n x dictionaries of available vendors & their cars.
		
		for (int i = 0; i < [rawVendorArray count]; i++) {
			Vendor *ven = [[Vendor alloc] initFromVehVendorAvailsDictionary:[rawVendorArray objectAtIndex:i]];
			[availableVendors addObject:ven];
			[ven release];
		}
	} else {
		Vendor *ven = [[Vendor alloc] initFromVehVendorAvailsDictionary:[[vehAvailRSCoreDictionary objectForKey:@"VehVendorAvails"] objectForKey:@"VehVendorAvail"]];
		[availableVendors addObject:ven];
		[ven release];
	}

	return self;
}

- (void)dealloc {
	[puDate release];
	[doDate release];
	[puLocationCode release];
	[puLocationName release];
	[doLocationCode release];
	[doLocationName release];
	[availableVendors release];

	[super dealloc];
}

@end
