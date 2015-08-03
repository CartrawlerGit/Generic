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
//  RentalSession.h
//  CarTrawler
//
//

@class Vendor, Car, CTLocation, InsuranceObject;

@interface RentalSession : NSObject {
	NSString	*puDateTime;
	NSString	*doDateTime;
	
	NSString	*readablePuDateTimeString;
	NSString	*readableDoDateTimeString;
	
	NSString	*puLocationCode;
	NSString	*doLocationCode;
	
	NSString	*puLocationNameString;
	NSString	*doLocationNameString;
	
	NSString	*homeCountry;
	
	NSString	*driverAge;
	NSString	*numPassengers;
	
	NSString	*activeCurrency;
	
	NSString	*flightNumber;
	
	Car			*theCar;
	Vendor		*theVendor;
	
	NSMutableArray	*extras;
	
	NSDate		*startDate;
	NSDate		*endDate;
	
	CTLocation	*puLocation;
	CTLocation	*doLocation;
	
	InsuranceObject	*insurance;
	
	BOOL		hasBoughtInsurance;
}

@property (nonatomic, assign) BOOL hasBoughtInsurance;
@property (nonatomic, copy) NSString *activeCurrency;
@property (nonatomic, strong) InsuranceObject *insurance;
@property (nonatomic, copy) NSString *flightNumber;
@property (nonatomic, strong) CTLocation *puLocation;
@property (nonatomic, strong) CTLocation *doLocation;
@property (nonatomic, copy) NSString *readablePuDateTimeString;
@property (nonatomic, copy) NSString *readableDoDateTimeString;
@property (nonatomic, copy) NSString *puLocationNameString;
@property (nonatomic, copy) NSString *doLocationNameString;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSMutableArray *extras;
@property (nonatomic, copy) NSString *driverAge;
@property (nonatomic, copy) NSString *numPassengers;
@property (nonatomic, copy) NSString *homeCountry;
@property (nonatomic, copy) NSString *puDateTime;
@property (nonatomic, copy) NSString *doDateTime;
@property (nonatomic, copy) NSString *puLocationCode;
@property (nonatomic, copy) NSString *doLocationCode;
@property (nonatomic, strong) Car *theCar;
@property (nonatomic, strong) Vendor *theVendor;

- (id) initWithHomeCountry:(NSString *)hc puDateTime:(NSString *)pudt doDateTime:(NSString *)dodt puLocationCode:(NSString *)pulc doLocationCode:(NSString *)dolc driverAge:(NSString *)da numPassengers:(NSString *)np;
- (void) appendVendorAndCarObjects:(Car *)c theVendor:(Vendor *)v;
- (void) printSession;

@end
