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
//  CTForwardGeocoder.h
//  CarTrawler
//

#import <Foundation/Foundation.h>
#import "CTGoogleV2KmlParser.h"
#import "CTGoogleV3KmlParser.h"

// Enum for geocoding status responses
enum {
	G_GEO_SUCCESS = 200,
	G_GEO_BAD_REQUEST = 400,
	G_GEO_SERVER_ERROR = 500,
	G_GEO_MISSING_QUERY = 601,
	G_GEO_UNKNOWN_ADDRESS = 602,
	G_GEO_UNAVAILABLE_ADDRESS = 603,
	G_GEO_UNKNOWN_DIRECTIONS = 604,
	G_GEO_BAD_KEY = 610,
	G_GEO_TOO_MANY_QUERIES = 620	
};

@protocol CTForwardGeocoderDelegate<NSObject>

@required

-(void)forwardGeocoderFoundLocation;

@optional

-(void)forwardGeocoderError:(NSString *)errorMessage;

@end

@interface CTForwardGeocoder : NSObject {
	NSString *searchQuery;
	NSString *googleAPiKey;
	int status;
	NSArray *results;
	id __weak delegate;
}

- (id) initWithDelegate:(id<CTForwardGeocoderDelegate, NSObject>)del;
- (void) findLocation:(NSString *)searchString;

@property (weak) id delegate;
@property (nonatomic, strong) NSString *searchQuery;
@property (nonatomic, readonly) int status;
@property (nonatomic, strong) NSArray *results;

@end
