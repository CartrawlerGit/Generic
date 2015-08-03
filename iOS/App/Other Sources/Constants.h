//
//  Constants.h
//  CarTrawler
//

#define kShowResponse						1
#define kShowRequest						1
#define MODE								0 // 0 for test, 1 for production

#define	kRemoteInfoURL						@"https://www.cartrawler.com/client/ios/info.json"

#define	kFlurryKey							@"YKIMFDK8LJLKK5MJZHAX"

// NOTE, actual calls are built in CTRQBuilder for Production, Test, Client ID etc.	

#define kHeader								@"kHeader" 
#define kMobileHeader						@"kMobileHeader"				
#define kInsuranceHeader					@"kInsuranceHeader"				
#define kCancelHeader						@"kCancelHeader"				
#define kRentalReqHeader					@"kRentalReqHeader"				
#define kGetExistingBookingHeader			@"kGetExistingBookingHeader"	
#define kLocationSearchHeader				@"kLocationSearchHeader"	

#if MODE
// Production
#define kCTTestAPI							@"https://otageo.cartrawler.com/cartrawlerota/json?type="
#define kCTTestAPISecure					@"https://otasecure.cartrawler.com/cartrawlerpay/json?type="
#define kTarget								@"Production"

#else
// Test
#define kCTTestAPI							@"http://otatest.cartrawler.com:20002/cartrawlerota/json?type="
#define kCTTestAPISecure					@"http://otasecuretest.cartrawler.com:20002/cartrawlerpay/json?sec=true&type="
#define kTarget								@"Test"

#endif

// OTA API CAlls
#define kOTA_PingRQ							@"OTA_PingRQ"
#define kOTA_VehLocSearchRQ					@"OTA_VehLocSearchRQ"
#define kOTA_InsuranceQuoteRQ				@"OTA_InsuranceQuoteRQ" // use to get insurance quotes.
#define kOTA_VehLocDetailRQ					@"OTA_VehLocDetailRQ"
#define kOTA_VehAvailRateRQ					@"OTA_VehAvailRateRQ"
#define kOTA_VehResRQ						@"OTA_VehResRQ"
#define kOTA_VehCancelRQ					@"OTA_VehCancelRQ"
#define KOTA_VehRetResRQ					@"OTA_VehRetResRQ"


// Specific CT API Calls (non OTA)
#define kCT_VehCountrySearchRQ				@"CT_VehCountrySearchRQ"
#define kCT_VehLocSearchRQ					@"CT_VehLocSearchRQ"
#define kCT_FleetRQ							@"CT_FleetRQ"
#define kCT_SpecialOffersRQ					@"CT_SpecialOffers"
#define kCT_RentalConditionsRQ				@"CT_RentalConditionsRQ"
//#define kCT_VehLocSearchRQ					@"CT_VehLocSearchRQ" // This is used to get a list of return locations from one location.

// Core Location Limit Values
#define kLocationTimeout					5.0
#define kLocationAccuracy					150

// Positioning for TableView Cells
#define kLeftMargin							13.0
#define kBigLeftMargin						70.0
#define kTextFieldHeight					30.0
#define kHeightInset						7.0
#define	kInputItemWidth						190.0
#define kLeftInset							45.0
#define	kSmallLeftInset						20.0

// Special Character definitions
#define kSortDirectionAsc @"▲"
#define kSortDirectionDesc @"▼"

// Search Form placeholders

#define kPickUpTextPlaceHolder				@"Pick up location"
#define kDropOffTextPlaceHolder				@"Drop off location"

#define kPickupLabelPlaceHolder				@"Set the pick up date"
#define kDropOffLabelPlaceHolder			@"Set the return date"

#define kAgeTextPlaceHolder					@"Please enter your age"

#define kNumberOfPassengersTextHolder		@"Number of passengers"