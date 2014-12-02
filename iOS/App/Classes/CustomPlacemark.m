
#import "CustomPlacemark.h"


@implementation CustomPlacemark
@synthesize title, message, coordinate, coordinateRegion;

-(id)initWithRegion:(MKCoordinateRegion) coordRegion {
	self = [super init];
	
	if (self != nil) {
		coordinate = coordRegion.center;
		coordinateRegion = coordRegion;
	}
	
	return self;
}

- (void)dealloc {
    /*
	if(title != nil){
		[title release];
	}
	if(message != nil){
		[message release];
	}
	
	
	[super dealloc];
     */
}
@end
