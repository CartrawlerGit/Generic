//
//  CTSearchFilters.h
//  CarTrawler
//

#import <Foundation/Foundation.h>

@interface CTSearchFilters : NSObject {
	NSInteger people;
	NSInteger fuel;
	NSInteger transmission;
	NSInteger airCon;
}

@property (nonatomic,assign) NSInteger people;
@property (nonatomic,assign) NSInteger fuel;
@property (nonatomic,assign) NSInteger transmission;
@property (nonatomic,assign) NSInteger airCon;

-(NSString*)getSeatingFilterPredicate;
-(NSString*)getFuelTypeFilterPredicate;
-(NSString*)getTransmissionTypeFilterPredicate;
-(NSString*)getAirConFilterPredicate;	
@end
