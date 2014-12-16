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
//  ExtraEquipment.h
//  CarTrawler
//
//


@interface ExtraEquipment : NSObject {
	NSString	*chargeAmount;
	BOOL		isIncludedInRate;
	NSString	*currencyCode;
	BOOL		isTaxInclusive;
	
	NSString	*equipType;
	NSString	*description;
	
	NSInteger	qty;
}

@property (nonatomic, assign) NSInteger qty;
@property (nonatomic, copy) NSString *chargeAmount;
@property (nonatomic, assign) BOOL isIncludedInRate;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, assign) BOOL isTaxInclusive;
@property (nonatomic, copy) NSString *equipType;
@property (nonatomic, copy) NSString *description;

- (id) initFromDictionary:(NSDictionary *)dict;

@end
