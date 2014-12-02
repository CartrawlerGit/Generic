//
//  InsuranceTermsViewController.h
//  CarTrawler
//
//

@class InsuranceObject;

@interface InsuranceTermsViewController : UIViewController <UIWebViewDelegate> {
	InsuranceObject	*ins;
	
	UIActivityIndicatorView	*spinner;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) InsuranceObject *ins;

- (IBAction) dismissView;

@end
