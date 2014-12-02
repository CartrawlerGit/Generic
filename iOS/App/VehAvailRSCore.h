//
//  VehAvailRSCore.h
//  CarTrawler
//

@interface VehAvailRSCore : NSObject {
	NSString	*puDate;
	NSString	*doDate;
	NSString	*puLocationCode;
	NSString	*puLocationName;
	NSString	*doLocationCode;
	NSString	*doLocationName;
	
	NSMutableArray *availableVendors;
}

- (id)initFromVehAvailRSCoreDictionary:(NSDictionary *)vehAvailRSCoreDictionary;

@property (nonatomic, copy) NSString *puDate;
@property (nonatomic, copy) NSString *doDate;
@property (nonatomic, copy) NSString *puLocationCode;
@property (nonatomic, copy) NSString *puLocationName;
@property (nonatomic, copy) NSString *doLocationCode;
@property (nonatomic, copy) NSString *doLocationName;
@property (nonatomic, retain) NSMutableArray *availableVendors;

@end
