//
//  CTLocation.h
//  CarTrawler
//
//

@interface CTLocation : NSObject <MKAnnotation> {
	NSString				*title;
	NSString				*subtitle;
	NSString				*iconImage;
	CLLocationCoordinate2D	coordinate;
	
	BOOL		atAirport;
	NSString	*iataCode;
	NSString	*locationCode;
	NSString	*codeContext;
	NSString	*locationName;
	NSString	*locationCityName;
	NSString	*addressLine;
	NSString	*countryCode;
	
	// Location Info for built in annotation
	CLLocation	*location;
	NSString	*distance;
	NSString	*distanceMetric;
}

@property (nonatomic, copy) NSString *iconImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) BOOL atAirport;
@property (nonatomic, copy) NSString *locationCityName;
@property (nonatomic, copy) NSString *iataCode;
@property (nonatomic, copy) NSString *locationCode;
@property (nonatomic, copy) NSString *codeContext;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *addressLine;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *distanceMetric;

- (id) initFromDictionary:(NSDictionary *)response;

- (id) initShortLocationFromDictionary:(NSDictionary *)response;

@end
