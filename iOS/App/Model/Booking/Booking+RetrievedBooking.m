//
//  Booking+RetrievedBooking.m
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "Booking+RetrievedBooking.h"

@interface Booking (Private)

- (void) setLocationDetails:(NSDictionary *)dict;

@end

@implementation Booking (RetrievedBooking)

/*
 * - (id) initFromRetrievedBookingDictionary:(NSDictionary *)vehReservationDictionary
 *
 *	This is used for taking a response for a web booking and populating it within the app.
 *  Booking responses are different, so the parser must be too.
 */

- (id) initFromRetrievedBookingDictionary:(NSDictionary *)vehReservationDictionary {
	
	self.wasRetrievedFromWeb = @"YES";
	self.wasRetrievedFromWebBOOL = YES;
	
	self.customerGivenName = [[[[vehReservationDictionary objectForKey:@"Customer"] objectForKey:@"Primary"] objectForKey:@"PersonName"] objectForKey:@"GivenName"];
	self.customerSurname = [[[[vehReservationDictionary objectForKey:@"Customer"] objectForKey:@"Primary"] objectForKey:@"PersonName"] objectForKey:@"Surname"];
	
	if ([[[vehReservationDictionary objectForKey:@"VehSegmentInfo"] objectForKey:@"LocationDetails"] isKindOfClass:[NSArray class]]) {
		[self setLocationDetails:[[[vehReservationDictionary objectForKey:@"VehSegmentInfo"] objectForKey:@"LocationDetails"] objectAtIndex:0]];
	} else {
		[self setLocationDetails:[[vehReservationDictionary objectForKey:@"VehSegmentInfo"] objectForKey:@"LocationDetails"]];
	}
	
	self.vendorName = [[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vendor"];
	
	if ([[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"ConfId"] isKindOfClass:[NSArray class]]) {
		NSDictionary *resid = [NSDictionary dictionaryWithDictionary:[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"ConfId"] objectAtIndex:0]];
		self.confID = [resid objectForKey:@"@ID"];
		
		NSDictionary *ctid = [NSDictionary dictionaryWithDictionary:[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"ConfId"] objectAtIndex:1]];
		self.tpaConfID = [ctid objectForKey:@"@ID"];
	} else {
		// Will need some observations to decided on a catch for this
		self.tpaConfID = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"ConfId"] objectForKey:@"@ID"];
		self.confID = @"Unavailable";
	}
	
	self.vendorName = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vendor"] objectForKey:@"@CompanyShortName"];
	self.vendorCode = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vendor"] objectForKey:@"@Code"];
	
	self.puDateTime = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"@PickUpDateTime"];
	//self.doDateTime = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"@ReturnUpDateTime"];
	self.doDateTime = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"@ReturnDateTime"];
	
	self.puLocationCode = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"PickUpLocation"] objectForKey:@"@LocationCode"];
	self.puLocationName = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"PickUpLocation"] objectForKey:@"@Name"];
	
	self.doLocationCode = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"ReturnLocation"] objectForKey:@"@LocationCode"];
	self.doLocationName = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"ReturnLocation"] objectForKey:@"@Name"];
	
	if ([[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"VendorPictureURL"]) {
		self.vendorImageURL = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"VendorPictureURL"];
	}
	
	return self;
}

@end
