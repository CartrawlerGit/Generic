//
//  CTError.h
//  CarTrawler
//
//

@interface CTError : NSObject {
	NSString *errorType;
	NSString *errorShortTxt;
	NSString *errorTxt;
}

@property (nonatomic, copy) NSString *errorType;
@property (nonatomic, copy) NSString *errorShortTxt;
@property (nonatomic, copy) NSString *errorTxt;

- (id) initFromErrorRS:(NSDictionary *)err;

@end
