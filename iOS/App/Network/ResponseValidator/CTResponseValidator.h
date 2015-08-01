//
//  CTResponseValidator.h
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#ifndef CarTrawler_CTResponseValidator_h
#define CarTrawler_CTResponseValidator_h

@protocol ResponseValidator <NSObject>

+ (id)validateResponseObject:(id)response;

@end

#endif
