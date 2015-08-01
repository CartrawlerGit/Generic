//
//  ShowLocationViewController.m
//  CarTrawler
//

#import "ShowLocationViewController.h"
#import "CTLocation.h"
#import "CustomPlacemark.h"
#import "CTHudViewController.h"
#import "CTLocation.h"

@implementation ShowLocationViewController

#pragma mark -
#pragma mark UIViewController Methods

- (void) getLocationFromString {
	if (self.coordString != nil) {
		
		NSLog(@"Coord string is %@", self.coordString);
		
		NSArray *coords = [self.coordString componentsSeparatedByString: @","];
		
		CLLocation *location = [[CLLocation alloc] initWithLatitude:[[coords objectAtIndex:0] doubleValue] longitude:[[coords objectAtIndex:1] doubleValue]];
		
		CTLocation *loc = [[CTLocation alloc] init];
		loc.location = location;
		loc.coordinate = location.coordinate;
		loc.iconImage = @"pointer_blue.png";
		
		[self.locationMap addAnnotation:loc];
		
		[self zoomToFitMapAnnotations:self.locationMap];
	} else {
		// Nothing to do yet
		DLog(@"Doesn't appear to have a coord yet, %@", self.coordString);
	}
	
}

- (id) init {
    self=[super initWithNibName:@"ShowLocationViewController" bundle:nil];
    return self;
}

- (id) initWithNibName:(NSString *)n bundle:(NSBundle *)b {
    return [self init];
}

- (void) viewDidLoad {
    [super viewDidLoad];
	
	[self getLocationFromString];
	
	UIButton *closeBtn = [CTHelper getSmallGreenUIButtonWithTitle:@"Close"];
	[closeBtn setFrame:CGRectMake(85, [[UIScreen mainScreen] bounds].size.height - closeBtn.frame.size.height - 10, closeBtn.frame.size.width, closeBtn.frame.size.height)];
	[closeBtn addTarget:self action:@selector(dismissModalView:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:closeBtn];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
    [super viewDidUnload];
}

#pragma mark -
#pragma mark IBActions

- (IBAction) dismissModalView:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark MKMapView Stuff

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control { }

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(CTLocation *)annotation {
    if( [[annotation title] isEqualToString:@"Current Location"] ) {
		return nil;
	}
	if([annotation isKindOfClass:[CustomPlacemark class]])
	{
		MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:[annotation title]];
		newAnnotation.pinColor = MKPinAnnotationColorGreen;
		newAnnotation.animatesDrop = YES; 
		newAnnotation.canShowCallout = YES;
		newAnnotation.enabled = YES;
		//[newAnnotation autorelease];
		
		return newAnnotation;
	} else {
		MKAnnotationView *annotationView = [aMapView dequeueReusableAnnotationViewWithIdentifier:@"spot"];
		if(!annotationView) {
			annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"spot"];
			annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			annotationView.enabled = YES;
			annotationView.canShowCallout = YES;
			
		}
		annotationView.image = [UIImage imageNamed:annotation.iconImage];
		return annotationView;
	}
}

- (void) zoomToFitMapAnnotations:(MKMapView *) mapView {
	if([mapView.annotations count] == 0)
        return;
	
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
	
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
	
    for(CTLocation *annotation in mapView.annotations) {
		topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
		topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
		
		bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
		bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
		
    }
	
    MKCoordinateRegion region;
	
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
	region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
	
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}
@end
