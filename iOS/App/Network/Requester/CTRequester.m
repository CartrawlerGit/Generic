//
//  CTRequester.m
//  CarTrawler
//
//  Created by Igor Ferreira on 8/2/15.
//  Copyright (c) 2015 www.cartrawler.com. All rights reserved.
//

#import "CTRequester.h"

@implementation CTRequester

+ (ASIHTTPRequest *)postRequestWitUrl:(NSURL *)url data:(NSData *)data andDelegate:(id<ASIHTTPRequestDelegate>)delegate
{
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:delegate];
	[request appendPostData:data];
	[request setRequestMethod:@"POST"];
	[request setShouldStreamPostDataFromDisk:YES];
	[request setAllowCompressedResponse:YES];
	
	[request startAsynchronous];
	
	return request;
}

@end
