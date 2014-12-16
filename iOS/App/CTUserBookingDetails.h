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
//  CTUserBookingDetails.h
//  CarTrawler
//
//

#import <Foundation/Foundation.h>

@interface CTUserBookingDetails : NSObject {

	NSString *namePrefix;
	NSString *givenName;
	NSString *surname;
	NSString *phoneAreaCode;
	NSString *phoneNumber;
	NSString *emailAddress;
	NSString *address;
	NSString *countryCode;
	
	NSString *ccHolderName;
	NSString *ccNumber;
	NSString *ccExpDate;
	NSString *ccSeriesCode;
	NSInteger cardType;
	
}

@property (nonatomic,retain) NSString *namePrefix;
@property (nonatomic,retain) NSString *givenName;
@property (nonatomic,retain) NSString *surname;
@property (nonatomic,retain) NSString *phoneAreaCode;
@property (nonatomic,retain) NSString *phoneNumber;
@property (nonatomic,retain) NSString *emailAddress;
@property (nonatomic,retain) NSString *address;
@property (nonatomic,retain) NSString *countryCode;

@property (nonatomic,retain) NSString *ccHolderName;
@property (nonatomic,retain) NSString *ccNumber;
@property (nonatomic,retain) NSString *ccExpDate;
@property (nonatomic,retain) NSString *ccSeriesCode;
@property (nonatomic,assign) NSInteger cardType;


@end
