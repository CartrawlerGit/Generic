//
//  CTCareNumber.h
//  CarTrawler
//
//

@interface CTCareNumber : NSObject {
	NSString	*isoCountryCode;
	NSString	*countryName;
	NSString	*careNumber;
}

@property (nonatomic, copy) NSString *isoCountryCode;
@property (nonatomic, copy) NSString *countryName;
@property (nonatomic, copy) NSString *careNumber;

- (id) initFromInfoDictionary:(NSDictionary *)dict;

@end
