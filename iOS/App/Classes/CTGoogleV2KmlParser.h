//
//  CTGoogleV2KmlParser.h
//  CarTrawler
//

#import <Foundation/Foundation.h>
#import "CTKmlResult.h"

@interface CTGoogleV2KmlParser : NSObject <NSXMLParserDelegate>{
	NSMutableString *contentsOfCurrentProperty;
	int statusCode;
	NSString *name;
	NSMutableArray *placemarkArray;
	CTKmlResult *currentPlacemark;
	
}

@property (nonatomic, readonly) int statusCode;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, readonly) NSMutableArray *placemarks;

- (BOOL)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error;

@end
