//
//  CTLocationAnnotation.h
//  CarTrawler
//
//

@interface CTLocationAnnotation : NSObject <MKAnnotation> 
{ 
	NSString *_ctCodeID;
	CLLocationCoordinate2D _coordinate;
	NSString *_title;
	NSString *_subtitle;
	NSString *_type;
	NSString *_icon;
}

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate; 
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@property (nonatomic, copy) NSString *ctCodeID;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *icon;

@end
