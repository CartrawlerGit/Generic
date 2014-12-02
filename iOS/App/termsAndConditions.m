//
//  termsAndConditions.m
//  CarTrawler
//

#import "termsAndConditions.h"


@implementation termsAndConditions

@synthesize titleText;
@synthesize bodyText;
@synthesize arrayBodyText;


- (void)dealloc 
{
	[titleText release];
	[bodyText release];
	[arrayBodyText release];
	[super dealloc];
}

- (id)initFromDictionary:(NSDictionary *)TQ_Dictionary
{
	self.titleText = [[NSMutableString alloc] init];
	self.bodyText = [[NSMutableString alloc] init];
	
	self.titleText = [TQ_Dictionary objectForKey:@"@Title"];

	if ([[TQ_Dictionary objectForKey:@"Paragraph"] isKindOfClass:[NSArray class]]) 
	{
		self.arrayBodyText = [NSMutableArray arrayWithArray: [TQ_Dictionary objectForKey:@"Paragraph"]];
		
		for (int x=0; x<[self.arrayBodyText count]; x++)
		{
			self.bodyText = [[[self.arrayBodyText componentsJoinedByString:@""] mutableCopy] autorelease];
		}
	}

	else if ([[TQ_Dictionary objectForKey:@"Paragraph"] isKindOfClass:[NSString class]]) 
	{
		self.bodyText = [TQ_Dictionary objectForKey:@"Paragraph"];
	}
	else 
	{
		return nil;
	}

	return self;
}
@end
