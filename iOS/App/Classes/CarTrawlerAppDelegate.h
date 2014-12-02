//
//  CarTrawlerAppDelegate.h
//  CarTrawler
//
#import "CTCountry.h"

@interface CarTrawlerAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, ASIHTTPRequestDelegate>  {
    UIWindow			*window;
    UITabBarController	*tabBarController;
	
	NSMutableArray		*preloadedCountryList;
	NSMutableArray		*preloadedCurrencyList;
	
	NSString			*countryCode;
    CTCountry           *ctCountry;
	
	NSMutableArray		*customerCareNumbers;
	NSDictionary		*infoJSON;
	
	// General App Control from the INFO.json
	
	BOOL				canAmendBookings;
	NSString			*amendBookingsLink;
	NSMutableArray		*insuranceRegions;
	NSString			*engineConditionsURL;
	NSString			*companyName;
	NSString			*clientID;
    UIColor             *governingTintColor;
}

- (NSString *) getSupportNumber;

@property (nonatomic, retain) UIColor *governingTintColor, *barTintColor;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *amendBookingsLink;
@property (nonatomic, copy) NSString *engineConditionsURL;
@property (nonatomic, retain) NSMutableArray *insuranceRegions;
@property (nonatomic, assign) BOOL canAmendBookings;

@property (nonatomic, copy) NSDictionary *infoJSON;

@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, retain) NSMutableArray *customerCareNumbers;
@property (nonatomic, retain) NSMutableArray *preloadedCountryList;
@property (nonatomic, retain) NSMutableArray *preloadedCurrencyList;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
