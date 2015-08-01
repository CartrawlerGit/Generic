//
//  RentalSession.m
//  CarTrawler
//
//

#import "RentalSession.h"

@implementation RentalSession

@synthesize hasBoughtInsurance;
@synthesize activeCurrency;
@synthesize insurance;
@synthesize flightNumber;
@synthesize puLocation;
@synthesize doLocation;
@synthesize readablePuDateTimeString;
@synthesize readableDoDateTimeString;
@synthesize puLocationNameString;
@synthesize doLocationNameString;
@synthesize startDate;
@synthesize endDate;
@synthesize extras;
@synthesize driverAge;
@synthesize numPassengers;
@synthesize homeCountry;
@synthesize puDateTime;
@synthesize doDateTime;
@synthesize puLocationCode;
@synthesize doLocationCode;
@synthesize theCar;
@synthesize theVendor;

- (id) initWithHomeCountry:(NSString *)hc puDateTime:(NSString *)pudt doDateTime:(NSString *)dodt puLocationCode:(NSString *)pulc doLocationCode:(NSString *)dolc driverAge:(NSString *)da numPassengers:(NSString *)np {
	self.homeCountry = hc;
	self.puDateTime = pudt;
	self.doDateTime = dodt;
	self.puLocationCode = pulc;
	self.doLocationCode = dolc;
	self.driverAge = da;
	self.numPassengers = np;
	
	return self;
}

- (void) appendVendorAndCarObjects:(Car *)c theVendor:(Vendor *)v {
	self.theCar = c;
	self.theVendor = v;
}

- (void) printSession {
	DLog(@"\n\nSession is \nhomeCountry - %@\npuDateTime - %@\ndoDateTime - %@\npuLocationCode - %@\ndoLocationCode - %@\ndriverAge - %@\nnumPassengers - %@\nPu Location and time is: %@ - %@\nDo Location and time is: %@ - %@\nFlight Number is: %@\nActive Currency is: %@\n\n", self.homeCountry, self.puDateTime, self.doDateTime, self.puLocationCode, self.doLocationCode, self.driverAge, self.numPassengers, self.puLocationNameString, self.readablePuDateTimeString, self.doLocationNameString, self.readableDoDateTimeString, self.flightNumber, self.activeCurrency);
}

- (NSString *)description {
	return [NSString stringWithFormat:@"\n\nSession is \nhomeCountry - %@\npuDateTime - %@\ndoDateTime - %@\npuLocationCode - %@\ndoLocationCode - %@\ndriverAge - %@\nnumPassengers - %@\n\n", self.homeCountry, self.puDateTime, self.doDateTime, self.puLocationCode, self.doLocationCode, self.driverAge, self.numPassengers];
}


@end
