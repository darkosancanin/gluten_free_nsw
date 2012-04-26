#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CLGeocoder.h>
#import "RetrieveGPSLocationControllerDelegate.h"
#import "GANTracker.h"

@interface RetrieveGPSLocationController : UIViewController<CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLGeocoder *geoCoder;
	IBOutlet UILabel *activityLabel;
	NSObject<RetrieveGPSLocationControllerDelegate> *delegate;
	CLLocation *bestEffortAtLocation;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLGeocoder *geoCoder;
@property (nonatomic, retain) IBOutlet UILabel *activityLabel;
@property (nonatomic, retain) NSObject<RetrieveGPSLocationControllerDelegate> *delegate;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;

- (void)stopUpdatingLocation;
- (void)updatingLocationTimedOut;
- (void)startUpdatingAddressForLocation:(CLLocation *)location;
- (void)updatingAddressTimedOut;

@end
