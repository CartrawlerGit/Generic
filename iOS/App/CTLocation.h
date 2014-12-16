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
//  CTLocation.h
//  CarTrawler
//
//

@interface CTLocation : NSObject <MKAnnotation> {
	NSString				*title;
	NSString				*subtitle;
	NSString				*iconImage;
	CLLocationCoordinate2D	coordinate;
	
	BOOL		atAirport;
	NSString	*iataCode;
	NSString	*locationCode;
	NSString	*codeContext;
	NSString	*locationName;
	NSString	*locationCityName;
	NSString	*addressLine;
	NSString	*countryCode;
	
	// Location Info for built in annotation
	CLLocation	*location;
	NSString	*distance;
	NSString	*distanceMetric;
}

@property (nonatomic, copy) NSString *iconImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) BOOL atAirport;
@property (nonatomic, copy) NSString *locationCityName;
@property (nonatomic, copy) NSString *iataCode;
@property (nonatomic, copy) NSString *locationCode;
@property (nonatomic, copy) NSString *codeContext;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *addressLine;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *distanceMetric;

- (id) initFromDictionary:(NSDictionary *)response;

- (id) initShortLocationFromDictionary:(NSDictionary *)response;

@end
