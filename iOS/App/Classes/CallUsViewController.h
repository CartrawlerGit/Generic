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
//  CallUsViewController.h
//  CarTrawler
//
#import "CTCountry.h"

@interface CallUsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	UIButton		*callUsButton;
	UIPickerView	*numberPicker;
	
	NSMutableArray	*numbers;
	UIView			*numberPickerView;
	NSString		*selectedNumber;
    
	CTCountry			*ctCountry;
}
@property (nonatomic, retain) CTCountry *ctCountry;
@property (nonatomic, copy) NSString *selectedNumber;
@property (nonatomic, retain) IBOutlet UIView *numberPickerView;
@property (nonatomic, copy) NSMutableArray *numbers;
@property (nonatomic, retain) IBOutlet UIPickerView *numberPicker;
@property (nonatomic, retain) UIButton *callUsButton;

- (IBAction) callUs:(id)sender;

@end
