//
//  CallUsViewController.m
//  CarTrawler
//

#import "CallUsViewController.h"
#import "CarTrawlerAppDelegate.h"
#import "CTCareNumber.h"

@implementation CallUsViewController

#pragma mark -
#pragma mark Picker Control

- (void) callPhoneNumber {
	
	//[FlurryAPI logEvent:[NSString stringWithFormat:@"Has called %@ for customer service.", self.selectedNumber]];
	
	NSString *number = [NSString stringWithFormat:@"tel://%@", self.selectedNumber];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}

- (void) showAlert {
	if (!self.selectedNumber) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select the number you wish to dial from the picker and press the green call button." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		[alert show];
		//[alert release];
	} else {
		NSString *alertTitle = [NSString stringWithFormat:@"You are about to leave this app to dial %@, would you like to continue?", self.selectedNumber];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:alertTitle delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		[alert show];
		//[alert release];
	}
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[self callPhoneNumber];
		
    } else {
		DLog(@"hit %li", (long)buttonIndex);
	}
}

- (void)saveCountryChoice {
	[self showAlert];
}

- (void)showCountryPickerView {
	self.numberPicker.frame = CGRectMake(0.0, 61.0, 312, 216);
	[self.numberPickerView addSubview:self.numberPicker];
	
	UIImageView *pickerOutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"callPickerPop.png"]];
	[self.numberPickerView addSubview:pickerOutline];
	[self.numberPickerView bringSubviewToFront:pickerOutline];
	
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(255, 25, 50, 30);
    [doneButton addTarget:self action:@selector(saveCountryChoice) forControlEvents:UIControlEventTouchUpInside];
    [self.numberPickerView addSubview:doneButton];
	
	[self.numberPickerView setHidden:NO];
	[self.numberPicker setHidden:NO];
}

- (void) viewWillAppear:(BOOL)animated {
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.numbers = appDelegate.customerCareNumbers;
    
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"ctCountry.userPrefs"];
	self.ctCountry =  [NSKeyedUnarchiver unarchiveObjectWithData:data];

	self.selectedNumber = nil;
	CTCareNumber *num = (CTCareNumber *)[self.numbers objectAtIndex:0];
    
	[self.numberPicker reloadAllComponents];

    [self.numberPicker selectRow:0 inComponent:0 animated:YES];
    
    //  Sets row to country of residence
    int index = 0;
    for ( CTCareNumber *n in self.numbers ) {

        if ([n.isoCountryCode isEqualToString:self.ctCountry.isoCountryCode]) {
            num = n;
            [self.numberPicker selectRow:index inComponent:0 animated:YES];
        }
        index++;
    }
    
    
	[self setSelectedNumber:num.careNumber];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.numberPicker setHidden:YES];
	
	[self showCountryPickerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark -

- (IBAction) callUs:(id)sender {
}

#pragma mark -
#pragma mark UIPickerViews

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.numbers count];
}

- (NSString *) pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	CTCareNumber *num = (CTCareNumber *)[self.numbers objectAtIndex:row];
	return [NSString stringWithFormat:@"%@", num.countryName];
}

- (void) pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	DLog(@"Have selected row...");
	self.selectedNumber = nil;
	CTCareNumber *num = (CTCareNumber *)[self.numbers objectAtIndex:row];
	[self setSelectedNumber:num.careNumber];
}

@end
