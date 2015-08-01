//
//  Fee.m
//  CarTrawler
//
//

#import "Fee.h"

@implementation Fee

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
