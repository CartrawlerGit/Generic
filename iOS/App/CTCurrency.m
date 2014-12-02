//
//  CTCurrency.m
//  CarTrawler
//
//

#import "CTCurrency.h"

@implementation CTCurrency

@synthesize currencyName;
@synthesize currencyCode;
@synthesize currencyDisplayString;

- (id) initFromArray:(NSMutableArray *)csvRow {
	self.currencyName = [csvRow objectAtIndex:0];
	self.currencyCode = [csvRow objectAtIndex:1];
	self.currencyDisplayString = [NSString stringWithFormat:@"(%@) %@", self.currencyCode, self.currencyName];
	
	return self;
}

- (void)dealloc
{
	[currencyName release];
	[currencyCode release];
	[currencyDisplayString release];

	[super dealloc];
}

@end
