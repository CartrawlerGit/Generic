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
//  CTLocationAnnotation.h
//  CarTrawler
//
//

@interface CTLocationAnnotation : NSObject <MKAnnotation> 
{ 
	NSString *_ctCodeID;
	CLLocationCoordinate2D _coordinate;
	NSString *_title;
	NSString *_subtitle;
	NSString *_type;
	NSString *_icon;
}

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate; 
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@property (nonatomic, copy) NSString *ctCodeID;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *icon;

@end
