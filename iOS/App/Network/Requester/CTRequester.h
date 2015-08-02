//
//  CTRequester.h
//  CarTrawler
//
//  Created by Igor Ferreira on 8/2/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASIHTTPRequest;
@protocol ASIHTTPRequestDelegate;

@interface CTRequester : NSObject

+ (ASIHTTPRequest *)postRequestWitUrl:(NSURL *)url data:(NSData *)data andDelegate:(id<ASIHTTPRequestDelegate>)delegate;

@end
