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
//  Fee.h
//  CarTrawler
//
//

@interface Fee : NSObject

@property (nonatomic, readonly, copy) NSString *feeAmount;
@property (nonatomic, readonly, copy) NSString *feeCurrencyCode;
@property (nonatomic, readonly, copy) NSString *feePurpose;
@property (nonatomic, readonly, copy) NSString *feePurposeDescription;

- (instancetype) initWithAmount:(NSString *)amount currencyCode:(NSString *)currencyCode andPurpose:(NSString *)purpose andPurposeDescription:(NSString *)description;

@end
