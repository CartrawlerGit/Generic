//
//  PricedCoverage.h
//  CarTrawler
//
//

@interface PricedCoverage : NSObject
{
	NSString	*coverageType;
	NSString	*chargeDescription;
	BOOL		isTaxInclusive;
	BOOL		isIncludedInRate;
}

@property (nonatomic, copy) NSString *coverageType;
@property (nonatomic, copy) NSString *chargeDescription;
@property (nonatomic, assign) BOOL isTaxInclusive;
@property (nonatomic, assign) BOOL isIncludedInRate;

- (id)initWithPricedCoveragesDictionary:(NSDictionary *)pricedCoveragesDictionary;

@end
