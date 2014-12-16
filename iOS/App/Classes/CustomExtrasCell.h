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
//  CustomExtrasCell.h
//  CarTrawler
//
//


@interface CustomExtrasCell : UITableViewCell {
	UILabel		*extraNameLabel;
	UILabel		*extraCurrencyLabel;
	UILabel		*extraCostLabel;
	UILabel		*extraQtyLabel;
	
	UIButton	*plusBtn;
	UIButton	*minusBtn;
}

@property (nonatomic, retain) IBOutlet UILabel *extraQtyLabel;
@property (nonatomic, retain) IBOutlet UILabel *extraNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *extraCurrencyLabel;
@property (nonatomic, retain) IBOutlet UILabel *extraCostLabel;
@property (nonatomic, retain) IBOutlet UIButton *plusBtn;
@property (nonatomic, retain) IBOutlet UIButton *minusBtn;

- (IBAction)increaseQty:(id)sender;
- (IBAction)decreaseQty:(id)sender;
@end
