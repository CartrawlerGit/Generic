//
//  CarHireTargetTests.m
//  CarHireTargetTests
//
//  Created by Igor Ferreira on 8/2/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "Fee+NSDictionary.h"

@interface CarHireTargetTests : XCTestCase

@end

@interface Fee (Private)

+ (NSString *)parsePurpose:(NSString *)purpose;

@end

@implementation CarHireTargetTests

- (void)testExample {
	NSDictionary *feeDictionary = @{@"@Amount":@"23.45", @"@CurrencyCode":@"BRL", @"@Purpose":@"23"};
	
	id feeMock = OCMClassMock([Fee class]);
	OCMExpect([feeMock parsePurpose:[OCMArg any]]).andForwardToRealObject;
	
	Fee *mockedFee = [Fee feeWithDictionary:feeDictionary];
	
	OCMVerifyAll(feeMock);
	
	XCTAssertEqualObjects(mockedFee.feeAmount, @"23.45");
	XCTAssertEqualObjects(mockedFee.feeCurrencyCode, @"BRL");
	XCTAssertEqualObjects(mockedFee.feePurpose, @"23");
	XCTAssertEqualObjects(mockedFee.feePurposeDescription, @"Fee to pay on arrival.");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
		[self testExample];
    }];
}

@end
