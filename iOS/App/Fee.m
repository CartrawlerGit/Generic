//
//  Fee.m
//  CarTrawler
//
//

#import "Fee.h"

@implementation Fee

@synthesize feeAmount = _feeAmount;
@synthesize feeCurrencyCode = _feeCurrencyCode;
@synthesize feePurpose = _feePurpose;
@synthesize feePurposeDescription = _feePurposeDescription;

- (instancetype) initWithAmount:(NSString *)amount currencyCode:(NSString *)currencyCode andPurpose:(NSString *)purpose andPurposeDescription:(NSString *)description
{
	self = [super init];
	if (self) {
		_feeAmount = amount;
		_feeCurrencyCode = currencyCode;
		_feePurpose = purpose;
		_feePurposeDescription = description;
	}
	return self;
}

@end
