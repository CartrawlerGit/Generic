//
//  ShowLocationViewController.h
//  CarTrawler
//

@interface ShowLocationViewController : UIViewController <MKMapViewDelegate, ASIHTTPRequestDelegate> {
	MKMapView	*locationMap;
	NSString	*coordString;
}

@property (nonatomic, copy) NSString *coordString;
@property (nonatomic, retain) IBOutlet MKMapView *locationMap;

- (IBAction) dismissModalView:(id)sender;
- (void) zoomToFitMapAnnotations:(MKMapView *) mapView;

@end
