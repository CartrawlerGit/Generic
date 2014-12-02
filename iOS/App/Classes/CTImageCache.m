
#import "CTImageCache.h"
#import "CTImageCacheObject.h"

@implementation CTImageCache

@synthesize totalSize;

- (id) initWithMaxSize:(NSUInteger) max  {
    if ((self = [super init])) {
        totalSize = 0;
        maxSize = max;
        myDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) dealloc {
    /*[myDictionary release];
    [super dealloc];*/
}

- (void) insertImage:(UIImage*)image withSize:(NSUInteger)sz forKey:(NSString*)key{
    CTImageCacheObject *object = [[CTImageCacheObject alloc] initWithSize:sz Image:image];
    while (totalSize + sz > maxSize) {
        NSDate *oldestTime;
        NSString *oldestKey;
        for (NSString *key in [myDictionary allKeys]) {
            CTImageCacheObject *obj = [myDictionary objectForKey:key];
            if (oldestTime == nil || [obj.timeStamp compare:oldestTime] == NSOrderedAscending) {
                oldestTime = obj.timeStamp;
                oldestKey = key;
            }
        }
        if (oldestKey == nil) 
            break; // shoudn't happen
        CTImageCacheObject *obj = [myDictionary objectForKey:oldestKey];
        totalSize -= obj.size;
        [myDictionary removeObjectForKey:oldestKey];
    }
    [myDictionary setObject:object forKey:key];
    //[object release];
}

- (UIImage*) imageForKey:(NSString*)key {
    CTImageCacheObject *object = [myDictionary objectForKey:key];
    if (object == nil)
        return nil;
    [object resetTimeStamp];
    return object.image;
}

@end
