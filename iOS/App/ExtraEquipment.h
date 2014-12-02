//
//  ExtraEquipment.h
//  CarTrawler
//
//


@interface ExtraEquipment : NSObject {
	NSString	*chargeAmount;
	BOOL		isIncludedInRate;
	NSString	*currencyCode;
	BOOL		isTaxInclusive;
	
	NSString	*equipType;
	NSString	*description;
	
	NSInteger	qty;
}

@property (nonatomic, assign) NSInteger qty;
@property (nonatomic, copy) NSString *chargeAmount;
@property (nonatomic, assign) BOOL isIncludedInRate;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, assign) BOOL isTaxInclusive;
@property (nonatomic, copy) NSString *equipType;
@property (nonatomic, copy) NSString *description;

- (id) initFromDictionary:(NSDictionary *)dict;

@end
