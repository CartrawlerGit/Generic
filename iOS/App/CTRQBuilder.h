//
//  CTRQBuilder.h
//  CarTrawler
//
//

@class InsuranceObject;

@interface CTRQBuilder : NSObject { }

+ (NSString *) buildHeader:(NSString *)callType;

+ (NSString *) stringToSha1:(NSString *)str;

+ (NSString *) tpaExtenstionContruct;

+ (NSString *) OTA_VehAvailRateRQ:(NSString *)pickUpDateTime 
				   returnDateTime:(NSString *)returnDateTime 
			   pickUpLocationCode:(NSString *)pickUpLoactionCode 
			   returnLocationCode:(NSString *)returnLocationCode
						driverAge:(NSString *)driverAge
					 passengerQty:(NSString *)passengerQty
				  homeCountryCode:(NSString *)homeCountryCode;

+ (NSString *) CT_VehLocSearchRQ:(NSString *)pickupLocationCode;

+ (NSString *) CT_VehLocSearchRQ_Partial:(NSString *)partialString;

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
				phoneNumber:(NSString *)phoneNumber;

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
		  isBuyingInsurance:(BOOL)isBuyingInsurance;/*
				 namePrefix:(NSString *)namePrefix
				phoneNumber:(NSString *)phoneNumber
			   emailAddress:(NSString *)emailAddress
					address:(NSString *)address;*/

+ (NSString *) CT_RentalConditionsRQ:(NSString *)puDateTime
						  doDateTime:(NSString *)doDateTime 
					  puLocationCode:(NSString *)puLocationCode
					  doLocationCode:(NSString *)doLocationCode
						 homeCountry:(NSString *)homeCountry 
							 refType:(NSString *)refType 
							   refID:(NSString *)refID 
						refIDContext:(NSString *)refIDContext 
							  refURL:(NSString *)refURL;

+ (NSString *) CT_VehCancelRQ:(NSString *)bookingRef emailAddress:(NSString *)emailAddress;

+ (NSString *) OTA_InsuranceDetailsRQ:(NSString *)totalCost session:(RentalSession *)session destinationCountry:(NSString *)countryCode;

+ (NSString *) OTA_VehRetResRQ:(NSString *)bookingEmailAddress bookingRefID:(NSString *)bookingRefID;

@end
