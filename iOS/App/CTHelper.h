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
//  CTHelper.h
//  CarTrawler
//
//
@class ASIHTTPRequest, VehAvailRSCore, Booking, Fee, CTError, RentalSession;

@interface CTHelper : NSObject { }

// Utility methods

+ (void) showAlert:(NSString *)_t message:(NSString *)_m;

+ (NSString *) getCurrencySymbolFromString:(NSString *)currency;

+ (NSNumber *) convertStringToNumber:(NSString *)s;

+ (NSNumber *) convertFeeFromStringToNumber:(Fee *)fee;

+ (NSString *) getVehcileCategoryStringFromNumber:(NSString *)vehCatStr;

+ (NSString *) assetPath: (NSString *)asset;

// Request Builders

+ (ASIHTTPRequest *) makeRequest:(NSString *)rqCommand withSpecificHeader:(NSString *)header tail:(NSString *)rqTail;

+ (ASIHTTPRequest *) makeRequestWithoutBuiltInHeader:(NSString *)rqCommand tail:(NSString *)rqTail;

+ (ASIHTTPRequest *) makeRequest:(NSString *)rqCommand tail:(NSString *)rqTail;

+ (ASIHTTPRequest *) makeCancelBookingRequest:(NSString *)rqCommand tail:(NSString *)rqTail;

// Response validators

+ (id) validatePredictiveLocationsResponse:(NSDictionary *) response;

+ (id) validateResponse:(NSDictionary *)response;

// Response formatters

+ (NSMutableArray *) vehMatchedLocs:(NSDictionary *) locations;

+ (NSMutableArray *) predictiveLocations:(NSDictionary *) locations;

+ (CTError *) errorResponse:(NSDictionary *)err;

+ (VehAvailRSCore *) vehAvailRSCore:(NSDictionary *) info;

+ (Booking *) retrievedVehResRSCore:(NSDictionary *)info;

+ (Booking *) vehResRSCore:(NSDictionary *)info;

+ (NSMutableArray *) rentalTermsAndConditions:(NSDictionary *) theTermsAndConditions;

// Local Detection

+ (NSString *) getCurrencyNameForCode:(NSString *)isoCurrencyCode;

+ (NSString *) getLocaleCurrencyCode;

+ (NSString *) getLocaleCurrencySymbol;

+ (NSString *) getLocaleCode;

+ (NSString *) getLocaleDisplayName;

+ (NSString*) calculatePricePerDay:(RentalSession *)s price:(NSNumber *)p;

+ (UILabel *) getNavBarLabelWithTitle:(NSString *)t;

+ (UIButton *) getGreenUIButtonWithTitle:(NSString *)t;

+ (UIButton *) getSmallGreenUIButtonWithTitle:(NSString *)t;

+ (UIColor *) blueColor;

+ (NSString *) getTotalFeesFromSession:(RentalSession *)session;

+ (NSString *) getTotalFeesWithNoCurrencyFromSession:(RentalSession *)session;

@end
