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
//  InsuranceObject.h
//  CarTrawler
//


@interface InsuranceObject : NSObject {
	NSString	*planID;
	NSString	*name;
	NSString	*detailURL;
	NSString	*costAmount;
	NSString	*costCurrencyCode;
	NSString	*premiumAmount;
	NSString	*premiumCurrencyCode;
	NSString	*timestamp;
}

@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *planID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detailURL;
@property (nonatomic, copy) NSString *costAmount;
@property (nonatomic, copy) NSString *costCurrencyCode;
@property (nonatomic, copy) NSString *premiumAmount;
@property (nonatomic, copy) NSString *premiumCurrencyCode;

- (id) initFromDict:(NSDictionary *)dict;

@end

/* Sample Response
 
 {
	 "PlanForQuoteRS": {
		"@PlanID": "CTWNOST-042009",
		"@Name": "Excess Cover Norway",
		"@Type": "Protection",
		"QuoteDetail": {
			"ProviderCompany": {
				"@CompanyShortName": "MONDIAL"
				},
			"QuoteDetailURL": "http://213.41.31.43/CTW/NO/EN/CTW_NO_en_TCs.pdf"
			},
		"InsCoverageDetail": {
			"@Type": "SingleTrip",
			"CoverageRequirements": {
				"CoverageRequirement": {
					"@CoverageType": "12",
					"PolicyLimit": {
						"@Amount": "2800.66",
						"@CurrencyCode": "GBP"
						}
					}
			},
			"TotalTripCost": {
				"@Amount": "154.27",
				"@Currency": "NOK"
			}
		},
		"PlanCost": {
			"@Amount": "5.14",
			"@CurrencyCode": "GBP",
			"BasePremium": {
				"@Amount": "47.73",
				"@CurrencyCode": "NOK"
			}	
		}
	},
	"Success": { }
 }
 
 */