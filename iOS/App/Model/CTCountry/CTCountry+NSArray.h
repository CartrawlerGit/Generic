//
//  CTCountry+NSArray.h
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTCountry.h"

@interface CTCountry (NSArray)

+ (instancetype) countryFromArray:(NSMutableArray *)csvRow;

@end
