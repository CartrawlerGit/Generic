//
//  CTBookingResponseValidator.h
//  CarTrawler
//
//  Created by Igor Ferreira on 8/2/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTResponseValidator.h"

@class CTError;
@class Booking;

typedef void(^CTBookingResponseValidatorSuccess)(Booking *booking);
typedef void(^CTBookingResponseValidatorError)(NSArray *errors);

@interface CTBookingResponseValidator : NSObject <CTResponseValidator>

+ (id)validateResponseObject:(id)response;
+ (void)validateCompleteResponse:(id)response withSuccess:(CTBookingResponseValidatorSuccess)sucess andError:(CTBookingResponseValidatorError)error;

@end
