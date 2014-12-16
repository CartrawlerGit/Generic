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
//  VehAvailRSCore.h
//  CarTrawler
//

@interface VehAvailRSCore : NSObject {
	NSString	*puDate;
	NSString	*doDate;
	NSString	*puLocationCode;
	NSString	*puLocationName;
	NSString	*doLocationCode;
	NSString	*doLocationName;
	
	NSMutableArray *availableVendors;
}

- (id)initFromVehAvailRSCoreDictionary:(NSDictionary *)vehAvailRSCoreDictionary;

@property (nonatomic, copy) NSString *puDate;
@property (nonatomic, copy) NSString *doDate;
@property (nonatomic, copy) NSString *puLocationCode;
@property (nonatomic, copy) NSString *puLocationName;
@property (nonatomic, copy) NSString *doLocationCode;
@property (nonatomic, copy) NSString *doLocationName;
@property (nonatomic, retain) NSMutableArray *availableVendors;

@end
