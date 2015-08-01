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
//  CTKmlResult.h
//  CarTrawler
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CTAddressComponent.h"

@interface CTKmlResult : NSObject {
	NSString *address;
	NSString *countryNameCode;
	NSString *countryName;
	NSString *subAdministrativeAreaName;
	NSString *localityName;
	
	float viewportSouthWestLat;
	float viewportSouthWestLon;
	float viewportNorthEastLat;
	float viewportNorthEastLon;
	float boundsSouthWestLat;
	float boundsSouthWestLon;
	float boundsNorthEastLat;
	float boundsNorthEastLon;
	float latitude;
	float longitude;
	float height;
	
	NSInteger accuracy;
	NSArray *addressComponents;
}

@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) NSInteger accuracy;
@property (nonatomic, strong) NSString *countryNameCode;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *subAdministrativeAreaName;
@property (nonatomic, strong) NSString *localityName;
@property (nonatomic, strong) NSArray *addressComponents;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;


@property (nonatomic, assign) float viewportSouthWestLat;
@property (nonatomic, assign) float viewportSouthWestLon;
@property (nonatomic, assign) float viewportNorthEastLat;
@property (nonatomic, assign) float viewportNorthEastLon;
@property (nonatomic, assign) float boundsSouthWestLat;
@property (nonatomic, assign) float boundsSouthWestLon;
@property (nonatomic, assign) float boundsNorthEastLat;
@property (nonatomic, assign) float boundsNorthEastLon;



@property (readonly) CLLocationCoordinate2D coordinate;
@property (readonly) MKCoordinateSpan coordinateSpan;
@property (readonly) MKCoordinateRegion coordinateRegion;

- (NSArray *) findAddressComponent:(NSString*)typeName;

@end
