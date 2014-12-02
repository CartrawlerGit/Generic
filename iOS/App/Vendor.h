//
//  Vendor.h
//  CarTrawler
//
//


@interface Vendor : NSObject
{
	NSString		*vendorID;
	NSMutableArray	*availableCars;	
	BOOL			atAirport;
	NSString		*locationCode;
	NSString		*venLocationName;
	NSString		*venAddress;
	NSString		*venCountryCode;
	NSString		*venPhone;
	NSString		*venLogo;
	NSString		*vendorCode;
	NSString		*vendorName;
	NSString		*vendorDivision;
	Vendor			*dropoffVendor;
}

@property (nonatomic, copy) NSString *vendorCode;
@property (nonatomic, copy) NSString *vendorName;
@property (nonatomic, copy) NSString *vendorDivision;
@property (nonatomic, copy) NSString *venLogo;
@property (nonatomic, copy) NSString *vendorID;
@property (nonatomic, retain) NSMutableArray *availableCars;  // does this need to be copy now? Because of the NSCopying implementaion?
@property (nonatomic, assign) BOOL atAirport;
@property (nonatomic, copy) NSString *locationCode;
@property (nonatomic, copy) NSString *venLocationName;
@property (nonatomic, copy) NSString *venAddress;
@property (nonatomic, copy) NSString *venCountryCode;
@property (nonatomic, copy) NSString *venPhone;
@property (nonatomic,retain) Vendor *dropoffVendor;

- (id)initFromVehVendorAvailsDictionary:(NSDictionary *)vehVendorAvails;

@end


