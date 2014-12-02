//
//  CTAddressComponent.h
//  CarTrawler
//

#import <Foundation/Foundation.h>


@interface CTAddressComponent : NSObject {
	NSString *longName;
	NSString *shortName;
	NSArray *types;
}

@property (nonatomic, retain) NSString *longName;
@property (nonatomic, retain) NSString *shortName;
@property (nonatomic, retain) NSArray *types;

@end
