//
//  CTError+ResponseValidator.h
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTError.h"
#import "CTResponseValidator.h"

@interface CTError (ResponseValidator) <CTResponseValidator>

+ (id)validateResponseObject:(id)response;

@end
