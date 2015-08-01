//
//  Booking+VehReservation.m
//  CarTrawler
//
//  Created by Igor Ferreira on 8/1/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "Booking+VehReservation.h"
#import "Fee+NSDictionary.h"

@interface Booking (Private)

- (void) setLocationDetails:(NSDictionary *)dict;

@end

@implementation Booking (VehReservation)

- (id) initFromVehReservationDictionary:(NSDictionary *)vehReservationDictionary {
	
	self.customerGivenName = [[[[vehReservationDictionary objectForKey:@"Customer"] objectForKey:@"Primary"] objectForKey:@"PersonName"] objectForKey:@"GivenName"];
	self.customerSurname = [[[[vehReservationDictionary objectForKey:@"Customer"] objectForKey:@"Primary"] objectForKey:@"PersonName"] objectForKey:@"Surname"];
	
	self.confType = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"ConfID"] objectForKey:@"@Type"];
	self.confID = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"ConfID"] objectForKey:@"@ID"];
	
	self.vendorName = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vendor"] objectForKey:@"@CompanyShortName"];
	self.vendorCode = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vendor"] objectForKey:@"@Code"];
	
	self.puDateTime = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"@PickUpDateTime"];
	//self.doDateTime = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"@ReturnUpDateTime"];
	self.doDateTime = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"@ReturnDateTime"];
	
	self.puLocationCode = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"PickUpLocation"] objectForKey:@"@LocationCode"];
	self.puLocationName = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"PickUpLocation"] objectForKey:@"@Name"];
	
	self.doLocationCode = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"ReturnLocation"] objectForKey:@"@LocationCode"];
	self.doLocationName = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"VehRentalCore"] objectForKey:@"ReturnLocation"] objectForKey:@"@Name"];
	
	// Vehicle
	
	self.vehIsAirConditioned = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"@AirConditionInd"] boolValue];
	self.vehTransmissionType = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"@TransmissionType"];
	self.vehFuelType = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"@FuelType"];
	self.vehDriveType = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"@DriveType"];
	self.vehPassengerQty = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"@PassengerQuantity"];
	self.vehBaggageQty = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"@BaggageQuantity"];
	self.vehCode = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"@Code"];
	self.vehCategory = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"VehType"] objectForKey:@"@VehicleCategory"];
	self.vehDoorCount = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"VehType"] objectForKey:@"@DoorCount"];
	self.vehClassSize = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"VehClass"] objectForKey:@"@Size"];
	self.vehMakeModelName = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"VehMakeModel"] objectForKey:@"@Name"];
	self.vehMakeModelCode = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"VehMakeModel"] objectForKey:@"@Code"];
	self.vehPictureUrl = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"PictureURL"];
	self.vehAssetNumber = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Vehicle"] objectForKey:@"VehIdentity"] objectForKey:@"@VehicleAssetNumber"];
	
	// Fees
	
	self.fees = [[NSMutableArray alloc] init];
	NSMutableArray *tempFees = [[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"Fees"];
	for (int i = 0; i < [tempFees count]; i++) {
		Fee *f = [Fee feeWithDictionary:[tempFees objectAtIndex:i]];
		[self.fees addObject:f];
	}
	
	// Total Charge
	
	self.totalChargeAmount = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TotalCharge"] objectForKey:@"@RateTotalAmount"];
	self.estimatedTotalAmount = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TotalCharge"] objectForKey:@"@EstimatedTotalAmount"];
	self.currencyCode = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TotalCharge"] objectForKey:@"@CurrencyCode"];
	
	// TPA Extensions
	
	self.tpaFeeAmount = [[[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"Fees"] objectForKey:@"Fee"] objectForKey:@"@Amount"];
	self.tpaFeeCurrencyCode = [[[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"Fees"] objectForKey:@"Fee"] objectForKey:@"@CurrencyCode"];
	self.tpaFeePurpose = [[[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"Fees"] objectForKey:@"Fee"] objectForKey:@"@Purpose"];
	
	if ([[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"ConfID"] isKindOfClass:[NSArray class]]) {
		
		NSDictionary *confDict = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"ConfID"] objectAtIndex:0];
		self.tpaConfType = [confDict objectForKey:@"@Type"];
		self.tpaConfID = [confDict objectForKey:@"@ID"];
		
		//self.tpaConfType = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"ConfID"] objectForKey:@"@Type"];
		//self.tpaConfID = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"ConfID"] objectForKey:@"@ID"];
		
	} else {
		if ([[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"ConfID"]) {
			self.tpaConfType = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"ConfID"] objectForKey:@"@Type"];
			self.tpaConfID = [[[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"ConfID"] objectForKey:@"@ID"];
		}
	}
	
	
	
	
	self.vendorBookingRef = self.tpaConfID;
	
	if ([[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"VendorPictureURL"]) {
		self.vendorImageURL = [[[vehReservationDictionary objectForKey:@"VehSegmentCore"] objectForKey:@"TPA_Extensions"] objectForKey:@"VendorPictureURL"];
	}
	
	// Payment Rules
	
	self.paymentRuleType = [[[[vehReservationDictionary objectForKey:@"VehSegmentInfo"] objectForKey:@"PaymentRules"] objectForKey:@"PaymentRule"] objectForKey:@"@RuleType"];
	self.paymentAmount = [[[[vehReservationDictionary objectForKey:@"VehSegmentInfo"] objectForKey:@"PaymentRules"] objectForKey:@"PaymentRule"] objectForKey:@"@Amount"];
	self.paymentCurrencyCode = [[[[vehReservationDictionary objectForKey:@"VehSegmentInfo"] objectForKey:@"PaymentRules"] objectForKey:@"PaymentRule"] objectForKey:@"@CurrencyCode"];
	
	self.rentalPaymentTransactionCode = [[[vehReservationDictionary objectForKey:@"VehSegmentInfo"] objectForKey:@"RentalPaymentAmount"] objectForKey:@"@PaymentTransactionTypeCode"];
	self.rentalPaymentCardType = [[[[vehReservationDictionary objectForKey:@"VehSegmentInfo"] objectForKey:@"RentalPaymentAmount"] objectForKey:@"PaymentCard"] objectForKey:@"@CardType"];
	
	/* Locations Details
	 There are two ways this go down;
	 
	 1. The pickup point and dropoff point are the same, in which case it gets returned to us as a single dictionary full of attributes.
	 2. The pickup and drop off points are different, so we get an array with two different locations back.
	 
	 We could init these both as CTLocations but I haven't designed this to persist objects so we'll have to be more verbose and deal with individual items.
	 Also worth noting here that the alternate drop off point means nothing to the app in terms of UI or receipt, so we don't need to store it at this point BUT
	 we do need the pickup details, so, lets test for Dict or Array and then parse the required section of the response.
	 
	 */
	
	if ([[[vehReservationDictionary objectForKey:@"VehSegmentInfo"] objectForKey:@"LocationDetails"] isKindOfClass:[NSArray class]]) {
		[self setLocationDetails:[[[vehReservationDictionary objectForKey:@"VehSegmentInfo"] objectForKey:@"LocationDetails"] objectAtIndex:0]];
	} else {
		[self setLocationDetails:[[vehReservationDictionary objectForKey:@"VehSegmentInfo"] objectForKey:@"LocationDetails"]];
	}
	
	return self;
}

@end