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
//  CarTrawlerAppDelegate.h
//  CarTrawler
//
#import "CTCountry.h"

@interface CarTrawlerAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, ASIHTTPRequestDelegate>  {
	
	/*NSMutableArray		*preloadedCountryList;
	NSMutableArray		*preloadedCurrencyList;
	
	NSString			*countryCode;
    CTCountry           *ctCountry;
	
	NSMutableArray		*customerCareNumbers;
	NSDictionary		*infoJSON;
	
	 General App Control from the INFO.json
	
	BOOL				canAmendBookings;
	NSString			*amendBookingsLink;
	NSMutableArray		*insuranceRegions;
	NSString			*engineConditionsURL;
	NSString			*companyName;
	NSString			*clientID;
    UIColor             *governingTintColor;*/
}

- (NSString *) getSupportNumber;

@property (nonatomic, strong) UIColor *governingTintColor, *barTintColor;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *amendBookingsLink;
@property (nonatomic, copy) NSString *engineConditionsURL;
@property (nonatomic, strong) NSMutableArray *insuranceRegions;
@property (nonatomic, assign) BOOL canAmendBookings;

@property (nonatomic, copy) NSDictionary *infoJSON;

@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, strong) NSMutableArray *customerCareNumbers;
@property (nonatomic, strong) NSMutableArray *preloadedCountryList;
@property (nonatomic, strong) NSMutableArray *preloadedCurrencyList;
@property (nonatomic, weak) IBOutlet UITabBarController *tabBarController;

@end
