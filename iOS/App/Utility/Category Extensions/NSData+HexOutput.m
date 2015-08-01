
#import "NSData+HexOutput.h"


@implementation NSData (HexOutput)
-(NSString *) hexadecimalString {
	unsigned char *bytes = (unsigned char *)[self bytes];
	
	NSMutableString *ret = [NSMutableString stringWithCapacity:[self length]*2];
	for(int i = 0; i < [self length]; i++) {
		[ret appendFormat:@"%02x", bytes[i]];
	}
	return ret;
}
@end
