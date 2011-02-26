#import <CoreLocation/CoreLocation.h>
#import "RetrieveGPSLocationController.h"
#import "RetrieveGPSLocationControllerDelegate.h"
#import "LocationRepository.h"
#import "Reachability.h"

@implementation RetrieveGPSLocationController

@synthesize locationManager;
@synthesize geoCoder;
@synthesize activityLabel;
@synthesize delegate;
@synthesize bestEffortAtLocation;

- (void)viewDidLoad{
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self; 
	self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	[self.locationManager startUpdatingLocation];
	[self performSelector:@selector(updatingLocationTimedOut) withObject:nil afterDelay:15];
	
	NSError *error;
	NSString *url = @"/update_gps_location";
	NSLog(@"Track URL: %@", url);
	if (![[GANTracker sharedTracker] trackPageview:url withError:&error]) {
		NSLog(@"Error tracking page using google analytics: %@", error);
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy >= newLocation.horizontalAccuracy) {
		self.bestEffortAtLocation = newLocation;
		[LocationRepository setAccuracy:bestEffortAtLocation.horizontalAccuracy];
		NSLog(@"A new location was retrieved. Latitude:%f, Longitude:%f, Accuracy:%f",newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.horizontalAccuracy);
	}
	NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 10) return;
    if (newLocation.horizontalAccuracy < 0) return;
   
	if (newLocation.horizontalAccuracy <= 80) {
		[self stopUpdatingLocation];
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updatingLocationTimedOut) object:nil];
		NSLog(@"An accurate location was retrieved. Latitude:%f, Longitude:%f",newLocation.coordinate.latitude, newLocation.coordinate.longitude);
		[self startUpdatingAddressForLocation:newLocation];
	}
}

- (void)updatingLocationTimedOut{
	[self stopUpdatingLocation];
	if(bestEffortAtLocation != nil){
		NSLog(@"Timed out trying to retrieve location, but using best location instead.");
		[self startUpdatingAddressForLocation:bestEffortAtLocation];
	}
	else{
		[self stopUpdatingLocation];
		[geoCoder cancel];
		NSLog(@"Timed out trying to retrieve location.");
		[delegate didTimeOutWhileRetrievingGPSLocation];
		[self dismissModalViewControllerAnimated:NO];
	}
}

- (void)startUpdatingAddressForLocation:(CLLocation *)location{
	[LocationRepository setLatitude:location.coordinate.latitude];
	[LocationRepository setLongitude:location.coordinate.longitude];
	[LocationRepository setAddress:nil];
	if([Reachability reachability] == NotReachable){
		[delegate didFinishRetrievingGPSLocation];
		[self dismissModalViewControllerAnimated:NO];
		return;
	}
	activityLabel.text = @"Retrieving your address...";
	geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate];
	geoCoder.delegate=self;
	[geoCoder start];
	[self performSelector:@selector(updatingAddressTimedOut) withObject:nil afterDelay:10];
}

- (void)updatingAddressTimedOut{
	[geoCoder cancel];
	NSLog(@"Timed out trying to retrieve address.");
	[delegate didFinishRetrievingGPSLocation];
	[self dismissModalViewControllerAnimated:NO];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	if (error.code == kCLErrorDenied) {
		[locationManager stopUpdatingLocation];
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updatingLocationTimedOut) object:nil];
		[self dismissModalViewControllerAnimated:NO];
		return;
	}
	NSLog(@"Failed to retrieve location. Reason: %@",[error description]);
	[delegate didFailRetrievingGPSLocationWithError:error];
	[self dismissModalViewControllerAnimated:NO];
	[self stopUpdatingLocation];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	NSLog(@"The address was retrieved. Thoroughfare:%@, Locality:%@",placemark.thoroughfare, placemark.locality);
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updatingAddressTimedOut) object:nil];
	if(placemark.thoroughfare != nil && placemark.thoroughfare != @"null" && placemark.locality != nil && placemark.locality != @"null")
		[LocationRepository setAddress:[NSString stringWithFormat:@"%@, %@", placemark.thoroughfare, placemark.locality]];
	else
		[LocationRepository setAddress:nil];
	
	[delegate didFinishRetrievingGPSLocation];
	[self dismissModalViewControllerAnimated:NO];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updatingAddressTimedOut) object:nil];
	[geoCoder cancel];
	NSLog(@"Failed to retrieve address. Reason: %@",[error description]);
	[delegate didFailRetrievingAddressWithError:error];
	[self dismissModalViewControllerAnimated:NO];
}

- (void)stopUpdatingLocation {
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	if (touch.tapCount > 1) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updatingLocationTimedOut) object:nil];
		[self stopUpdatingLocation];
		[geoCoder cancel];
		[self dismissModalViewControllerAnimated:NO];
	}
}

- (void)dealloc{
	[bestEffortAtLocation release];
	[delegate release];
	[activityLabel release];
	[geoCoder release];
	[locationManager release];
	[super dealloc];
}

@end
