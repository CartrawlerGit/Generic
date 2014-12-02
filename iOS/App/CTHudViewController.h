//
//  CTHudViewController.h
//  CarTrawler
//
//

@interface CTHudViewController : UIViewController {
	
	UIView *blankingView;
	UILabel *titleLabel;
	NSString *alerttitle;
	UIView *roundRectView;
}

@property (nonatomic, retain) NSString *alerttitle;

-(void)show;
-(void)hide;
- (id) initWithTitle:(NSString *)_t;


@end
