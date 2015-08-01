//
//  Booking+VehReservation.h
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "Booking.h"

@interface Booking (VehReservation)

- (id) initFromVehReservationDictionary:(NSDictionary *)vehReservationDictionary;

@end
