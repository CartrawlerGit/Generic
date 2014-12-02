//
//  CTCurrency.h
//  CarTrawler
//
//

@interface CTCurrency : NSObject {
	NSString	*currencyName;
	NSString	*currencyCode;
	NSString	*currencyDisplayString;
}

@property (nonatomic, copy) NSString *currencyName;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, copy) NSString *currencyDisplayString;

- (id) initFromArray:(NSMutableArray *)csvRow;

@end
