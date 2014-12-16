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
//  CTGoogleV3KmlParser.h
//  CarTrawler
//

#import <Foundation/Foundation.h>
#import "CTKmlResult.h"
#import "CTAddressComponent.h"
#import "CTForwardGeocoder.h"

@interface CTGoogleV3KmlParser : NSObject <NSXMLParserDelegate> {
	NSMutableString *contentsOfCurrentProperty;
	int statusCode;
	NSMutableArray *results;
	NSMutableArray *addressComponents;
	NSMutableArray *typesArray;
	CTKmlResult *currentResult;
	CTAddressComponent *currentAddressComponent;
	BOOL ignoreAddressComponents;
	BOOL isLocation;
	BOOL isViewPort;
	BOOL isBounds;
	BOOL isSouthWest;
}

@property (nonatomic, readonly) int statusCode;
@property (nonatomic, readonly) NSMutableArray *results;

- (BOOL)parseXMLFileAtURL:(NSURL *)URL 
			   parseError:(NSError **)error 
			   ignoreAddressComponents:(BOOL)ignore;


@end
