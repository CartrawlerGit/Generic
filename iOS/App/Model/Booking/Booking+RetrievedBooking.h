//
//  Booking+RetrievedBooking.h
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "Booking.h"

@interface Booking (RetrievedBooking)

- (id) initFromRetrievedBookingDictionary:(NSDictionary *)dict;

@end