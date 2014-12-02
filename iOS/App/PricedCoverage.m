//
//  PricedCoverage.m
//  CarTrawler
//
//

#import "PricedCoverage.h"


@implementation PricedCoverage

@synthesize coverageType;
@synthesize chargeDescription;
@synthesize isTaxInclusive;
@synthesize isIncludedInRate;

- (id)initWithPricedCoveragesDictionary:(NSDictionary *)pricedCoveragesDictionary {
	self.coverageType = [[pricedCoveragesDictionary objectForKey:@"Coverage"] objectForKey:@"@CoverageType"];
	self.chargeDescription = [[pricedCoveragesDictionary objectForKey:@"Charge"] objectForKey:@"@Description"];
	self.isTaxInclusive = [[[pricedCoveragesDictionary objectForKey:@"Charge"] objectForKey:@"@TaxInclusive"] boolValue];
	self.isIncludedInRate = [[[pricedCoveragesDictionary objectForKey:@"Charge"] objectForKey:@"@IncludedInRate"] boolValue];
	
	//DLog(@"%@, %@", self.coverageType, self.chargeDescription);
	
	return self;
}

- (void)dealloc
{
	[coverageType release];
	[chargeDescription release];
	[super dealloc];
}

@end
