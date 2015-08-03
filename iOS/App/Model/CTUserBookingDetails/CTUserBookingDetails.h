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

@property (nonatomic,strong) NSString *namePrefix;
@property (nonatomic,strong) NSString *givenName;
@property (nonatomic,strong) NSString *surname;
@property (nonatomic,strong) NSString *phoneAreaCode;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *emailAddress;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *countryCode;

@property (nonatomic,strong) NSString *ccHolderName;
@property (nonatomic,strong) NSString *ccNumber;
@property (nonatomic,strong) NSString *ccExpDate;
@property (nonatomic,strong) NSString *ccSeriesCode;
@property (nonatomic,assign) NSInteger cardType;


@end
