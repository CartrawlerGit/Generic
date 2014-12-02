
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomPlacemark : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	MKCoordinateRegion coordinateRegion;
	NSString *title;
	NSString *message;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) MKCoordinateRegion coordinateRegion;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSString *message;

-(id)initWithRegion:(MKCoordinateRegion) coordRegion;
@end
