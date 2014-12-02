//
//  Fee.m
//  CarTrawler
//
//

#import "Fee.h"


@implementation Fee

@synthesize feeAmount;
@synthesize feeCurrencyCode;
@synthesize feePurpose;
@synthesize feePurposeDescription;

- (id)initFromFeeDictionary:(NSDictionary *)feeDictionary {
	self.feeAmount = [feeDictionary objectForKey:@"@Amount"];
	self.feeCurrencyCode = [feeDictionary objectForKey:@"@CurrencyCode"];
	self.feePurpose = [feeDictionary objectForKey:@"@Purpose"];
	
	if ([self.feePurpose isEqualToString:@"22"]) {
		self.feePurposeDescription = @"Deposit fee, taken at confirmation.";
	}
	if ([self.feePurpose isEqualToString:@"23"]) {
		self.feePurposeDescription = @"Fee to pay on arrival.";
	}
	if ([self.feePurpose isEqualToString:@"6"]) {
		self.feePurposeDescription = @"Cartrawler booking fee.";
	}
	
	return self;
}

- (void)dealloc {
	[feeAmount release];
	[feeCurrencyCode release];
	[feePurpose release];
	[feePurposeDescription release];

	[super dealloc];
}

@end
