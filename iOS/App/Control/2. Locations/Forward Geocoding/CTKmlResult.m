//
//  CTKmlResult.m
//  CarTrawler
//

#import "CTKmlResult.h"


@implementation CTKmlResult

@synthesize address, accuracy, countryNameCode, countryName, subAdministrativeAreaName, localityName, addressComponents;
@synthesize viewportSouthWestLat, viewportSouthWestLon, viewportNorthEastLat, viewportNorthEastLon;
@synthesize boundsSouthWestLat, boundsSouthWestLon, boundsNorthEastLat, boundsNorthEastLon, latitude, longitude;


- (CLLocationCoordinate2D) coordinate  {
	CLLocationCoordinate2D coordinate = {latitude, longitude};
	return coordinate;
}

- (MKCoordinateSpan) coordinateSpan {
	// Calculate the difference between north and south to create a
	// a span.
	float latitudeDelta = viewportNorthEastLat - viewportSouthWestLat;
	float longitudeDelta = viewportNorthEastLon - viewportSouthWestLon;
	
	MKCoordinateSpan spn = {latitudeDelta, longitudeDelta};
	
	return spn;
}

- (MKCoordinateRegion) coordinateRegion {
	MKCoordinateRegion region;
	region.center = self.coordinate;
	region.span = self.coordinateSpan;
	
	return region;
}

- (NSArray *) findAddressComponent:(NSString*)typeName {
	NSMutableArray *matchingComponents = [[NSMutableArray alloc] init];
	
	NSInteger components = [addressComponents count];
	for(int i = 0; i < components; i++) {
		
		CTAddressComponent *component = [addressComponents objectAtIndex:i];
		if(component.types != nil) {
			
			BOOL isMatch = NO;
			NSInteger typesCount = [component.types count];
			for(int j = 0; isMatch == NO && j < typesCount; j++) {
				
				NSString *type = [component.types objectAtIndex:j];
				
				if([type isEqualToString:typeName]) {
					[matchingComponents addObject:component];
					isMatch = YES;
				}
			}
		}
		
	}
	
	
	return matchingComponents;
}


@end
