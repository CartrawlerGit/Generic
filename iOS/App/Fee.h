//
//  Fee.h
//  CarTrawler
//
//

@interface Fee : NSObject
{
	NSString	*feeAmount;
	NSString	*feeCurrencyCode;
	NSString	*feePurpose;
	NSString	*feePurposeDescription;
}

@property (nonatomic, copy) NSString *feeAmount;
@property (nonatomic, copy) NSString *feeCurrencyCode;
@property (nonatomic, copy) NSString *feePurpose;
@property (nonatomic, copy) NSString *feePurposeDescription;

- (id)initFromFeeDictionary:(NSDictionary *)feeDictionary;

@end
