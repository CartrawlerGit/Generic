//
//  InsuranceObject.m
//  CarTrawler
//

#import "InsuranceObject.h"


@implementation InsuranceObject

@synthesize timestamp;
@synthesize planID;
@synthesize name;
@synthesize detailURL;
@synthesize costAmount;
@synthesize costCurrencyCode;
@synthesize premiumAmount;
@synthesize premiumCurrencyCode;

- (id) initFromDict:(NSDictionary *)dict {
	self.planID = [[dict objectForKey:@"PlanForQuoteRS"] objectForKey:@"@PlanID"];
	self.name = [[dict objectForKey:@"PlanForQuoteRS"] objectForKey:@"@Name"];
	//self.timestamp = [[dict objectForKey:@"PlanForQuoteRS"] objectForKey:@""]
	self.detailURL = [[[dict objectForKey:@"PlanForQuoteRS"] objectForKey:@"QuoteDetail"] objectForKey:@"QuoteDetailURL"];
	self.costAmount = [[[dict objectForKey:@"PlanForQuoteRS"] objectForKey:@"PlanCost"] objectForKey:@"@Amount"];
	self.costCurrencyCode = [[[dict objectForKey:@"PlanForQuoteRS"] objectForKey:@"PlanCost"] objectForKey:@"@CurrencyCode"];
	self.premiumAmount = [[[[dict objectForKey:@"PlanForQuoteRS"] objectForKey:@"PlanCost"] objectForKey:@"BasePremium"] objectForKey:@"@Amount"];
	self.premiumCurrencyCode = [[[[dict objectForKey:@"PlanForQuoteRS"] objectForKey:@"PlanCost"] objectForKey:@"BasePremium"] objectForKey:@"@CurrencyCode"];
	
	return self;
}

@end

