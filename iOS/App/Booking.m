//
//  Booking.m
//  CarTrawler
//

#import "Booking.h"
#import "Fee+NSDictionary.h"
#import "CarTrawlerAppDelegate.h"
#import "CTCareNumber.h"

@implementation Booking

@synthesize wasRetrievedFromWebBOOL;
@synthesize wasRetrievedFromWeb;
@synthesize supportNumber;
@synthesize vendorImageURL;
@synthesize vendorBookingRef;
@synthesize coordString;
@synthesize customerEmail;
@synthesize vehIsAirConditioned;
@synthesize customerGivenName;
@synthesize customerSurname;
@synthesize confType;
@synthesize confID;
@synthesize vendorName;
@synthesize vendorCode;
@synthesize puDateTime;
@synthesize doDateTime;
@synthesize puLocationCode;
@synthesize doLocationCode;
@synthesize puLocationName;
@synthesize doLocationName;
@synthesize vehTransmissionType;
@synthesize vehFuelType;
@synthesize vehDriveType;
@synthesize vehPassengerQty;
@synthesize vehBaggageQty;
@synthesize vehCode;
@synthesize vehCategory;
@synthesize vehDoorCount;
@synthesize vehClassSize;
@synthesize vehMakeModelName;
@synthesize vehMakeModelCode;
@synthesize vehPictureUrl;
@synthesize vehAssetNumber;
@synthesize fees; // Array
@synthesize totalChargeAmount;
@synthesize estimatedTotalAmount;
@synthesize currencyCode;
@synthesize tpaFeeAmount;
@synthesize tpaFeeCurrencyCode;
@synthesize tpaFeePurpose;
@synthesize tpaConfType;
@synthesize tpaConfID;
@synthesize paymentRuleType;
@synthesize paymentAmount;
@synthesize paymentCurrencyCode;
@synthesize rentalPaymentTransactionCode;
@synthesize rentalPaymentCardType;
@synthesize isAtAirport;
@synthesize locationCode;
@synthesize locationName;
@synthesize locationAddress;
@synthesize locationCountryName;
@synthesize locationPhoneNumber;

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
		Fee *f = [Fee initWithDictionary:[tempFees objectAtIndex:i]];
		[fees addObject:f];
		[f release];
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

- (void) dealloc {
	[customerGivenName release];
	[customerSurname release];
	[confType release];
	[confID release];
	[vendorName release];
	[vendorCode release];
	[puDateTime release];
	[doDateTime release];
	[puLocationCode release];
	[doLocationCode release];
	[puLocationName release];
	[doLocationName release];
	[vehTransmissionType release];
	[vehFuelType release];
	[vehDriveType release];
	[vehPassengerQty release];
	[vehBaggageQty release];
	[vehCode release];
	[vehCategory release];
	[vehDoorCount release];
	[vehClassSize release];
	[vehMakeModelName release];
	[vehMakeModelCode release];
	[vehPictureUrl release];
	[vehAssetNumber release];
	[fees release];
	[totalChargeAmount release];
	[estimatedTotalAmount release];
	[currencyCode release];
	[tpaFeeAmount release];
	[tpaFeeCurrencyCode release];
	[tpaFeePurpose release];
	[tpaConfType release];
	[tpaConfID release];
	[paymentRuleType release];
	[paymentAmount release];
	[paymentCurrencyCode release];
	[rentalPaymentTransactionCode release];
	[rentalPaymentCardType release];
	[locationCode release];
	[locationName release];
	[locationAddress release];
	[locationCountryName release];
	[locationPhoneNumber release];
	[customerEmail release];
	[coordString release];

	[vendorBookingRef release];
	vendorBookingRef = nil;

	[vendorImageURL release];
	vendorImageURL = nil;
	[supportNumber release];
	supportNumber = nil;
	[super dealloc];
}

@end
