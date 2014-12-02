//
//  RentalSession.h
//  CarTrawler
//
//

@class Vendor, Car, CTLocation, InsuranceObject;

@interface RentalSession : NSObject {
	NSString	*puDateTime;
	NSString	*doDateTime;
	
	NSString	*readablePuDateTimeString;
	NSString	*readableDoDateTimeString;
	
	NSString	*puLocationCode;
	NSString	*doLocationCode;
	
	NSString	*puLocationNameString;
	NSString	*doLocationNameString;
	
	NSString	*homeCountry;
	
	NSString	*driverAge;
	NSString	*numPassengers;
	
	NSString	*activeCurrency;
	
	NSString	*flightNumber;
	
	Car			*theCar;
	Vendor		*theVendor;
	
	NSMutableArray	*extras;
	
	NSDate		*startDate;
	NSDate		*endDate;
	
	CTLocation	*puLocation;
	CTLocation	*doLocation;
	
	InsuranceObject	*insurance;
	
	BOOL		hasBoughtInsurance;
}

@property (nonatomic, assign) BOOL hasBoughtInsurance;
@property (nonatomic, copy) NSString *activeCurrency;
@property (nonatomic, retain) InsuranceObject *insurance;
@property (nonatomic, copy) NSString *flightNumber;
@property (nonatomic, retain) CTLocation *puLocation;
@property (nonatomic, retain) CTLocation *doLocation;
@property (nonatomic, copy) NSString *readablePuDateTimeString;
@property (nonatomic, copy) NSString *readableDoDateTimeString;
@property (nonatomic, copy) NSString *puLocationNameString;
@property (nonatomic, copy) NSString *doLocationNameString;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSMutableArray *extras;
@property (nonatomic, copy) NSString *driverAge;
@property (nonatomic, copy) NSString *numPassengers;
@property (nonatomic, copy) NSString *homeCountry;
@property (nonatomic, copy) NSString *puDateTime;
@property (nonatomic, copy) NSString *doDateTime;
@property (nonatomic, copy) NSString *puLocationCode;
@property (nonatomic, copy) NSString *doLocationCode;
@property (nonatomic, retain) Car *theCar;
@property (nonatomic, retain) Vendor *theVendor;

- (id) initWithHomeCountry:(NSString *)hc puDateTime:(NSString *)pudt doDateTime:(NSString *)dodt puLocationCode:(NSString *)pulc doLocationCode:(NSString *)dolc driverAge:(NSString *)da numPassengers:(NSString *)np;
- (void) appendVendorAndCarObjects:(Car *)c theVendor:(Vendor *)v;
- (void) printSession;

@end
