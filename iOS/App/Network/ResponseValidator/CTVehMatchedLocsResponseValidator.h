//
//  CTVehMatchedLocsResponseValidator.h
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTResponseValidator.h"

@interface CTVehMatchedLocsResponseValidator : NSObject <CTResponseValidator>

+ (id)validateResponseObject:(id)response;

@end
