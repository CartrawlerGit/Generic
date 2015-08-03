//
//  CTVehMatchedLocsResponseValidator.m
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTVehMatchedLocsResponseValidator.h"
#import "CTLocation.h"

@implementation CTVehMatchedLocsResponseValidator

+ (id)validateResponseObject:(id)response
{
	DLog(@"VehMatchedLocsRS.");
	if ([[response objectForKey:@"VehMatchedLocs"] isKindOfClass:[NSArray class]])
	{
		
		// Need to check for arrays of zero length, some lat/long configurations can produce this
		
		if ([[response objectForKey:@"VehMatchedLocs"] count] == 0)
		{
			[CTHelper showAlert:@"No Results Found" message:@"No Results have been found for this area, please try again."];
			return nil;
		}
		else
		{
			return [self vehMatchedLocs:[response objectForKey:@"VehMatchedLocs"]];
		}
	}
	else
	{
		NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:1];
		CTLocation *loc = [[CTLocation alloc] initFromDictionary:[[response objectForKey:@"VehMatchedLocs"] objectForKey:@"VehMatchedLoc"]];
		[locations addObject:loc];
		return locations;
	}
}

+ (NSMutableArray *) vehMatchedLocs:(NSDictionary *) locations {
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	for (NSDictionary *aDict in locations)
	{
		CTLocation *loc = [[CTLocation alloc] initFromDictionary:aDict];
		[array addObject:loc];
	}
	return array;
}

@end
