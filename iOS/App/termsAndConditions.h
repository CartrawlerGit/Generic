//
//  termsAndConditions.h
//  CarTrawler
//
//

#import <Foundation/Foundation.h>


@interface termsAndConditions : NSObject 
{
	NSMutableString	*titleText;
	NSMutableString	*bodyText;
	NSMutableArray *arrayBodyText;
}
	
	@property (nonatomic, copy) NSMutableString *titleText;
	@property (nonatomic, copy) NSMutableString *bodyText;
	@property (nonatomic, copy) NSMutableArray *arrayBodyText;
	
- (id)initFromDictionary:(NSDictionary *)TQ_Dictionary;

	@end
	
