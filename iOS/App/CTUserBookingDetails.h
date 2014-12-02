//
//  CTUserBookingDetails.h
//  CarTrawler
//
//

#import <Foundation/Foundation.h>

@interface CTUserBookingDetails : NSObject {

	NSString *namePrefix;
	NSString *givenName;
	NSString *surname;
	NSString *phoneAreaCode;
	NSString *phoneNumber;
	NSString *emailAddress;
	NSString *address;
	NSString *countryCode;
	
	NSString *ccHolderName;
	NSString *ccNumber;
	NSString *ccExpDate;
	NSString *ccSeriesCode;
	NSInteger cardType;
	
}

@property (nonatomic,retain) NSString *namePrefix;
@property (nonatomic,retain) NSString *givenName;
@property (nonatomic,retain) NSString *surname;
@property (nonatomic,retain) NSString *phoneAreaCode;
@property (nonatomic,retain) NSString *phoneNumber;
@property (nonatomic,retain) NSString *emailAddress;
@property (nonatomic,retain) NSString *address;
@property (nonatomic,retain) NSString *countryCode;

@property (nonatomic,retain) NSString *ccHolderName;
@property (nonatomic,retain) NSString *ccNumber;
@property (nonatomic,retain) NSString *ccExpDate;
@property (nonatomic,retain) NSString *ccSeriesCode;
@property (nonatomic,assign) NSInteger cardType;


@end
