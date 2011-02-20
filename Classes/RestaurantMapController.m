#import "RestaurantMapController.h"
#import <MapKit/MapKit.h>
#import "Restaurant.h"
#import "RestaurantDetailsController.h"
#import "LocationRepository.h"
#import "MapAnnotation.h"
#import "Reachability.h"

@implementation RestaurantMapController

@synthesize mapView;
@synthesize restaurant;

- (void)viewDidLoad{
	self.title = @"Restaurant Map";
	
	if([Reachability reachability] == NotReachable){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Internet Connection Detected" 
															message:@"An internet connection is required to view this restaurant on a map. Only cached map images will be visible now, please try again once an internet connection is available." 
														   delegate:nil 
												  cancelButtonTitle:@"Close" 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.01f;
	span.longitudeDelta=0.01f;
	
	CLLocation *location = [[CLLocation alloc] initWithLatitude:self.restaurant.latitude longitude:self.restaurant.longitude];
	CLLocationCoordinate2D locationCoordinate = location.coordinate;
	
	region.span=span;
	region.center=locationCoordinate;
	
	[mapView setRegion:region animated:YES];
	[mapView regionThatFits:region];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
	CLLocation *location = [[CLLocation alloc] initWithLatitude:self.restaurant.latitude longitude:self.restaurant.longitude];
	CLLocationCoordinate2D locationCoordinate = location.coordinate;
	
	MapAnnotation *annotation = [[MapAnnotation alloc] init];
	annotation.restaurant = self.restaurant;
	annotation.coordinate = locationCoordinate;
	annotation.title = self.restaurant.name;
	annotation.subtitle = self.restaurant.address;
	[self.mapView addAnnotation:annotation];
	[annotation release];
	
	[self.mapView selectAnnotation:[[self.mapView annotations] lastObject] animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	NSString *reuseIdentifier = @"pin";
	MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
	if(pinAnnotationView == nil){
		pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	}
	pinAnnotationView.canShowCallout = YES;
	pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
	RestaurantDetailsController *restaurantDetailsController = [[RestaurantDetailsController alloc] initWithNibName:@"RestaurantDetails" bundle:[NSBundle mainBundle]];
	restaurantDetailsController.restaurant = ((MapAnnotation *)view.annotation).restaurant;
	[self.navigationController pushViewController:restaurantDetailsController animated:YES];
	[restaurantDetailsController release];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	[restaurant release];
	mapView.delegate = nil;
	[mapView release];
    [super dealloc];
}


@end
