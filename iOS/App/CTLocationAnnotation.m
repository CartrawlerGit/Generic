//
//  CTLocationAnnotation.m
//  CarTrawler
//
//

#import "CTLocationAnnotation.h"

@implementation CTLocationAnnotation

@synthesize ctCodeID = _ctCodeID;
@synthesize coordinate = _coordinate; 
@synthesize title = _title; 
@synthesize subtitle = _subtitle;
@synthesize type = _type;
@synthesize icon = _icon;

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate 
{ 
	return [[[self class] alloc] initWithCoordinate:coordinate];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate 
{ 
	self = [super init]; 
	if(nil != self) {
		self.coordinate = coordinate;
		//self.icon = @"marker.png";
	}
	return self;
} 

@end
