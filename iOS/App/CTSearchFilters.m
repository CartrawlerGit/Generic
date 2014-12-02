//
//  CTSearchFilters.m
//  CarTrawler
//
//

#import "CTSearchFilters.h"

enum {
	kVehicleSeats2=0,
	kVehicleSeats4,
	kVehicleSeats6,
	kVehicleSeatsAny
} kVehicleSeatingCapacity;

enum {
	kFuelPetrol=0,
	kFuelDiesel,
	kFuelEither
} kVehicleFuelType;

enum {
	kTransmissionAutomatic=0,
	kTransmissionManual,
	kTransmissionEither
} kVehicleTranmission;

enum {
	kAirConRequired=0,
	kAirConNotRequired
} kVehicleAirCon;

@implementation CTSearchFilters

@synthesize people;
@synthesize fuel;
@synthesize transmission;
@synthesize airCon;

-(NSString*)getSeatingFilterPredicate{
	switch (people) {
		case kVehicleSeats2:
			return @"(passengerQtyInt<3) ";
			break;
		case kVehicleSeats4:
			return @"(passengerQtyInt<5) ";
			break;
		case kVehicleSeats6:
			return @"(passengerQtyInt<7) ";
			break;
		case kVehicleSeatsAny:
			return @"";
			break;
		default:
			return @"";
			break;
	}
}
- (NSString*)getFuelTypeFilterPredicate{
	switch (fuel) {
		case kFuelPetrol:
			return @"(fuelType='Petrol') ";
			break;
		case kFuelDiesel:
			return @"(fuelType='Diesel') ";
			break;
		case kFuelEither:
			return @"";
			break;
		default:
			return @"";
			break;
	}
}
- (NSString*)getTransmissionTypeFilterPredicate{
	switch (transmission) {
		case kTransmissionAutomatic:
			return @"(transmissionType='Automatic') ";
			break;
		case kTransmissionManual:
			return @"(transmissionType='Manual') ";
			break;
		case kTransmissionEither:
			return @"";
			break;
		default:
			return @"";
			break;
	}
}
-(NSString*)getAirConFilterPredicate{
	switch (airCon) {
		case kAirConRequired:
			return @"(isAirConditioned=YES) ";
			break;
		case kAirConNotRequired:
			return @"";//@"(isAirConditioned=NO) ";
			break;
		default:
			return @"";
			break;
	}
}

-(NSString*)description{

	NSString *desc = @"";
	if (![[self getSeatingFilterPredicate] isEqualToString:@""])
		desc = [self getSeatingFilterPredicate];
	
	if (![[self getFuelTypeFilterPredicate] isEqualToString:@""]){
		if (![desc isEqualToString:@""])
			desc = [NSString stringWithFormat:@"%@ AND ",desc];
		desc = [NSString stringWithFormat:@"%@%@",desc,[self getFuelTypeFilterPredicate]];
	}
	
	if (![[self getTransmissionTypeFilterPredicate] isEqualToString:@""]){
		if (![desc isEqualToString:@""])
			desc = [NSString stringWithFormat:@"%@ AND ",desc];
		desc = [NSString stringWithFormat:@"%@%@",desc,[self getTransmissionTypeFilterPredicate]];
	}
	
	if (![[self getAirConFilterPredicate] isEqualToString:@""]){
		if (![desc isEqualToString:@""])
			desc = [NSString stringWithFormat:@"%@ AND ",desc];
		desc = [NSString stringWithFormat:@"%@%@",desc,[self getAirConFilterPredicate]];
	}
	
	return desc;
}

@end
