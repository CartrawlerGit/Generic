//
//  CTCountry+Coding.h
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTCountry.h"

@interface CTCountry (Coding) <NSCoding>

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
