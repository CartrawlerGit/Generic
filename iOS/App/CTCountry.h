//
//  CTCountry.h
//  CarTrawler
//
//


@interface CTCountry : NSObject {

	NSString	*isoCountryName;
	NSString	*isoCountryCode;
	NSString	*isoDialingCode;
	
	NSString	*currencyName;
	NSString	*currencyCode;
	NSString	*currencySymbol;

}
    - (id) initFromArray:(NSMutableArray *)csvRow;

@property (nonatomic, copy) NSString *currencyName;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, copy) NSString *currencySymbol;
@property (nonatomic, copy) NSString *isoCountryName;
@property (nonatomic, copy) NSString *isoCountryCode;
@property (nonatomic, copy) NSString *isoDialingCode;

@end
