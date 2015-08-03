//
//  CTError+ResponseValidator.m
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTError+ResponseValidator.h"

@implementation CTError (ResponseValidator)

+ (id)validateResponseObject:(id)response
{
	if ([[response objectForKey:@"Errors"] isKindOfClass:[NSArray class]]) {
		NSArray *errors = (NSArray *)[response objectForKey:@"Errors"];
		return  [self handleMultipleErrors:errors];
	}
	
	id errors = [[response objectForKey:@"Errors"] objectForKey:@"Error"];
	
	if ([errors isKindOfClass:[NSDictionary class]]) {
		return [self handleSingleError:errors];
	}
	
	if ([errors isKindOfClass:[NSArray class]]) {
		return [self handleMultipleErrors:errors];
	}
	
	return nil;
}

+ (NSArray *)handleSingleError:(NSDictionary *)response
{
	DLog(@"There is only one error");
	return @[[[CTError alloc] initFromErrorRS:[response objectForKey:@"Error"]]];
}

+ (NSArray *)handleMultipleErrors:(NSArray *)errors
{
	DLog(@"There is more than one error");
	NSMutableArray *actualErrors = [[NSMutableArray alloc] initWithCapacity:errors.count];
	for (NSDictionary *dict in errors) {
		[actualErrors addObject:[[CTError alloc] initFromErrorRS:dict]];
	}
	return [NSArray arrayWithArray:actualErrors];
}

@end
