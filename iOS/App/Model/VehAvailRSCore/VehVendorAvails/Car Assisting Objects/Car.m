//
//  Car.m
//  CarTrawler
//
//

#import "Car.h"
#import "PricedCoverage.h"
#import "VehicleCharge.h"
#import "Fee+NSDictionary.h"
#import "ExtraEquipment.h"

@implementation Car

@synthesize totalPriceForThisVehicle;
@synthesize vendor;
@synthesize orderIndex;
@synthesize extraEquipment;
@synthesize insuranceAvailable; // BOOL
@synthesize isAvailable;		// BOOL
@synthesize isAirConditioned;	// BOOL
@synthesize transmissionType;
@synthesize fuelType;
@synthesize driveType;
@synthesize passengerQty;
@synthesize passengerQtyInt;
@synthesize baggageQty;
@synthesize code;
@synthesize codeContext;
@synthesize vehicleCategory;
@synthesize doorCount;
@synthesize vehicleClassSize;
@synthesize vehicleMakeModelName;
@synthesize vehicleMakeModelCode;
@synthesize pictureURL;
@synthesize vehicleAssetNumber;
@synthesize vehicleCharges;		// NSMutableArray
@synthesize rateQualifier;
@synthesize rateTotalAmount;
@synthesize estimatedTotalAmount;
@synthesize currencyCode;
@synthesize refType;
@synthesize refID;
@synthesize refIDContext;
@synthesize refTimeStamp;
@synthesize refURL;
@synthesize orderBy;
@synthesize needCCInfo;			// BOOL
@synthesize theDuration;
@synthesize fees;
@synthesize currencyExchangeRate;
@synthesize currencyExchangeRate23;
@synthesize pricedCoverages;	// NSMutableArray


/* - (NSNumber *) calculateTotalPriceForThisCar
 * This was added along with the totalPriceForThisVehicle property when it was clear that orderIndex was useless for price sorting.
 * The Fees array isn't a direct subclass of Car so sort descriptors would be a pain, instead the property was created to carry
 * this objects total price in an NSNumber, this is then given to the sort descriptor to do its price sorting.
 */

- (NSNumber *) calculateTotalPriceForThisCar {
	NSNumber *total = [NSNumber numberWithDouble:0.00];
	
	if ([self.fees count] > 0) {
		
		for (Fee *f in self.fees) {
			if ([f.feePurpose isEqualToString:@"22"]) {
				//Deposit
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
				
			} else if ([f.feePurpose isEqualToString:@"23"]) {
				// Pay on Arrival
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
				
			} else if ([f.feePurpose isEqualToString:@"6"]) {
				// Booking Fee amount
				total = [NSNumber numberWithDouble:([[CTHelper convertFeeFromStringToNumber:f] doubleValue] + [total doubleValue])];
			} 
		}
		
	} else {
		DLog(@"No fee data in this car for some reason...");
	}
	
	return total;
	
}
- (id) initFromVehicleDictionary:(NSDictionary *)vehicleDictionary {
	
	// Takes the vehicle dictionary and goes to town on it for all the details listed above.
	// There's a lot of conditional stuff in here.
	
	if ([[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"@Status"] isEqualToString:@"Available"]) {
		self.isAvailable = YES;
	} else {
		self.isAvailable = NO;
	}
	
	//self.isAirConditioned = [[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"@AirConditioned"] boolValue];
	
	self.isAirConditioned = [[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"@AirConditionInd"] boolValue];
	
	self.transmissionType = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"@TransmissionType"];	
	
	self.fuelType = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"@FuelType"];
	
	self.driveType = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"@DriveType"];
	
	self.passengerQty = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"@PassengerQuantity"];
	self.passengerQtyInt = [self.passengerQty integerValue];
	
	self.baggageQty = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"@BaggageQuantity"];
	
	self.code = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"@Code"];
	
	self.codeContext = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"@CodeContext"];
	
	self.vehicleCategory = [CTHelper getVehcileCategoryStringFromNumber:[[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"VehType"] objectForKey:@"@VehicleCategory"]];
	
	self.doorCount = [[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"VehType"] objectForKey:@"@DoorCount"];
	
	self.vehicleClassSize = [[[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"VehClass"] objectForKey:@"@Size"] integerValue];
	
	self.vehicleMakeModelName = [[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"VehMakeModel"] objectForKey:@"@Name"];
	
	self.vehicleMakeModelCode = [[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"VehMakeModel"] objectForKey:@"@Code"];
	
	self.pictureURL = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"PictureURL"];
	
	self.vehicleAssetNumber = [[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Vehicle"] objectForKey:@"VehIdentity"] objectForKey:@"@VehicleAssetNumber"];
	
	// Rental Rate Data
	
	vehicleCharges = [[NSMutableArray alloc] init];
	
	NSMutableArray *thisCarsCharges = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"RentalRate"] objectForKey:@"VehicleCharges"];
	for (int i = 0; i < [thisCarsCharges count]; i++) {
		VehicleCharge *vc = [[VehicleCharge alloc] initFromVehicleChargesDictionary:[thisCarsCharges objectAtIndex:i]];
		[vehicleCharges addObject:vc];
	}
	
	self.rateQualifier = [[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"RentalRate"] objectForKey:@"RateQualifier"] objectForKey:@"@RateQualifier"];
	
	// Total Charge Data <- I've left this out as the docs say to pay attention to the TPA_Extension instead.
	
	// Fees <- As above, i've left this out in order to use the TPA_Extensions data instead.
	
	// Reference Data
	// ==============
	
	self.refType = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Reference"] objectForKey:@"@Type"];
	self.refID = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Reference"] objectForKey:@"@ID"];
	self.refIDContext = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Reference"] objectForKey:@"@ID_Context"];
	self.refTimeStamp = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Reference"] objectForKey:@"@DateTime"];
	self.refURL = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Reference"] objectForKey:@"@URL"];
	
	// TPA_Extensions
	// ==============
	
	self.orderBy = [[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"OrderBy"] objectForKey:@"@Index"];
	orderIndex = [orderBy intValue];
	self.needCCInfo = [[[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"CC_Info"] objectForKey:@"@Required"] boolValue];
	self.theDuration = [[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"Duration"] objectForKey:@"@Days"];
	self.insuranceAvailable = [[[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"Insurance"] objectForKey:@"@avail"] boolValue];

	
	// Fees Array
	// ==========
	
	fees = [[NSMutableArray alloc] init];
	// This is important.  The commented out code points to the TPA_Extensions node which is for information only, if it's supplied in 
	// the response at all.  The proper place to look is in the root of VehAvailCore -> Fees (array), the exchange rate below is then used for display.
	
	//NSMutableArray *tempFees = [[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"Fees"];
	NSMutableArray *tempFees = [[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"Fees"];
	for (int i = 0; i < [tempFees count]; i++) {
		Fee *f = [Fee  feeWithDictionary:[tempFees objectAtIndex:i]];
		[fees addObject:f];
	}
	self.currencyExchangeRate = [[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"CurrencyExchange"] objectForKey:@"@Rate"];
	self.currencyExchangeRate23 = [[[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"CurrencyExchange"] objectForKey:@"@Rate23"];

	// Extra Equipment
	// ===============
	
	extraEquipment = [[NSMutableArray alloc] init];
	
	if ([[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"PricedEquips"] isKindOfClass:[NSDictionary class]]) {
		DLog(@"\n\n\nSingle Extra Found...check JSON response!\n\n\n");
		/*
		ExtraEquipment *ex = [[ExtraEquipment alloc] initFromDictionary:[[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"PricedEquips"]];
		[extraEquipment addObject:ex];
		[ex release];
		*/
	} else {
		
		NSMutableArray *extras = [[vehicleDictionary objectForKey:@"VehAvailCore"] objectForKey:@"PricedEquips"];
		for (int i = 0; i < [extras count]; i++) {
			ExtraEquipment *ex = [[ExtraEquipment alloc] initFromDictionary:[extras objectAtIndex:i]];
			[extraEquipment addObject:ex];
		}
		
	}
	
	//DLog(@"\n\nThis car has %i extras\n\n", [extraEquipment count]);
	
	// Included in Price items
	// =======================
	
	pricedCoverages = [[NSMutableArray alloc] init];
	
	// Apologies for the lovely nest you find before you.  Turns out testing for included extras is a little complicated...
	
	if ([vehicleDictionary objectForKey:@"VehAvailInfo"]) { // Does the key exist?
		if ([[vehicleDictionary objectForKey:@"VehAvailInfo"] isKindOfClass:[NSArray class]]) { // Is it an array?
			
			if (![[vehicleDictionary objectForKey:@"VehAvailInfo"] count] > 0) { // Is it empty?
				NSArray *array = [vehicleDictionary objectForKey:@"VehAvailInfo"];
				if ([array count] > 0) {
					if ([[[vehicleDictionary objectForKey:@"VehAvailInfo"] objectForKey:@"PricedCoverages"] isKindOfClass:[NSArray class]]) { // Get the included bits
						
						NSArray *temp = [[vehicleDictionary objectForKey:@"VehAvailInfo"] objectForKey:@"PricedCoverages"];
						
						for (int i = 0; i < [temp count]; i++) {
							PricedCoverage *pc = [[PricedCoverage alloc] initWithPricedCoveragesDictionary:[temp objectAtIndex:i]];
							[pricedCoverages addObject:pc];
						}
					}
				}
			} else {
				
			}

		} else if ([[vehicleDictionary objectForKey:@"VehAvailInfo"] isKindOfClass:[NSDictionary class]]) {
			if ([[[vehicleDictionary objectForKey:@"VehAvailInfo"] objectForKey:@"PricedCoverages"] isKindOfClass:[NSArray class]]) { // Get the included bits
				
				NSArray *temp = [[vehicleDictionary objectForKey:@"VehAvailInfo"] objectForKey:@"PricedCoverages"];
				
				for (int i = 0; i < [temp count]; i++) {
					PricedCoverage *pc = [[PricedCoverage alloc] initWithPricedCoveragesDictionary:[temp objectAtIndex:i]];
					[pricedCoverages addObject:pc];
				}
			}
		}
	}
	
	self.totalPriceForThisVehicle = [self calculateTotalPriceForThisCar];
	return self;
}


@end
