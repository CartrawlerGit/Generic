//
//  VehicleCharge.h
//  CarTrawler
//

@interface VehicleCharge : NSObject
{
	NSString	*chargeDescription;
	BOOL		isTaxInclusive;
	BOOL		isIncludedInRate;
	NSString	*chargePurpose;
}

@property (nonatomic, copy) NSString *chargeDescription;
@property (nonatomic, assign) BOOL isTaxInclusive;
@property (nonatomic, assign) BOOL isIncludedInRate;
@property (nonatomic, copy) NSString *chargePurpose;

- (id) initFromVehicleChargesDictionary:(NSDictionary *)vehicleChargesDictionary;

@end
