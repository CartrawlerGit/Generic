//
//  CTGoogleV3KmlParser.h
//  CarTrawler
//

#import <Foundation/Foundation.h>
#import "CTKmlResult.h"
#import "CTAddressComponent.h"
#import "CTForwardGeocoder.h"

@interface CTGoogleV3KmlParser : NSObject <NSXMLParserDelegate> {
	NSMutableString *contentsOfCurrentProperty;
	int statusCode;
	NSMutableArray *results;
	NSMutableArray *addressComponents;
	NSMutableArray *typesArray;
	CTKmlResult *currentResult;
	CTAddressComponent *currentAddressComponent;
	BOOL ignoreAddressComponents;
	BOOL isLocation;
	BOOL isViewPort;
	BOOL isBounds;
	BOOL isSouthWest;
}

@property (nonatomic, readonly) int statusCode;
@property (nonatomic, readonly) NSMutableArray *results;

- (BOOL)parseXMLFileAtURL:(NSURL *)URL 
			   parseError:(NSError **)error 
			   ignoreAddressComponents:(BOOL)ignore;


@end
