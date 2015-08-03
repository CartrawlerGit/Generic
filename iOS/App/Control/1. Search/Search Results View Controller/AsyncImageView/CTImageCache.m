
#import "CTImageCache.h"
#import "CTImageCacheObject.h"

@interface CTImageCache()

@property (nonatomic, assign) NSUInteger maxSize;    // maximum capacity
@property (nonatomic, strong) NSMutableDictionary *myDictionary;

@end

@implementation CTImageCache

- (id) initWithMaxSize:(NSUInteger) max  {
    if ((self = [super init])) {
        _totalSize = 0;
        _maxSize = max;
        _myDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) insertImage:(UIImage*)image withSize:(NSUInteger)sz forKey:(NSString*)key{
    CTImageCacheObject *object = [[CTImageCacheObject alloc] initWithSize:sz Image:image];
    while (self.totalSize + sz > self.maxSize) {
        NSDate *oldestTime;
        NSString *oldestKey;
        for (NSString *key in [self.myDictionary allKeys]) {
            CTImageCacheObject *obj = [self.myDictionary objectForKey:key];
            if (oldestTime == nil || [obj.timeStamp compare:oldestTime] == NSOrderedAscending) {
                oldestTime = obj.timeStamp;
                oldestKey = key;
            }
        }
        if (oldestKey == nil) 
            break; // shoudn't happen
        CTImageCacheObject *obj = [self.myDictionary objectForKey:oldestKey];
        _totalSize -= obj.size;
        [self.myDictionary removeObjectForKey:oldestKey];
    }
    [self.myDictionary setObject:object forKey:key];
    //[object release];
}

- (UIImage*) imageForKey:(NSString*)key {
    CTImageCacheObject *object = [self.myDictionary objectForKey:key];
    if (object == nil)
        return nil;
    [object resetTimeStamp];
    return object.image;
}

@end
