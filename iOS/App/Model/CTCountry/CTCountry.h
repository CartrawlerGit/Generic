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
//  CTCountry.h
//  CarTrawler
//
//


@interface CTCountry : NSObject

@property (nonatomic, copy, readonly) NSString *currencyName;
@property (nonatomic, copy, readonly) NSString *currencyCode;
@property (nonatomic, copy, readonly) NSString *currencySymbol;
@property (nonatomic, copy, readonly) NSString *isoCountryName;
@property (nonatomic, copy, readonly) NSString *isoCountryCode;
@property (nonatomic, copy, readonly) NSString *isoDialingCode;

- (instancetype) initWithIsoCountryName:(NSString *)isoCountryName isoCountryCode:(NSString *)isoCountryCode andIsoDialingCode:(NSString *)isoDailingCode;

- (instancetype) initWithCurrencyName:(NSString *)currencyName currencyCode:(NSString *)currencyCode currencySymbol:(NSString *)currencySymbol isoCountryName:(NSString *)isoCountryName isoCountryCode:(NSString *)isoCountryCode andIsoDialingCode:(NSString *)isoDailingCode;

@end
