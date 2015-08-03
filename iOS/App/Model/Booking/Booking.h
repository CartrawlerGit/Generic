//
// Copyright 2014 Etrawler
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//
//  Booking.h
//  CarTrawler
//

@interface Booking : NSObject <NSCoding>

@property (nonatomic, assign) BOOL wasRetrievedFromWebBOOL;
@property (nonatomic, copy) NSString *wasRetrievedFromWeb;
@property (nonatomic, copy) NSString *supportNumber;
@property (nonatomic, copy) NSString *vendorImageURL;
@property (nonatomic, copy) NSString *vendorBookingRef;
@property (nonatomic, copy) NSString *coordString;
@property (nonatomic, copy) NSString *customerEmail;
@property (nonatomic, assign) BOOL vehIsAirConditioned;
@property (nonatomic, copy) NSString *customerGivenName;
@property (nonatomic, copy) NSString *customerSurname;
@property (nonatomic, copy) NSString *confType;
@property (nonatomic, copy) NSString *confID;
@property (nonatomic, copy) NSString *vendorName;
@property (nonatomic, copy) NSString *vendorCode;
@property (nonatomic, copy) NSString *puDateTime;
@property (nonatomic, copy) NSString *doDateTime;
@property (nonatomic, copy) NSString *puLocationCode;
@property (nonatomic, copy) NSString *doLocationCode;
@property (nonatomic, copy) NSString *puLocationName;
@property (nonatomic, copy) NSString *doLocationName;
@property (nonatomic, copy) NSString *vehTransmissionType;
@property (nonatomic, copy) NSString *vehFuelType;
@property (nonatomic, copy) NSString *vehDriveType;
@property (nonatomic, copy) NSString *vehPassengerQty;
@property (nonatomic, copy) NSString *vehBaggageQty;
@property (nonatomic, copy) NSString *vehCode;
@property (nonatomic, copy) NSString *vehCategory;
@property (nonatomic, copy) NSString *vehDoorCount;
@property (nonatomic, copy) NSString *vehClassSize;
@property (nonatomic, copy) NSString *vehMakeModelName;
@property (nonatomic, copy) NSString *vehMakeModelCode;
@property (nonatomic, copy) NSString *vehPictureUrl;
@property (nonatomic, copy) NSString *vehAssetNumber;
@property (nonatomic, strong) NSMutableArray *fees;
@property (nonatomic, copy) NSString *totalChargeAmount;
@property (nonatomic, copy) NSString *estimatedTotalAmount;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, copy) NSString *tpaFeeAmount;
@property (nonatomic, copy) NSString *tpaFeeCurrencyCode;
@property (nonatomic, copy) NSString *tpaFeePurpose;
@property (nonatomic, copy) NSString *tpaConfType;
@property (nonatomic, copy) NSString *tpaConfID;
@property (nonatomic, copy) NSString *paymentRuleType;
@property (nonatomic, copy) NSString *paymentAmount;
@property (nonatomic, copy) NSString *paymentCurrencyCode;
@property (nonatomic, copy) NSString *rentalPaymentTransactionCode;
@property (nonatomic, copy) NSString *rentalPaymentCardType;
@property (nonatomic, assign) BOOL isAtAirport;
@property (nonatomic, copy) NSString *locationCode;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *locationAddress;
@property (nonatomic, copy) NSString *locationCountryName;
@property (nonatomic, copy) NSString *locationPhoneNumber;

@end