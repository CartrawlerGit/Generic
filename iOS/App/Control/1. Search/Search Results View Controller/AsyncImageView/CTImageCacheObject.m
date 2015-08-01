
#import "CTImageCacheObject.h"

@implementation CTImageCacheObject

- (id) initWithSize:(NSUInteger)sz Image:(UIImage*)anImage{
    if ((self = [super init])) {
        _size = sz;
        _timeStamp = [NSDate date];
        _image = anImage;
    }
    return self;
}

- (void) resetTimeStamp {
    _timeStamp = [NSDate date];
}

@end
