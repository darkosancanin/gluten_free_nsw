#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
#import "RetrieveGPSLocationControllerDelegate.h"


@interface RetrieveGPSLocationController : UIViewController<CLLocationManagerDelegate,MKReverseGeocoderDelegate> {
	CLLocationManager *locationManager;
	MKReverseGeocoder *geoCoder;
	IBOutlet UILabel *activityLabel;
	NSObject<RetrieveGPSLocationControllerDelegate> *delegate;
	CLLocation *bestEffortAtLocation;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) MKReverseGeocoder *geoCoder;
@property (nonatomic, retain) IBOutlet UILabel *activityLabel;
@property (nonatomic, retain) NSObject<RetrieveGPSLocationControllerDelegate> *delegate;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;

- (void)stopUpdatingLocation;
- (void)updatingLocationTimedOut;
- (void)startUpdatingAddressForLocation:(CLLocation *)location;
- (void)updatingAddressTimedOut;

@end
