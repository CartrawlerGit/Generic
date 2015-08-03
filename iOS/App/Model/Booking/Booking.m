//
//  Booking.m
//  CarTrawler
//

#import "Booking.h"
#import "Fee+NSDictionary.h"
#import "CarTrawlerAppDelegate.h"
#import "CTCareNumber.h"

@implementation Booking

- (NSString *) getSupportNumber {
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSMutableArray *numbers = appDelegate.customerCareNumbers;
	
	NSString *ret = [NSString stringWithFormat:@""];
	
	for (CTCareNumber *c in numbers) {
		if ([c.isoCountryCode isEqualToString:self.locationCountryName]) {
			ret = c.careNumber;
            DLog(@"Ret (%@) equals Carenumber (%@)", ret, c.careNumber);
		}
	}
	if (ret) {
		return ret;
	} else {
		return @"No number available.";
	}	
}

// setLocationDetails: Takes a dictionary containing a 'light' CTLocation dictionary and adds it's attributes to this object.

- (void) setLocationDetails:(NSDictionary *)dict {
	self.isAtAirport = [[dict objectForKey:@"@AtAirport"] boolValue];
	self.locationCode = [dict objectForKey:@"@Code"];
	self.locationName = [dict objectForKey:@"@Name"];
	self.locationAddress = [[dict objectForKey:@"Address"] objectForKey:@"AddressLine"];
	self.locationCountryName = [[[dict objectForKey:@"Address"] objectForKey:@"CountryName"] objectForKey:@"@Code"];
	self.locationPhoneNumber = [[dict objectForKey:@"Telephone"] objectForKey:@"@PhoneNumber"];
	
	// Lat & Lon were added to support the mapping feature of the receipt.  They were added with a @Remark key in Address
	
	self.coordString = [[dict objectForKey:@"Address"] objectForKey:@"@Remark"];
	DLog(@"Returned support number is %@", [self getSupportNumber]);
	//self.supportNumber = [self getSupportNumber];
}

- (void) encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.wasRetrievedFromWeb forKey:@"wasRetrievedFromWeb"];
	[encoder encodeObject:self.customerGivenName forKey:@"customerGivenName"];
	[encoder encodeObject:self.customerSurname forKey:@"customerSurname"];
	[encoder encodeObject:self.customerEmail forKey:@"customerEmail"];
	
	[encoder encodeObject:self.confType forKey:@"confType"];
	[encoder encodeObject:self.confID forKey:@"confID"];
	
	[encoder encodeObject:self.vendorName forKey:@"vendorName"];
	[encoder encodeObject:self.vendorCode forKey:@"vendorCode"];
	[encoder encodeObject:self.vendorImageURL forKey:@"vendorImageURL"];
	
	[encoder encodeObject:self.puDateTime forKey:@"puDateTime"];
	[encoder encodeObject:self.doDateTime forKey:@"doDateTime"];
	[encoder encodeObject:self.puLocationCode forKey:@"puLocationCode"];
	[encoder encodeObject:self.doLocationCode forKey:@"doLocationCode"];
	[encoder encodeObject:self.puLocationName forKey:@"puLocationName"];
	[encoder encodeObject:self.doLocationName forKey:@"doLocationName"];
	
	//[encoder encodeObject:(id)self.vehIsAirConditioned forKey:@"vehIsAirConditioned"]; // BOOL

	[encoder encodeObject:self.vehTransmissionType forKey:@"vehTransmissionType"];
	[encoder encodeObject:self.vehFuelType forKey:@"vehFuelType"];
	[encoder encodeObject:self.vehDriveType forKey:@"vehDriveType"];
	[encoder encodeObject:self.vehPassengerQty forKey:@"vehPassengerQty"];
	[encoder encodeObject:self.vehBaggageQty forKey:@"vehBaggageQty"];
	[encoder encodeObject:self.vehCode forKey:@"vehCode"];
	[encoder encodeObject:self.vehCategory forKey:@"vehCategory"];
	[encoder encodeObject:self.vehDoorCount forKey:@"vehDoorCount"];
	[encoder encodeObject:self.vehClassSize forKey:@"vehClassSize"];
	[encoder encodeObject:self.vehMakeModelName forKey:@"vehMakeModelName"];
	[encoder encodeObject:self.vehMakeModelCode forKey:@"vehMakeModelCode"];
	[encoder encodeObject:self.vehPictureUrl forKey:@"vehPictureUrl"];
	[encoder encodeObject:self.vehAssetNumber forKey:@"vehAssetNumber"];
	
	// [encoder encodeObject:self.fees forKey:@"fees"]; // Array
	
	[encoder encodeObject:self.totalChargeAmount forKey:@"totalChargeAmount"];
	[encoder encodeObject:self.estimatedTotalAmount forKey:@"estimatedTotalAmount"];
	[encoder encodeObject:self.currencyCode forKey:@"currencyCode"];
	
	// TPA_Extensions
	
	[encoder encodeObject:self.tpaFeeAmount forKey:@"tpaFeeAmount"];
	[encoder encodeObject:self.tpaFeeCurrencyCode forKey:@"tpaFeeCurrencyCode"];
	[encoder encodeObject:self.tpaFeePurpose forKey:@"tpaFeePurpose"];
	[encoder encodeObject:self.tpaConfType forKey:@"tpaConfType"];
	[encoder encodeObject:self.tpaConfID forKey:@"tpaConfID"];
	
	// Payment Rules
	[encoder encodeObject:self.paymentRuleType forKey:@"paymentRuleType"];
	[encoder encodeObject:self.paymentAmount forKey:@"paymentAmount"];
	[encoder encodeObject:self.paymentCurrencyCode forKey:@"paymentCurrencyCode"];
	
	[encoder encodeObject:self.rentalPaymentTransactionCode forKey:@"rentalPaymentTransactionCode"];
	[encoder encodeObject:self.rentalPaymentCardType forKey:@"rentalPaymentCardType"];
	// There is more repitition of the payment in the payload here, i'm skipping over it.
	
	//[encoder encodeObject:(id)self.isAtAirport forKey:@"isAtAirport"];
	
	[encoder encodeObject:self.locationCode forKey:@"locationCode"];
	[encoder encodeObject:self.locationName forKey:@"locationName"];
	[encoder encodeObject:self.locationAddress forKey:@"locationAddress"];
	[encoder encodeObject:self.locationCountryName forKey:@"locationCountryName"];
	[encoder encodeObject:self.locationPhoneNumber forKey:@"locationPhoneNumber"];
	[encoder encodeObject:self.coordString forKey:@"coordString"];
	[encoder encodeObject:self.supportNumber forKey:@"supportNumber"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if( self != nil ) {
		self.wasRetrievedFromWeb = [decoder decodeObjectForKey:@"wasRetrievedFromWeb"];
		self.customerGivenName = [decoder decodeObjectForKey:@"customerGivenName"];
		self.customerSurname = [decoder decodeObjectForKey:@"customerSurname"];
		self.customerEmail = [decoder decodeObjectForKey:@"customerEmail"];
		self.confType = [decoder decodeObjectForKey:@"confType"];
		self.confID = [decoder decodeObjectForKey:@"confID"];
		
		self.vendorName = [decoder decodeObjectForKey:@"vendorName"];
		self.vendorCode = [decoder decodeObjectForKey:@"vendorCode"];
		self.vendorImageURL = [decoder decodeObjectForKey:@"vendorImageURL"];
		self.puDateTime = [decoder decodeObjectForKey:@"puDateTime"];
		self.doDateTime = [decoder decodeObjectForKey:@"doDateTime"];
		self.puLocationCode = [decoder decodeObjectForKey:@"puLocationCode"];
		self.doLocationCode = [decoder decodeObjectForKey:@"doLocationCode"];
		self.puLocationName = [decoder decodeObjectForKey:@"puLocationName"];
		self.doLocationName = [decoder decodeObjectForKey:@"doLocationName"];
		
		//self.vehIsAirConditioned = [decoder decodeObjectForKey:@"vehIsAirConditioned"]; // BOOL
		
		self.vehTransmissionType = [decoder decodeObjectForKey:@"vehTransmissionType"];
		self.vehFuelType = [decoder decodeObjectForKey:@"vehFuelType"];
		self.vehDriveType = [decoder decodeObjectForKey:@"vehDriveType"];
		self.vehPassengerQty = [decoder decodeObjectForKey:@"vehPassengerQty"];
		self.vehBaggageQty = [decoder decodeObjectForKey:@"vehBaggageQty"];
		self.vehCode = [decoder decodeObjectForKey:@"vehCode"];
		self.vehCategory = [decoder decodeObjectForKey:@"vehCategory"];
		self.vehDoorCount = [decoder decodeObjectForKey:@"vehDoorCount"];
		self.vehClassSize = [decoder decodeObjectForKey:@"vehClassSize"];
		self.vehMakeModelName = [decoder decodeObjectForKey:@"vehMakeModelName"];
		self.vehMakeModelCode = [decoder decodeObjectForKey:@"vehMakeModelCode"];
		self.vehPictureUrl = [decoder decodeObjectForKey:@"vehPictureUrl"];
		self.vehAssetNumber = [decoder decodeObjectForKey:@"vehAssetNumber"];
		
		self.fees = [decoder decodeObjectForKey:@"fees"]; // Array
		
		self.totalChargeAmount = [decoder decodeObjectForKey:@"totalChargeAmount"];
		self.estimatedTotalAmount = [decoder decodeObjectForKey:@"estimatedTotalAmount"];
		self.currencyCode = [decoder decodeObjectForKey:@"currencyCode"];
		
		self.tpaFeeAmount = [decoder decodeObjectForKey:@"tpaFeeAmount"];
		self.tpaFeeCurrencyCode = [decoder decodeObjectForKey:@"tpaFeeCurrencyCode"];
		self.tpaFeePurpose = [decoder decodeObjectForKey:@"tpaFeePurpose"];
		self.tpaConfType = [decoder decodeObjectForKey:@"tpaConfType"];
		self.tpaConfID = [decoder decodeObjectForKey:@"tpaConfID"];
		
		self.paymentRuleType = [decoder decodeObjectForKey:@"paymentRuleType"];
		self.paymentAmount = [decoder decodeObjectForKey:@"paymentAmount"];
		self.paymentCurrencyCode = [decoder decodeObjectForKey:@"paymentCurrencyCode"];
		
		self.rentalPaymentTransactionCode = [decoder decodeObjectForKey:@"rentalPaymentTransactionCode"];
		self.rentalPaymentCardType = [decoder decodeObjectForKey:@"rentalPaymentCardType"];
		
		//self.isAtAirport = [decoder decodeObjectForKey:@"isAtAirport"];
		
		self.locationCode = [decoder decodeObjectForKey:@"locationCode"];
		self.locationName = [decoder decodeObjectForKey:@"locationName"];
		self.locationAddress = [decoder decodeObjectForKey:@"locationAddress"];
		self.locationCountryName = [decoder decodeObjectForKey:@"locationCountryName"];
		self.locationPhoneNumber = [decoder decodeObjectForKey:@"locationPhoneNumber"];
		self.coordString = [decoder decodeObjectForKey:@"coordString"];
		self.supportNumber = [decoder decodeObjectForKey:@"supportNumber"];
    }
    return self;
}


@end
