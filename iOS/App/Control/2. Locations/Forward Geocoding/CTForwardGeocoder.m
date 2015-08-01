//
//  CTForwardGeocoder.h
//  CarTrawler
//

#import "CTForwardGeocoder.h"


@implementation CTForwardGeocoder

@synthesize searchQuery, status, results, delegate;

- (id) initWithDelegate:(id<CTForwardGeocoderDelegate>)del {
	self = [super init];
	
	if (self != nil) {
		delegate = del;
	}
	return self;
}

- (void) findLocation:(NSString *)searchString {
	// store the query
	self.searchQuery = searchString;
	
	[self performSelectorInBackground:@selector(startGeocoding) withObject:nil];
}

- (void) startGeocoding {
	@autoreleasepool {
		int version = 3;
		NSLog(@"API 3");
		NSError *parseError = nil;
		
		if(version == 2) {
			// Create the url to Googles geocoding API, we want the response to be in XML
			
        NSString* mapsUrl = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps/geo?q=%@&gl=se&output=xml&oe=utf8&sensor=false", searchQuery];
			
       
			// Create the url object for our request. It's important to escape the 
			// search string to support spaces and international characters
			NSURL *url = [[NSURL alloc] initWithString:[mapsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			
			// Run the KML parser
			CTGoogleV2KmlParser *parser = [[CTGoogleV2KmlParser alloc] init];
			
			[parser parseXMLFileAtURL:url parseError:&parseError];
			
			
			status = parser.statusCode;
			
			// If the query was successfull we store the array with results
			if(parser.statusCode == G_GEO_SUCCESS) {
				self.results = parser.placemarks;
			}
			
			
		}
		else if(version == 3) {
			// Create the url to Googles geocoding API, we want the response to be in XML
			NSString *mapsUrl = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps/api/geocode/xml?address=%@&sensor=false", searchQuery];
			 NSLog(@"searchQuery = %@", searchQuery);
			// Create the url object for our request. It's important to escape the 
			// search string to support spaces and international characters
			NSURL *url = [[NSURL alloc] initWithString:[mapsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			
			// Run the KML parser
			CTGoogleV3KmlParser *parser = [[CTGoogleV3KmlParser alloc] init];
			
			[parser parseXMLFileAtURL:url parseError:&parseError ignoreAddressComponents:NO];
			
			
			status = parser.statusCode;
			
			// If the query was successfull we store the array with results
			if(parser.statusCode == G_GEO_SUCCESS) {
				self.results = parser.results;
			}
			
		}
		
		if(parseError != nil) {
			if([delegate respondsToSelector:@selector(forwardGeocoderError:)]) {
				[delegate performSelectorOnMainThread:@selector(forwardGeocoderError:) withObject:[parseError localizedDescription] waitUntilDone:NO];
			}
		}
		else {
			if([delegate respondsToSelector:@selector(forwardGeocoderFoundLocation)]) {
				[delegate performSelectorOnMainThread:@selector(forwardGeocoderFoundLocation) withObject:nil waitUntilDone:NO];
			}		
		}
	
	}
	
	DLog(@"Found placemarks: %lu", (unsigned long)[self.results count]);
	
}



@end
