//
//  CallUsViewController.m
//  CarTrawler
//

#import "CallUsViewController.h"
#import "CarTrawlerAppDelegate.h"
#import "CTCareNumber.h"

@implementation CallUsViewController

@synthesize selectedNumber;
@synthesize numberPickerView;
@synthesize numbers;
@synthesize numberPicker;
@synthesize callUsButton;
@synthesize ctCountry;

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
	numberPicker.frame = CGRectMake(0.0, 61.0, 312, 216);
	[numberPickerView addSubview:numberPicker];
	
	UIImageView *pickerOutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"callPickerPop.png"]];
	[numberPickerView addSubview:pickerOutline];
	[numberPickerView bringSubviewToFront:pickerOutline];
	
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(255, 25, 50, 30);
    [doneButton addTarget:self action:@selector(saveCountryChoice) forControlEvents:UIControlEventTouchUpInside];
    [numberPickerView addSubview:doneButton];
	
	[numberPickerView setHidden:NO];
	[numberPicker setHidden:NO];
}

- (void) viewWillAppear:(BOOL)animated {
	CarTrawlerAppDelegate *appDelegate = (CarTrawlerAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.numbers = appDelegate.customerCareNumbers;
    
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	ctCountry = [[CTCountry alloc] init];
	ctCountry.isoCountryCode = [prefs objectForKey:@"ctCountry.isoCountryCode"];

	self.selectedNumber = nil;
	CTCareNumber *num = (CTCareNumber *)[numbers objectAtIndex:0];
    
	[numberPicker reloadAllComponents];

    [numberPicker selectRow:0 inComponent:0 animated:YES];
    
    //  Sets row to country of residence
    int index = 0;
    for ( CTCareNumber *n in numbers ) {

        if ([n.isoCountryCode isEqualToString:ctCountry.isoCountryCode]) {
            num = n;
            [numberPicker selectRow:index inComponent:0 animated:YES];
        }
        index++;
    }
    
    
	[self setSelectedNumber:num.careNumber];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[numberPicker setHidden:YES];
	
	[self showCountryPickerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    /*
	[callUsButton release];
	callUsButton = nil;

	[numberPicker release];
	numberPicker = nil;

	[numberPickerView release];
	numberPickerView = nil;

	[selectedNumber release];
	selectedNumber = nil;

    [super dealloc];*/
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
	return [numbers count];
}

- (NSString *) pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	CTCareNumber *num = (CTCareNumber *)[numbers objectAtIndex:row];
	return [NSString stringWithFormat:@"%@", num.countryName];
}

- (void) pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	DLog(@"Have selected row...");
	self.selectedNumber = nil;
	CTCareNumber *num = (CTCareNumber *)[numbers objectAtIndex:row];
	[self setSelectedNumber:num.careNumber];
}

@end
