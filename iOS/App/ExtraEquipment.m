//
//  ExtraEquipment.m
//  CarTrawler
//
//

#import "ExtraEquipment.h"


@implementation ExtraEquipment

@synthesize qty;
@synthesize chargeAmount;
@synthesize isIncludedInRate;
@synthesize currencyCode;
@synthesize isTaxInclusive;
@synthesize equipType;
@synthesize description;

- (id) initFromDictionary:(NSDictionary *)dict {
	self.chargeAmount = [[dict objectForKey:@"Charge"] objectForKey:@"@Amount"];
	self.isIncludedInRate = [[[dict objectForKey:@"Charge"] objectForKey:@"@IncludedInRate"] boolValue];
	self.currencyCode = [[dict objectForKey:@"Charge"] objectForKey:@"@CurrencyCode"];
	self.isTaxInclusive = [[[dict objectForKey:@"Charge"] objectForKey:@"@TaxInclusive"] boolValue];
	
	self.equipType = [[dict objectForKey:@"Equipment"] objectForKey:@"@EquipType"];
	self.description = [[dict objectForKey:@"Equipment"] objectForKey:@"Description"];
	self.qty = 0;
	return self;
}

- (void)dealloc {
	[chargeAmount release];
	chargeAmount = nil;
	[currencyCode release];
	currencyCode = nil;
	[equipType release];
	equipType = nil;
	[description release];
	description = nil;

	[super dealloc];
}

@end
