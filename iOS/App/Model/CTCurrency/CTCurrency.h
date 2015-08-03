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
//  CTCurrency.h
//  CarTrawler
//
//

@interface CTCurrency : NSObject {
	NSString	*currencyName;
	NSString	*currencyCode;
	NSString	*currencyDisplayString;
}

@property (nonatomic, copy) NSString *currencyName;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, copy) NSString *currencyDisplayString;

- (id) initFromArray:(NSMutableArray *)csvRow;

@end
