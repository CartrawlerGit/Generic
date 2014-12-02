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