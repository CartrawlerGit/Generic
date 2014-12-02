
#import "CTImageCacheObject.h"

@implementation CTImageCacheObject

@synthesize size;
@synthesize timeStamp;
@synthesize image;

- (id) initWithSize:(NSUInteger)sz Image:(UIImage*)anImage{
    if ((self = [super init])) {
        size = sz;
        timeStamp = [NSDate date];
        image = anImage;
    }
    return self;
}

- (void) resetTimeStamp {
    //[timeStamp release];
    timeStamp = [NSDate date];
}

- (void) dealloc {
    /*[timeStamp release];
    [image release];
    [super dealloc];*/
}

@end
