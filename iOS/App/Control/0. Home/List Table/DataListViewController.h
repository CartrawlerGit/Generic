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
//  DataListViewController.h
//  CarTrawler
//
//

@class CTCountry;

@interface DataListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *indexedTableContents;
@property (nonatomic, strong) NSMutableArray *tableIndex;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, weak) IBOutlet UILabel *aTitleLabel;
@property (nonatomic, strong) NSMutableArray *tableContents;
@property (nonatomic, assign) BOOL countryMode;
@property (nonatomic, assign) BOOL currencyMode;
@property (nonatomic, weak) IBOutlet UITableView *dataTable;

- (IBAction) dismissView;
@end
