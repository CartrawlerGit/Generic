
#import "CTTableViewAsyncImageView.h"
#import "CTImageCacheObject.h"
#import "CTImageCache.h"

static CTImageCache *imageCache = nil;

@implementation CTTableViewAsyncImageView


- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.opaque = NO;
		self.backgroundColor = nil;
    }
    return self;
}

- (void) drawRect:(CGRect)rect {
    // Drawing code
}

- (void) dealloc {
    [connection cancel];
}

- (void) loadImageFromURL:(NSURL*)url {
    if (connection != nil) {
        [connection cancel];
        connection = nil;
    }
    if (data != nil) {
        data = nil;
    }
    
    if (imageCache == nil) // lazily create image cache
        imageCache = [[CTImageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
	
    urlString = [[url absoluteString] copy];
    UIImage *cachedImage = [imageCache imageForKey:urlString];
    if (cachedImage != nil) {
        if ([[self subviews] count] > 0) {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:cachedImage];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];
        imageView.frame = self.bounds;
        [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
        [self setNeedsLayout];
        return;
    }
    
	#define SPINNY_TAG 5555   
    
    UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinny.tag = SPINNY_TAG;
    spinny.frame = CGRectMake(floor((self.bounds.size.width-spinny.frame.size.width)/2), floor((self.bounds.size.height-spinny.frame.size.height)/2), spinny.frame.size.width, spinny.frame.size.height);
    [spinny startAnimating];
    [self addSubview:spinny];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)aConnection {
    connection = nil;
    
    UIView *spinny = [self viewWithTag:SPINNY_TAG];
    [spinny removeFromSuperview];
    
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    UIImage *image = [UIImage imageWithData:data];
    
    [imageCache insertImage:image withSize:[data length] forKey:urlString];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
    [self setNeedsLayout];
	
    data = nil;
}

@end
