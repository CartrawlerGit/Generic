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
//  Vendor.h
//  CarTrawler
//
//


@interface Vendor : NSObject
{
	NSString		*vendorID;
	NSMutableArray	*availableCars;	
	BOOL			atAirport;
	NSString		*locationCode;
	NSString		*venLocationName;
	NSString		*venAddress;
	NSString		*venCountryCode;
	NSString		*venPhone;
	NSString		*venLogo;
	NSString		*vendorCode;
	NSString		*vendorName;
	NSString		*vendorDivision;
	Vendor			*dropoffVendor;
}

@property (nonatomic, copy) NSString *vendorCode;
@property (nonatomic, copy) NSString *vendorName;
@property (nonatomic, copy) NSString *vendorDivision;
@property (nonatomic, copy) NSString *venLogo;
@property (nonatomic, copy) NSString *vendorID;
@property (nonatomic, retain) NSMutableArray *availableCars;  // does this need to be copy now? Because of the NSCopying implementaion?
@property (nonatomic, assign) BOOL atAirport;
@property (nonatomic, copy) NSString *locationCode;
@property (nonatomic, copy) NSString *venLocationName;
@property (nonatomic, copy) NSString *venAddress;
@property (nonatomic, copy) NSString *venCountryCode;
@property (nonatomic, copy) NSString *venPhone;
@property (nonatomic,retain) Vendor *dropoffVendor;

- (id)initFromVehVendorAvailsDictionary:(NSDictionary *)vehVendorAvails;

@end


