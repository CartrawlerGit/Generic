//
//  CTBookingRequester.h
//  CarTrawler
//
//  Created by Igor Ferreira on 8/2/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTRequester.h"

@interface CTBookingRequester : CTRequester

+ (ASIHTTPRequest *) requestBookingWithEmail:(NSString *)bookingEmail bookingId:(NSString *)bookingId andDelegate:(id<ASIHTTPRequestDelegate>)delegate;

@end
