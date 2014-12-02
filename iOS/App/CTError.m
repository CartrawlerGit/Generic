//
//  CTError.m
//  CarTrawler
//
//

#import "CTError.h"

@implementation CTError

@synthesize errorType;
@synthesize errorShortTxt;
@synthesize errorTxt;

- (void)dealloc
{
	[errorType release];
	[errorShortTxt release];
	[errorTxt release];

	[super dealloc];
}


- (id) initFromErrorRS:(NSDictionary *)err {

	self.errorType = [err objectForKey:@"@Type"];
	self.errorShortTxt = [err objectForKey:@"@ShortText"];
	self.errorTxt = [err objectForKey:@"#text"];
    self.errorShortTxt = [self.errorShortTxt stringByReplacingOccurrencesOfString:@"&#039;"
                                         withString:@"'"];
	
	DLog(@"Error (%@): %@", self.errorType, self.errorShortTxt);
	
	if ([self.errorShortTxt isEqualToString:@"365"]) {
		self.errorShortTxt = @"There has been a problem with the credit card number, please make sure it is correct and try again";
	} else if ([self.errorType isEqualToString:@"10023"]) {
		self.errorShortTxt = @"The card number appears to be invalid, please make sure it is correct and try again.";
	} else if ([self.errorType isEqualToString:@"189"]) {
		self.errorShortTxt = @"Payment has not been authorised.";
	} else if ([self.errorType isEqualToString:@"240"]) {
		self.errorShortTxt = @"The credit card supplied is expired.";
	} else if ([self.errorType isEqualToString:@"10005"]) {
		self.errorShortTxt = @"There has been a problem processing your credit card.";
	} else if ([self.errorType isEqualToString:@"10009"]) {
		self.errorShortTxt = @"There has been a problem with the verification number you provided, please check it and try again.";
	} else if ([self.errorType isEqualToString:@"10011"]) {
		self.errorShortTxt = @"The card number supplied does not match the type of card selected, please check your details and try again.";
	} else if ([self.errorType isEqualToString:@"10012"]) {
		self.errorShortTxt = @"Invalid credit card issue number.";
	} else if ([self.errorType isEqualToString:@"10017"]) {
		self.errorShortTxt = @"The car you are attempting to book is no longer available, please search for another.";
	} else if ([self.errorType isEqualToString:@"10021"]) {
		self.errorShortTxt = @"We are having difficulties and are unable to process your request at this time, please try again in a few moments.";
	} else if ([self.errorType isEqualToString:@"10022"]) {
		self.errorShortTxt = @"The supplied credit card has expired, please insert new card details and try again.";
	} else if ([self.errorType isEqualToString:@"10024"]) {
		self.errorShortTxt = @"Card numbers must only contain numbers, please correct the credit card number and try again.";
	} else if ([self.errorType isEqualToString:@"10026"]) {
		self.errorShortTxt = @"The card expiry month is invalid, please correct it and try again.";
	}
	
	return self;
}

@end
