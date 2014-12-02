//
//  CTSearchDefaults.h
//  CarTrawler
//
//

#import <Foundation/Foundation.h>


@interface CTSearchDefaults : NSObject {
	NSString* lastPickupLocation;
	NSString* lastDropoffLocation;
	NSString* lastPickupDate;
	NSString* lastDropoffDate;
	NSString* lastAge;
}

@property (nonatomic,retain) NSString* lastPickupLocation;
@property (nonatomic,retain) NSString* lastDropoffLocation;
@property (nonatomic,retain) NSString* lastPickupDate;
@property (nonatomic,retain) NSString* lastDropoffDate;
@property (nonatomic,retain) NSString* lastAge;


@end
