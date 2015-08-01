//
//  CarTrawlerAppDelegate.m
//  CarTrawler
//
//

#import "CarTrawlerAppDelegate.h"
#import "NSString+CSVParser.h"
#import "CTCurrency.h"
#import "CTLocation.h"
#import "CTCountry.h"
#import "CTCareNumber.h"
#import "ASIHTTPRequest.h"
#import "UIColor-Expanded.h"

#ifdef NSFoundationVersionNumber_iOS_6_1
#define SD_IS_IOS6 (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
#else
#define SD_IS_IOS6 YES
#endif

@interface CarTrawlerAppDelegate (Private)

- (void) getInfoFile;
- (void) preloadCurrencies;
- (void) preloadCountries;
- (void) preloadJSON:(NSDictionary *)dict;
- (NSString *) getSupportNumber;

@property (nonatomic, strong) CTCountry	*ctCountry;

@end

@implementation UINavigationBar (CustomImage)

- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"greyNavBar.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end

@implementation CarTrawlerAppDelegate

#pragma mark -
#pragma mark Remote JSON Control Info

- (void) resetControlWithLocalData {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"info" ofType:@"json"];
	NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSDictionary *dict = [contents JSONValue];
	[prefs setObject:dict forKey:@"cartrawler.info"];
	self.infoJSON = dict;
}

- (void) loadLocalInfoFile {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	if ([prefs objectForKey:@"cartrawler.info"]) {
		// It exists...
		
		DLog(@"We have persisted control JSON Version %li", (long)[[[prefs objectForKey:@"cartrawler.info"] objectForKey:@"version"] integerValue]);
		if ([[prefs objectForKey:@"cartrawler.info"] objectForKey:@"version"]) {
			self.infoJSON = [prefs objectForKey:@"cartrawler.info"];
		} else {
			DLog(@"We have MALFORMED JSON...amagad!");
			// Incorrectly formatted json has made it into the store, flush it with locally stored info.
			[self resetControlWithLocalData];
		}

	} else {
		[self resetControlWithLocalData];
	}
	
	[self preloadJSON:self.infoJSON];
}

- (void) preloadJSON:(NSDictionary *)dict {

	self.customerCareNumbers = [[NSMutableArray alloc] init];
	self.insuranceRegions = [[NSMutableArray alloc] init];
	
	NSDictionary *numbers = [[dict objectForKey:@"data"] objectForKey:@"contactNumbers"];
	
	self.companyName = [[dict objectForKey:@"data"] objectForKey:@"companyName"];
	self.clientID = [[dict objectForKey:@"data"] objectForKey:@"clientID"];
    
    if ([[dict objectForKey:@"data"] objectForKey:@"tintColor"]) {
        self.governingTintColor = [UIColor colorWithHexString:[[dict objectForKey:@"data"] objectForKey:@"tintColor"]];
    } else {
        self.governingTintColor = [CTHelper blueColor];
    }
    
	DLog(@"The client ID is %@", self.clientID);
    
	// This is possibly a tad on the restricted side, its element 1 in the array but a dict...
	self.engineConditionsURL = [[[[dict objectForKey:@"data"] objectForKey:@"links"] objectAtIndex:1] objectForKey:@"engine"];
	
	self.canAmendBookings = [[[dict objectForKey:@"data"] objectForKey:@"canAmendBookings"] boolValue];
	self.amendBookingsLink = [[dict objectForKey:@"data"] objectForKey:@"canAmendBookingsLink"];
    
    /*
	if (canAmendBookings) {
		DLog(@"Can amend bookings!");
	} else {
		DLog(@"Can NOT amend bookings!");
	}
    */

	for (id i in numbers) {
		CTCareNumber *num = [[CTCareNumber alloc] initFromInfoDictionary:i];
		[self.customerCareNumbers addObject:num];
		//[num release];
	}
	
	if ([[dict objectForKey:@"data"] objectForKey:@"insuranceResidences"]) {
		if ([[[dict objectForKey:@"data"] objectForKey:@"insuranceResidences"] isKindOfClass:[NSArray class]]) {
			for (id item in [[dict objectForKey:@"data"] objectForKey:@"insuranceResidences"]) {
				[self.insuranceRegions addObject:item];
			}
		}
	}
    
    [self getSupportNumber];
}

- (NSString *) getSupportNumber {

	NSMutableArray *numbers = self.customerCareNumbers;

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.ctCountry = [[CTCountry alloc] init];
    self.ctCountry.isoCountryCode = [prefs objectForKey:@"ctCountry.isoCountryCode"];
    
    CTCareNumber *defnum = (CTCareNumber *)[numbers objectAtIndex:0];
	NSString *ret = defnum.careNumber;
	
	for (CTCareNumber *n in numbers) {
		if ([n.isoCountryCode isEqualToString:self.ctCountry.isoCountryCode]) {
			ret = n.careNumber;
            DLog(@"Carenumber: %@", ret);
            [[NSUserDefaults standardUserDefaults] setObject:n.isoCountryCode forKey:@"country_preference"];
		}
	}
	if (ret) {
		return ret;
	} else {
		return @"No number available.";
	}
}


- (void) getInfoFile {
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kRemoteInfoURL]];
	[request setDelegate:self];
	[request startAsynchronous];
}
	
- (void) requestFinished:(ASIHTTPRequest *)request {
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	NSString *responseString = [request responseString];
	
	NSInteger currentVersion = [[self.infoJSON objectForKey:@"version"] integerValue];

	NSInteger newVersion = [[[responseString JSONValue] objectForKey:@"version"] integerValue];
	
	DLog(@"Comparing %li (new) and %li (current)", (long)newVersion, (long)currentVersion);
	
	if (newVersion > currentVersion){
		
		DLog(@"We have a new file!");
		
		if ([[responseString JSONValue] objectForKey:@"version"]) {
			self.infoJSON = [responseString JSONValue];
			[prefs setObject:self.infoJSON forKey:@"cartrawler.info"];
		}
		[self loadLocalInfoFile];
		
	} else if (currentVersion == 0) {
		// There has been an error connecting or a 404 etc, run with the existing store.
	} else {
		DLog(@"There is no change in local & remote file versions");
		// Do nothing, the persisted store is up to date.
	}
	
	if (kShowResponse) {
		DLog(@"Response is \n\n%@\n\n", responseString);
	}
}

- (void) requestFailed:(ASIHTTPRequest *)request {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	if ([prefs objectForKey:@"cartrawler.info"]) {
		self.infoJSON = [prefs objectForKey:@"cartrawler.info"];
	} else {
		[self loadLocalInfoFile];
	}
	
	NSError *error = [request error];
	DLog(@"Error is %@", error);
}

#pragma mark -
#pragma mark Datasource Housekeeping

- (void) preloadCurrencies {
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	self.preloadedCurrencyList = [[NSMutableArray alloc] init];
	
	NSString *paths = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [paths stringByAppendingPathComponent:@"CTCurrency.csv"];
    NSError * error = nil;
     NSString *dataFile = [[NSString alloc] initWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:&error ];
	NSArray *csvDump = [dataFile csvRows];
	for (int i = 0; i < [csvDump count]; i++) {
		CTCurrency *currency = [[CTCurrency alloc] initFromArray:[csvDump objectAtIndex:i]];
		[self.preloadedCurrencyList addObject:currency];
		//[currency release];
	}
	DLog(@"Finished Loading currencies");
	//[dataFile release];
	//[pool release];
}

- (void) preloadCountries {
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	self.preloadedCountryList = [[NSMutableArray alloc] init];
	NSString *paths = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [paths stringByAppendingPathComponent:@"CTISOCountries.csv"];
    NSError * error = nil;
    NSString *dataFile = [[NSString alloc] initWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:&error ];
	NSArray *csvDump = [dataFile csvRows];
	for (int i = 0; i < [csvDump count]; i++) {
		CTCountry *country = [[CTCountry alloc] initFromArray:[csvDump objectAtIndex:i]];
		[self.preloadedCountryList addObject:country];
		//[country release];
	}
	DLog(@"Finished Loading countries");
	//[dataFile release];
	//[pool release];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
//	[FlurryAPI startSession:kFlurryKey];
	
	[self loadLocalInfoFile];
	[self getInfoFile];
    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = self.tabBarController;
    } else {
        [self.window addSubview:self.tabBarController.view];
        self.window.rootViewController = self.tabBarController;
    }
    [self.window makeKeyAndVisible];
	
	[self preloadCountries];
	[self performSelectorInBackground:@selector(preloadCurrencies) withObject:nil];
    
    // sets the background for the navigation bar
    if (SD_IS_IOS6) {
        UIImage *image = [UIImage imageNamed: @"greyNavBar.png"];
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    // sets the tint color for the buttons inside the navigation bar
    [[UIBarButtonItem appearance] setTintColor:self.governingTintColor];
    

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [[NSUserDefaults standardUserDefaults] setObject:build forKey:@"build_preference"];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"version_preference"];
    
    return YES;
}

- (void) applicationWillResignActive:(UIApplication *)application {

}

- (void) applicationDidEnterBackground:(UIApplication *)application {

}

- (void) applicationWillEnterForeground:(UIApplication *)application {

}

- (void) applicationDidBecomeActive:(UIApplication *)application {

}

- (void) applicationWillTerminate:(UIApplication *)application {

}

#pragma mark -
#pragma mark Memory management

- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

@end

