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
