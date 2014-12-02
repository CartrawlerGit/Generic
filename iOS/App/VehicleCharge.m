//
//  VehicleCharge.m
//  CarTrawler
//
//

#import "VehicleCharge.h"

@implementation VehicleCharge

@synthesize chargeDescription;
@synthesize isTaxInclusive;
@synthesize isIncludedInRate;
@synthesize chargePurpose;

- (id) initFromVehicleChargesDictionary:(NSDictionary *)vehicleChargesDictionary {
	
	self.chargeDescription = [vehicleChargesDictionary objectForKey:@"@Description"];
	self.chargePurpose = [vehicleChargesDictionary objectForKey:@"@Purpose"];
	self.isTaxInclusive = [[vehicleChargesDictionary objectForKey:@"@TaxInclusive"] boolValue];
	self.isIncludedInRate = [[vehicleChargesDictionary objectForKey:@"@IncludedInRate"] boolValue];
	// DLog(@"Charge desc is %@", self.chargeDescription);
	
	return self;
}

- (void)dealloc
{
	[chargeDescription release];
	[chargePurpose release];

	[super dealloc];
}

@end
