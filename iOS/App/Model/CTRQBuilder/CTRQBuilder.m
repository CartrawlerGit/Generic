//
//  CTRQBuilder.m
//  CarTrawler
//
//

#import "CTRQBuilder.h"
#import "CarTrawlerAppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+HexOutput.h"
#import "RentalSession.h"
#import "CTCountry.h"
#import "InsuranceObject.h"

@implementation CTRQBuilder

// This will read the client ID from the info.json and apply it to the relevant calls.

+ (NSString *) buildHeader:(NSString *)callType {
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)([[UIApplication sharedApplication] delegate]);
	
	// This will detect Target and Client ID and hash out the API calls accordingly.
	
	if ([callType isEqualToString:kHeader]) {
		
		return [NSString stringWithFormat:@"\"@xmlns\":\"http://www.opentravel.org/OTA/2003/05\",\"@xmlns:xsi\": \"http://www.w3.org/2001/XMLSchema-instance\",\"@Version\": \"1.005\",\"@Target\": \"%@\",\"POS\": {\"Source\": {\"RequestorID\": {\"@Type\": \"16\",\"@ID\": \"%@\",\"@ID_Context\": \"CARTRAWLER\"}}},", kTarget, appDelegate.clientID];
		
	} else if ([callType isEqualToString:kMobileHeader]) {
		
		return [NSString stringWithFormat:@"\"@xmlns\":\"http://www.opentravel.org/OTA/2003/05\",\"@xmlns:xsi\": \"http://www.w3.org/2001/XMLSchema-instance\",\"@Version\": \"1.005\",\"@Target\": \"%@\",\"POS\": {\"Source\": {\"@ERSP_UserID\": \"MO\",\"RequestorID\": {\"@Type\": \"16\",\"@ID\": \"%@\",\"@ID_Context\": \"CARTRAWLER\"}}},", kTarget, appDelegate.clientID];
		
	} else if ([callType isEqualToString:kInsuranceHeader]) {
		
		return [NSString stringWithFormat:@"\"@xmlns\":\"http://www.opentravel.org/OTA/2003/05\",\"@Version\": \"1.002\",\"@Target\": \"%@\",\"@PrimaryLangID\": \"EN\",\"POS\": {\"Source\": {\"@ISOCurrency\": \"GBP\",\"RequestorID\": {\"@Type\": \"16\",\"@ID\": \"%@\",\"@ID_Context\": \"CARTRAWLER\"}}},", kTarget, appDelegate.clientID];
		
	} else if ([callType isEqualToString:kCancelHeader]) {
		
		return [NSString stringWithFormat:@"\"@xmlns\":\"http://www.opentravel.org/OTA/2003/05\",\"@xmlns:xsi\": \"http://www.w3.org/2001/XMLSchema-instance\",\"@Version\": \"1.007\",\"@Target\": \"%@\",\"POS\": {\"Source\": {\"@ERSP_UserID\": \"MO\",\"RequestorID\": {\"@Type\": \"16\",\"@ID\": \"%@\",\"@ID_Context\": \"CARTRAWLER\"}}},", kTarget, appDelegate.clientID];
		
	} else if ([callType isEqualToString:kRentalReqHeader]) {
		
		return [NSString stringWithFormat:@"\"@xmlns\":\"http://www.opentravel.org/OTA/2003/05\",\"@xmlns:xsi\": \"http://www.w3.org/2001/XMLSchema-instance\",\"@Version\": \"1.000\",\"@Target\": \"%@\",\"POS\": {\"Source\": {\"@ERSP_UserID\": \"MO\",\"RequestorID\": {\"@Type\": \"16\",\"@ID\": \"%@\",\"@ID_Context\": \"CARTRAWLER\"}}},", kTarget, appDelegate.clientID];
		
	} else if ([callType isEqualToString:kGetExistingBookingHeader]) {
		
		return [NSString stringWithFormat:@"\"@xmlns\":\"http://www.opentravel.org/OTA/2003/05\",\"@xmlns:xsi\": \"http://www.w3.org/2001/XMLSchema-instance\",\"@Version\": \"1.002\",\"@Target\": \"%@\",\"@PrimaryLangID\": \"EN\",\"POS\": {\"Source\": {\"RequestorID\": {\"@Type\": \"16\",\"@ID\": \"%@\",\"@ID_Context\": \"CARTRAWLER\"}}},", kTarget, appDelegate.clientID];
		
	} else if ([callType isEqualToString:kLocationSearchHeader]) {
		
		return [NSString stringWithFormat:@"\"@xmlns\":\"http://www.cartrawler.com/\",\"@Version\": \"1.000\",\"@Target\": \"%@\",\"@PrimaryLangID\": \"EN\",\"POS\": {\"Source\": {\"RequestorID\": {\"@Type\": \"16\",\"@ID\": \"%@\",\"@ID_Context\": \"CARTRAWLER\"}}},", kTarget, appDelegate.clientID];
		
	} else {
		return nil;
	}

}

+ (NSString *) stringToSha1:(NSString *)str {
    NSData *dataToHash = [str dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char hashBytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([dataToHash bytes], (CC_LONG)[dataToHash length], hashBytes);
    NSData *encodedData = [NSData dataWithBytes:hashBytes length:CC_SHA1_DIGEST_LENGTH];
	NSString *encodedStr = [encodedData hexadecimalString];
	
    return encodedStr;
}

+ (NSString *) tpaExtenstionContruct {
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"yyyyMMddHHmmss"];
	NSDate *now = [NSDate date];
	NSString *dateString = [format stringFromDate:now];
	
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)([[UIApplication sharedApplication] delegate]);
	
	NSString *stringTobeHashed = [NSString stringWithFormat:@"%@.%@.%@", [self stringToSha1:[UIDevice currentDevice].identifierForVendor.UUIDString], dateString, appDelegate.clientID];
	NSString *stringTwo = [NSString stringWithFormat:@"%@.cartrawler", [self stringToSha1:stringTobeHashed]];	
	
	return [NSString stringWithFormat:@"\"TPA_Extensions\": {\"ConsumerSignature\":{\"@ID\": \"%@\",\"@Hash\": \"%@\",\"@Stamp\": \"%@\"}}}", [self stringToSha1:[UIDevice currentDevice].identifierForVendor.UUIDString], [self stringToSha1:stringTwo], dateString];
}

+ (NSString *) OTA_VehAvailRateRQ:(NSString *)pickUpDateTime 
				   returnDateTime:(NSString *)returnDateTime 
			   pickUpLocationCode:(NSString *)pickUpLoactionCode 
			   returnLocationCode:(NSString *)returnLocationCode
						driverAge:(NSString *)driverAge
					 passengerQty:(NSString *)passengerQty
				homeCountryCode:(NSString *)homeCountryCode {
	
	return [NSString stringWithFormat:@"\"VehAvailRQCore\":{\"@Status\":\"Available\",\"VehRentalCore\":{\"@PickUpDateTime\":\"%@\",\"@ReturnDateTime\":\"%@\",\"PickUpLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"},\"ReturnLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"}},\"DriverType\":{\"@Age\":\"%@\"}},\"VehAvailRQInfo\":{\"@PassengerQty\":\"%@\",\"Customer\":{\"Primary\":{\"CitizenCountryName\":{\"@Code\":\"%@\"}}},%@", pickUpDateTime, returnDateTime, pickUpLoactionCode, returnLocationCode, driverAge, passengerQty, homeCountryCode, [self tpaExtenstionContruct]];
}

+ (NSString *) CT_VehLocSearchRQ:(NSString *)pickupLocationCode {
	return [NSString stringWithFormat:@"\"VehLocSearchCriterion\":{\"@ExactMatch\":\"true\",\"@ImportanceType\":\"Mandatory\",\"PickupLocation\":{\"@ID\":\"%@\",\"@ID_Context\":\"CARTRAWLER\"}}", pickupLocationCode];
}

+ (NSString *) CT_VehLocSearchRQ_Partial:(NSString *)partialString {
	return [NSString stringWithFormat:@"{\"@xmlns\":\"http://www.cartrawler.com/\",\"@Version\":\"1.000\",\"@Target\":\"%@\",\"@PrimaryLangID\":\"EN\",\"POS\":{\"Source\":{\"@ERSP_UserID\":\"AJ\",\"RequestorID\":{\"@Type\":\"16\",\"@ID\":\"26649\",\"@ID_Context\":\"CARTRAWLER\"}}},\"VehLocSearchCriterion\":{\"@ExactMatch\":\"true\",\"@ImportanceType\":\"Mandatory\",\"PartialText\":{\"@Size\":\"10\",\"#text\":\"%@\"}}}", kTarget, partialString];
}

+ (NSString *) OTA_VehResRQNoPayment:(NSString *)pickupDateTime 
			 returnDateTime:(NSString *)returnDateTime 
		 pickupLocationCode:(NSString *)pickupLocationCode 
		dropoffLocationCode:(NSString *)dropoffLocationCode 
				homeCountry:(NSString *)homeCountry 
				  driverAge:(NSString *)driverAge 
			  numPassengers:(NSString *)numPassengers
			   flightNumber:(NSString *)flightNumber
					  refID:(NSString *)refID
			   refTimeStamp:(NSString *)refTimeStamp
					 refURL:(NSString *)refURL
			   extrasString:(NSString *)extrasString
				 namePrefix:(NSString *)namePrefix
				  givenName:(NSString *)givenName
					surName:(NSString *)surName
			   emailAddress:(NSString *)emailAddress
					address:(NSString *)address
				phoneNumber:(NSString *)phoneNumber {
	
	if (flightNumber != nil && [flightNumber length] > 2) {
		
		NSString *flightNumberPrefixString = [flightNumber substringToIndex:2];
		NSString *flightNumberString = [flightNumber substringFromIndex:2];
		// Tested, this works.
		return [NSString stringWithFormat:@"\"VehResRQCore\":{\"@Status\":\"All\",\"VehRentalCore\":{\"@PickUpDateTime\":\"%@\",\"@ReturnDateTime\":\"%@\",\"PickUpLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"},\"ReturnLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"}},\"Customer\":{\"Primary\":{\"PersonName\":{\"NamePrefix\":\"%@\",\"GivenName\":\"%@\",\"Surname\":\"%@\"},\"Telephone\":{\"@PhoneTechType\":\"1\",\"@AreaCityCode\":\"0\",\"@PhoneNumber\":\"%@\"},\"Email\":{\"@EmailType\":\"2\",\"#text\":\"%@\"},\"Address\":{\"@Type\":\"2\",\"AddressLine\":\"%@\",\"CountryName\":{\"@Code\":\"%@\"}},\"CitizenCountryName\":{\"@Code\":\"%@\"}}},\"DriverType\":{\"@Age\":\"%@\"}%@},\"VehResRQInfo\":{\"@PassengerQty\":\"%@\",\"ArrivalDetails\":{\"@TransportationCode\":\"14\",\"@Number\":\"%@\",\"OperatingCompany\":\"%@\"},\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"CARTRAWLER\",\"@DateTime\":\"%@\",\"@URL\":\"%@\"}}" ,pickupDateTime, returnDateTime, pickupLocationCode, dropoffLocationCode, namePrefix, givenName, surName, phoneNumber, emailAddress, address, homeCountry, homeCountry, driverAge, extrasString, numPassengers, flightNumberString, flightNumberPrefixString, refID, refTimeStamp, refURL];
	} else {
		// Tested, this works.
		return [NSString stringWithFormat:@"\"VehResRQCore\":{\"@Status\":\"All\",\"VehRentalCore\":{\"@PickUpDateTime\":\"%@\",\"@ReturnDateTime\":\"%@\",\"PickUpLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"},\"ReturnLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"}},\"Customer\":{\"Primary\":{\"PersonName\":{\"NamePrefix\":\"%@\",\"GivenName\":\"%@\",\"Surname\":\"%@\"},\"Telephone\":{\"@PhoneTechType\":\"1\",\"@AreaCityCode\":\"0\",\"@PhoneNumber\":\"%@\"},\"Email\":{\"@EmailType\":\"2\",\"#text\":\"%@\"},\"Address\":{\"@Type\":\"2\",\"AddressLine\":\"%@\",\"CountryName\":{\"@Code\":\"%@\"}},\"CitizenCountryName\":{\"@Code\":\"%@\"}}},\"DriverType\":{\"@Age\":\"%@\"}%@},\"VehResRQInfo\":{\"@PassengerQty\":\"%@\",\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"CARTRAWLER\",\"@DateTime\":\"%@\",\"@URL\":\"%@\"}}",pickupDateTime, returnDateTime, pickupLocationCode, dropoffLocationCode, namePrefix, givenName, surName, phoneNumber, emailAddress, address, homeCountry, homeCountry, driverAge, extrasString, numPassengers, refID, refTimeStamp, refURL];
	}
}

+ (NSString *) OTA_VehResRQ:(NSString *)pickupDateTime 
			  returnDateTime:(NSString *)returnDateTime 
		  pickupLocationCode:(NSString *)pickupLocationCode 
		 dropoffLocationCode:(NSString *)dropoffLocationCode 
				 homeCountry:(NSString *)homeCountry 
				   driverAge:(NSString *)driverAge 
			   numPassengers:(NSString *)numPassengers
				flightNumber:(NSString *)flightNumber
					   refID:(NSString *)refID
				refTimeStamp:(NSString *)refTimeStamp
					  refURL:(NSString *)refURL
				extrasString:(NSString *)extrasString
				  namePrefix:(NSString *)namePrefix
				   givenName:(NSString *)givenName
					 surName:(NSString *)surName
				emailAddress:(NSString *)emailAddress
					 address:(NSString *)address
				 phoneNumber:(NSString *)phoneNumber
					cardType:(NSString *)cardType
				  cardNumber:(NSString *)cardNumber
			  cardExpireDate:(NSString *)cardExpireDate
			  cardHolderName:(NSString *)cardHolderName
			   cardCCVNumber:(NSString *)cardCCVNumber
			 insuranceObject:(InsuranceObject *)ins
		   isBuyingInsurance:(BOOL)isBuyingInsurance {
	/*
	 if (flightNumber != nil && [flightNumber length] > 2) {
	 NSString *flightNumberPrefixString = [flightNumber substringToIndex:2];
	 NSString *flightNumberString = [flightNumber substringFromIndex:2];
	 
	 if (isBuyingInsurance) {
	 // Tested, this works.
	 return [NSString stringWithFormat:@"\"VehResRQCore\":{\"@Status\":\"All\",\"VehRentalCore\":{\"@PickUpDateTime\":\"%@\",\"@ReturnDateTime\":\"%@\",\"PickUpLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"},\"ReturnLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"}},\"Customer\":{\"Primary\":{\"PersonName\":{\"NamePrefix\":\"%@\",\"GivenName\":\"%@\",\"Surname\":\"%@\"},\"Telephone\":{\"@PhoneTechType\":\"1\",\"@AreaCityCode\":\"0\",\"@PhoneNumber\":\"%@\"},\"Email\":{\"@EmailType\":\"2\",\"#text\":\"%@\"},\"Address\":{\"@Type\":\"2\",\"AddressLine\":\"%@\",\"CountryName\":{\"@Code\":\"%@\"}},\"CitizenCountryName\":{\"@Code\":\"%@\"}}},\"DriverType\":{\"@Age\":\"%@\"}%@},\"VehResRQInfo\":{\"@PassengerQty\":\"%@\",\"ArrivalDetails\":{\"@TransportationCode\":\"14\",\"@Number\":\"%@\",\"OperatingCompany\":\"%@\"},\"RentalPaymentPref\":{\"PaymentCard\":{\"@CardType\":\"1\",\"@CardCode\":\"%@\",\"@CardNumber\":\"%@\",\"@ExpireDate\":\"%@\",\"@SeriesCode\":\"%@\",\"CardHolderName\":\"%@\"}},\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"CARTRAWLER\",\"@DateTime\":\"%@\",\"@URL\":\"%@\"},\"TPA_Extensions\":{\"CompanyName\":{\"@VAT\":\"98765\",\"#text\":\"Cartrawler Ltd\"},\"TPA_Extensions\":{\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"INSURANCE\",\"@DateTime\":\"%@\",\"@Amount\":\"%@\",\"@CurrencyCode\":\"%@\",\"@URL\":\"%@\"}}}}" ,pickupDateTime, returnDateTime, pickupLocationCode, dropoffLocationCode, namePrefix, givenName, surName, phoneNumber, emailAddress, address, homeCountry, homeCountry, driverAge, extrasString, numPassengers, flightNumberString, flightNumberPrefixString, cardType, cardNumber, cardExpireDate, cardCCVNumber, cardHolderName, refID, refTimeStamp, refURL, ins.planID, ins.timestamp, ins.premiumAmount, ins.premiumCurrencyCode, ins.detailURL];
	 } 
	 else {
	 // Tested this works.
	 return [NSString stringWithFormat:@"\"VehResRQCore\":{\"@Status\":\"All\",\"VehRentalCore\":{\"@PickUpDateTime\":\"%@\",\"@ReturnDateTime\":\"%@\",\"PickUpLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"},\"ReturnLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"}},\"Customer\":{\"Primary\":{\"PersonName\":{\"NamePrefix\":\"%@\",\"GivenName\":\"%@\",\"Surname\":\"%@\"},\"Telephone\":{\"@PhoneTechType\":\"1\",\"@AreaCityCode\":\"0\",\"@PhoneNumber\":\"%@\"},\"Email\":{\"@EmailType\":\"2\",\"#text\":\"%@\"},\"Address\":{\"@Type\":\"2\",\"AddressLine\":\"%@\",\"CountryName\":{\"@Code\":\"%@\"}},\"CitizenCountryName\":{\"@Code\":\"%@\"}}},\"DriverType\":{\"@Age\":\"%@\"}%@},\"VehResRQInfo\":{\"@PassengerQty\":\"%@\",\"ArrivalDetails\":{\"@TransportationCode\":\"14\",\"@Number\":\"%@\",\"OperatingCompany\":\"%@\"},\"RentalPaymentPref\":{\"PaymentCard\":{\"@CardType\":\"1\",\"@CardCode\":\"%@\",\"@CardNumber\":\"%@\",\"@ExpireDate\":\"%@\",\"@SeriesCode\":\"%@\",\"CardHolderName\":\"%@\"}},\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"CARTRAWLER\",\"@DateTime\":\"%@\",\"@URL\":\"%@\"},\"TPA_Extensions\":{\"CompanyName\":{\"@VAT\":\"98765\",\"#text\":\"Cartrawler Ltd\"}}}" ,pickupDateTime, returnDateTime, pickupLocationCode, dropoffLocationCode, namePrefix, givenName, surName, phoneNumber, emailAddress, address, homeCountry, homeCountry, driverAge, extrasString, numPassengers, flightNumberString, flightNumberPrefixString, cardType, cardNumber, cardExpireDate, cardCCVNumber, cardHolderName, refID, refTimeStamp, refURL];
	 }
	 } else {
	 // There isn't a flight number
	 if (isBuyingInsurance) {
	 // Tested, this works.
	 return [NSString stringWithFormat:@"\"VehResRQCore\":{\"@Status\":\"All\",\"VehRentalCore\":{\"@PickUpDateTime\":\"%@\",\"@ReturnDateTime\":\"%@\",\"PickUpLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"},\"ReturnLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"}},\"Customer\":{\"Primary\":{\"PersonName\":{\"NamePrefix\":\"%@\",\"GivenName\":\"%@\",\"Surname\":\"%@\"},\"Telephone\":{\"@PhoneTechType\":\"1\",\"@AreaCityCode\":\"0\",\"@PhoneNumber\":\"%@\"},\"Email\":{\"@EmailType\":\"2\",\"#text\":\"%@\"},\"Address\":{\"@Type\":\"2\",\"AddressLine\":\"%@\",\"CountryName\":{\"@Code\":\"%@\"}},\"CitizenCountryName\":{\"@Code\":\"%@\"}}},\"DriverType\":{\"@Age\":\"%@\"}%@},\"VehResRQInfo\":{\"@PassengerQty\":\"%@\",\"RentalPaymentPref\":{\"PaymentCard\":{\"@CardType\":\"1\",\"@CardCode\":\"%@\",\"@CardNumber\":\"%@\",\"@ExpireDate\":\"%@\",\"@SeriesCode\":\"%@\",\"CardHolderName\":\"%@\"}},\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"CARTRAWLER\",\"@DateTime\":\"%@\",\"@URL\":\"%@\"},\"TPA_Extensions\":{\"CompanyName\":{\"@VAT\":\"98765\",\"#text\":\"Cartrawler Ltd\"},\"TPA_Extensions\":{\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"INSURANCE\",\"@DateTime\":\"%@\",\"@Amount\":\"%@\",\"@CurrencyCode\":\"%@\",\"@URL\":\"%@\"}}}}" ,pickupDateTime, returnDateTime, pickupLocationCode, dropoffLocationCode, namePrefix, givenName, surName, phoneNumber, emailAddress, address, homeCountry, homeCountry, driverAge, extrasString, numPassengers, cardType, cardNumber, cardExpireDate, cardCCVNumber, cardHolderName, refID, refTimeStamp, refURL, ins.planID, ins.timestamp, ins.premiumAmount, ins.premiumCurrencyCode, ins.detailURL];			
	 } else {
	 // Tested, this works.
	 return [NSString stringWithFormat:@"\"VehResRQCore\":{\"@Status\":\"All\",\"VehRentalCore\":{\"@PickUpDateTime\":\"%@\",\"@ReturnDateTime\":\"%@\",\"PickUpLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"},\"ReturnLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"}},\"Customer\":{\"Primary\":{\"PersonName\":{\"NamePrefix\":\"%@\",\"GivenName\":\"%@\",\"Surname\":\"%@\"},\"Telephone\":{\"@PhoneTechType\":\"1\",\"@AreaCityCode\":\"0\",\"@PhoneNumber\":\"%@\"},\"Email\":{\"@EmailType\":\"2\",\"#text\":\"%@\"},\"Address\":{\"@Type\":\"2\",\"AddressLine\":\"%@\",\"CountryName\":{\"@Code\":\"%@\"}},\"CitizenCountryName\":{\"@Code\":\"%@\"}}},\"DriverType\":{\"@Age\":\"%@\"}%@},\"VehResRQInfo\":{\"@PassengerQty\":\"%@\",\"RentalPaymentPref\":{\"PaymentCard\":{\"@CardType\":\"1\",\"@CardCode\":\"%@\",\"@CardNumber\":\"%@\",\"@ExpireDate\":\"%@\",\"@SeriesCode\":\"%@\",\"CardHolderName\":\"%@\"}},\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"CARTRAWLER\",\"@DateTime\":\"%@\",\"@URL\":\"%@\"},\"TPA_Extensions\":{\"CompanyName\":{\"@VAT\":\"98765\",\"#text\":\"Cartrawler Ltd\"}}}" ,pickupDateTime, returnDateTime, pickupLocationCode, dropoffLocationCode, namePrefix, givenName, surName, phoneNumber, emailAddress, address, homeCountry, homeCountry, driverAge, extrasString, numPassengers, cardType, cardNumber, cardExpireDate, cardCCVNumber, cardHolderName, refID, refTimeStamp, refURL];
	 }
	 }
	 */
	if (flightNumber != nil && [flightNumber length] > 2) {
		NSString *flightNumberPrefixString = [flightNumber substringToIndex:2];
		NSString *flightNumberString = [flightNumber substringFromIndex:2];

		if (isBuyingInsurance) {
			// Tested, this works.
			return [NSString stringWithFormat:@"\"VehResRQCore\":{\"@Status\":\"All\",\"VehRentalCore\":{\"@PickUpDateTime\":\"%@\",\"@ReturnDateTime\":\"%@\",\"PickUpLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"},\"ReturnLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"}},\"Customer\":{\"Primary\":{\"PersonName\":{\"NamePrefix\":\"%@\",\"GivenName\":\"%@\",\"Surname\":\"%@\"},\"Telephone\":{\"@PhoneTechType\":\"1\",\"@AreaCityCode\":\"0\",\"@PhoneNumber\":\"%@\"},\"Email\":{\"@EmailType\":\"2\",\"#text\":\"%@\"},\"Address\":{\"@Type\":\"2\",\"AddressLine\":\"%@\",\"CountryName\":{\"@Code\":\"%@\"}},\"CitizenCountryName\":{\"@Code\":\"%@\"}}},\"DriverType\":{\"@Age\":\"%@\"}%@},\"VehResRQInfo\":{\"@PassengerQty\":\"%@\",\"ArrivalDetails\":{\"@TransportationCode\":\"14\",\"@Number\":\"%@\",\"OperatingCompany\":\"%@\"},\"RentalPaymentPref\":{\"PaymentCard\":{\"@CardType\":\"1\",\"@CardCode\":\"%@\",\"@CardNumber\":\"%@\",\"@ExpireDate\":\"%@\",\"@SeriesCode\":\"%@\",\"CardHolderName\":\"%@\"}},\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"CARTRAWLER\",\"@DateTime\":\"%@\",\"@URL\":\"%@\"},\"TPA_Extensions\":{\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"INSURANCE\",\"@Amount\":\"%@\",\"@CurrencyCode\":\"%@\",\"@URL\":\"%@\"}}}" ,pickupDateTime, returnDateTime, pickupLocationCode, dropoffLocationCode, namePrefix, givenName, surName, phoneNumber, emailAddress, address, homeCountry, homeCountry, driverAge, extrasString, numPassengers, flightNumberString, flightNumberPrefixString, cardType, cardNumber, cardExpireDate, cardCCVNumber, cardHolderName, refID, refTimeStamp, refURL, ins.planID, ins.premiumAmount, ins.premiumCurrencyCode, ins.detailURL];
		} 
		else {
			// Tested this works.
			return [NSString stringWithFormat:@"\"VehResRQCore\":{\"@Status\":\"All\",\"VehRentalCore\":{\"@PickUpDateTime\":\"%@\",\"@ReturnDateTime\":\"%@\",\"PickUpLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"},\"ReturnLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"}},\"Customer\":{\"Primary\":{\"PersonName\":{\"NamePrefix\":\"%@\",\"GivenName\":\"%@\",\"Surname\":\"%@\"},\"Telephone\":{\"@PhoneTechType\":\"1\",\"@AreaCityCode\":\"0\",\"@PhoneNumber\":\"%@\"},\"Email\":{\"@EmailType\":\"2\",\"#text\":\"%@\"},\"Address\":{\"@Type\":\"2\",\"AddressLine\":\"%@\",\"CountryName\":{\"@Code\":\"%@\"}},\"CitizenCountryName\":{\"@Code\":\"%@\"}}},\"DriverType\":{\"@Age\":\"%@\"}%@},\"VehResRQInfo\":{\"@PassengerQty\":\"%@\",\"ArrivalDetails\":{\"@TransportationCode\":\"14\",\"@Number\":\"%@\",\"OperatingCompany\":\"%@\"},\"RentalPaymentPref\":{\"PaymentCard\":{\"@CardType\":\"1\",\"@CardCode\":\"%@\",\"@CardNumber\":\"%@\",\"@ExpireDate\":\"%@\",\"@SeriesCode\":\"%@\",\"CardHolderName\":\"%@\"}},\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"CARTRAWLER\",\"@DateTime\":\"%@\",\"@URL\":\"%@\"}}" ,pickupDateTime, returnDateTime, pickupLocationCode, dropoffLocationCode, namePrefix, givenName, surName, phoneNumber, emailAddress, address, homeCountry, homeCountry, driverAge, extrasString, numPassengers, flightNumberString, flightNumberPrefixString, cardType, cardNumber, cardExpireDate, cardCCVNumber, cardHolderName, refID, refTimeStamp, refURL];
		}
	} else {
		// There isn't a flight number
		if (isBuyingInsurance) {
			// Tested, this works.
			return [NSString stringWithFormat:@"\"VehResRQCore\":{\"@Status\":\"All\",\"VehRentalCore\":{\"@PickUpDateTime\":\"%@\",\"@ReturnDateTime\":\"%@\",\"PickUpLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"},\"ReturnLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"}},\"Customer\":{\"Primary\":{\"PersonName\":{\"NamePrefix\":\"%@\",\"GivenName\":\"%@\",\"Surname\":\"%@\"},\"Telephone\":{\"@PhoneTechType\":\"1\",\"@AreaCityCode\":\"0\",\"@PhoneNumber\":\"%@\"},\"Email\":{\"@EmailType\":\"2\",\"#text\":\"%@\"},\"Address\":{\"@Type\":\"2\",\"AddressLine\":\"%@\",\"CountryName\":{\"@Code\":\"%@\"}},\"CitizenCountryName\":{\"@Code\":\"%@\"}}},\"DriverType\":{\"@Age\":\"%@\"}%@},\"VehResRQInfo\":{\"@PassengerQty\":\"%@\",\"RentalPaymentPref\":{\"PaymentCard\":{\"@CardType\":\"1\",\"@CardCode\":\"%@\",\"@CardNumber\":\"%@\",\"@ExpireDate\":\"%@\",\"@SeriesCode\":\"%@\",\"CardHolderName\":\"%@\"}},\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"CARTRAWLER\",\"@DateTime\":\"%@\",\"@URL\":\"%@\"},\"TPA_Extensions\":{\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"INSURANCE\",\"@Amount\":\"%@\",\"@CurrencyCode\":\"%@\",\"@URL\":\"%@\"}}}" ,pickupDateTime, returnDateTime, pickupLocationCode, dropoffLocationCode, namePrefix, givenName, surName, phoneNumber, emailAddress, address, homeCountry, homeCountry, driverAge, extrasString, numPassengers, cardType, cardNumber, cardExpireDate, cardCCVNumber, cardHolderName, refID, refTimeStamp, refURL, ins.planID, ins.premiumAmount, ins.premiumCurrencyCode, ins.detailURL];			
		} else {
			// Tested, this works.
			return [NSString stringWithFormat:@"\"VehResRQCore\":{\"@Status\":\"All\",\"VehRentalCore\":{\"@PickUpDateTime\":\"%@\",\"@ReturnDateTime\":\"%@\",\"PickUpLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"},\"ReturnLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"}},\"Customer\":{\"Primary\":{\"PersonName\":{\"NamePrefix\":\"%@\",\"GivenName\":\"%@\",\"Surname\":\"%@\"},\"Telephone\":{\"@PhoneTechType\":\"1\",\"@AreaCityCode\":\"0\",\"@PhoneNumber\":\"%@\"},\"Email\":{\"@EmailType\":\"2\",\"#text\":\"%@\"},\"Address\":{\"@Type\":\"2\",\"AddressLine\":\"%@\",\"CountryName\":{\"@Code\":\"%@\"}},\"CitizenCountryName\":{\"@Code\":\"%@\"}}},\"DriverType\":{\"@Age\":\"%@\"}%@},\"VehResRQInfo\":{\"@PassengerQty\":\"%@\",\"RentalPaymentPref\":{\"PaymentCard\":{\"@CardType\":\"1\",\"@CardCode\":\"%@\",\"@CardNumber\":\"%@\",\"@ExpireDate\":\"%@\",\"@SeriesCode\":\"%@\",\"CardHolderName\":\"%@\"}},\"Reference\":{\"@Type\":\"16\",\"@ID\":\"%@\",\"@ID_Context\":\"CARTRAWLER\",\"@DateTime\":\"%@\",\"@URL\":\"%@\"}}" ,pickupDateTime, returnDateTime, pickupLocationCode, dropoffLocationCode, namePrefix, givenName, surName, phoneNumber, emailAddress, address, homeCountry, homeCountry, driverAge, extrasString, numPassengers, cardType, cardNumber, cardExpireDate, cardCCVNumber, cardHolderName, refID, refTimeStamp, refURL];
		}
	}
}

+ (NSString *) CT_RentalConditionsRQ:(NSString *)puDateTime
						  doDateTime:(NSString *)doDateTime 
						puLocationCode:(NSString *)puLocationCode
					  doLocationCode:(NSString *)doLocationCode
						 homeCountry:(NSString *)homeCountry 
							 refType:(NSString *)refType 
							   refID:(NSString *)refID 
						refIDContext:(NSString *)refIDContext 
							  refURL:(NSString *)refURL {
	return [NSString stringWithFormat:@"\"VehResRQCore\":{\"@Status\":\"All\",\"VehRentalCore\":{\"@PickUpDateTime\":\"%@\",\"@ReturnDateTime\":\"%@\",\"PickUpLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"},\"ReturnLocation\":{\"@CodeContext\":\"CARTRAWLER\",\"@LocationCode\":\"%@\"}},\"Customer\":{\"Primary\":{\"CitizenCountryName\":{\"@Code\":\"%@\"}}}},\"VehResRQInfo\":{\"Reference\":{\"@Type\":\"%@\",\"@ID\":\"%@\",\"@ID_Context\":\"%@\",\"@URL\":\"%@\"}}", puDateTime, doDateTime, puLocationCode, doLocationCode, homeCountry, refType, refID, refIDContext, refURL];
}

// This call, despite it being VehCancelRQ is only asking for the confirmation email to be resent, the app won't cancel a booking. (the above call is commented out for that reason)

+ (NSString *) CT_VehCancelRQ:(NSString *)bookingRef emailAddress:(NSString *)emailAddress {
	return [NSString stringWithFormat:@"\"VehModifyRQCore\": {\"@ModifyType\": \"Modify\",\"@Status\": \"Available\",\"UniqueID\": {\"@Type\": \"15\",\"@ID\": \"%@\",\"@ID_Context\": \"CARTRAWLER\"},\"TPA_Extensions\": {\"Email\": {\"@To\": \"%@\"},\"Action\": {\"@Value\": \"SendCustomerVoucher\"}}", bookingRef, emailAddress];
	
}

+ (NSString *) OTA_InsuranceDetailsRQ:(NSString *)totalCost session:(RentalSession *)session destinationCountry:(NSString *)countryCode {
	return [NSString stringWithFormat:@"\"PlanForQuoteRQ\":{\"@PlanID\":\"ACME\",\"@Type\":\"Protection\",\"CoveredTravelers\":{\"CoveredTraveler\":{\"CoveredPerson\":{\"@Relation\":\"Traveler 1\",\"GivenName\":\"Test\",\"Surname\":\"Test\"},\"CitizenCountryName\":{\"@Code\":\"%@\"}}},\"InsCoverageDetail\":{\"@Type\":\"SingleTrip\",\"TotalTripCost\":{\"@CurrencyCode\":\"%@\",\"@Amount\":\"%@\"},\"CoveredTrips\":{\"CoveredTrip\":{\"@Start\": \"%@\",\"@End\":\"%@\",\"Destinations\":{\"Destination\":{\"CountryName\":\"%@\"}}}}}}",session.homeCountry, session.activeCurrency, totalCost, session.puDateTime, session.doDateTime, countryCode];
}

+ (NSString *) OTA_VehRetResRQ:(NSString *)bookingEmailAddress bookingRefID:(NSString *)bookingRefID {
	return [NSString stringWithFormat:@"\"VehRetResRQCore\": {\"UniqueID\": {\"@Type\": \"15\",\"@ID\": \"%@\"},\"TPA_Extensions\": {\"Email\": \"%@\"}}}", bookingRefID, bookingEmailAddress];
}

@end