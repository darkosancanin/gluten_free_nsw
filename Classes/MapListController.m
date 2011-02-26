#import "MapListController.h"
#import <MapKit/MapKit.h>
#import "Restaurant.h"
#import "RestaurantDetailsController.h"
#import "LocationRepository.h"
#import "MapAnnotation.h"
#import "Reachability.h"
#import "AboutController.h"

@implementation MapListController

@synthesize mapView;
@synthesize restaurants;
@synthesize allRestaurants;

- (void)viewDidLoad{
	self.title = @"Gluten Free NSW";
	isFirstTimeMapViewIsLoaded = YES;
	
	if([Reachability reachability] == NotReachable){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Internet Connection Detected" 
															message:@"An internet connection is required to view the restaurants on a map. Only cached map images will be visible now, please try again once an internet connection is available." 
														   delegate:nil 
												  cancelButtonTitle:@"Close" 
												  otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	self.navigationItem.leftBarButtonItem = infoButtonItem;	
	[infoButton release];
	
	UIBarButtonItem *listBarButtonItem = [[UIBarButtonItem alloc] 
										 initWithTitle:@"List" 
										 style:UIBarButtonItemStyleBordered 
										 target:self 
										 action:@selector(listButtonClicked:)];
	self.navigationItem.rightBarButtonItem = listBarButtonItem;
	[listBarButtonItem release];
	
	self.navigationItem.hidesBackButton = YES;
	
	allRestaurants = [[NSMutableArray alloc] init];
	for(NSArray* restaurantsArray in [restaurants allValues]){
		[allRestaurants addObjectsFromArray:restaurantsArray];
	}
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.05f;
	span.longitudeDelta=0.05f;
	CLLocation *location = [[CLLocation alloc] initWithLatitude:[LocationRepository latitude] longitude:[LocationRepository longitude]];
	CLLocationCoordinate2D locationCoordinate = location.coordinate;
	region.span=span;
	region.center=locationCoordinate;
	
	[mapView setRegion:region animated:YES];
	[mapView regionThatFits:region];
	
	NSError *error;
	NSString *url = @"/map";
	NSLog(@"Track URL: %@", url);
	if (![[GANTracker sharedTracker] trackPageview:url withError:&error]) {
		NSLog(@"Error tracking page using google analytics: %@", error);
	}
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
	CLLocationCoordinate2D closestRestaurantsCoordinate;
	CGFloat closestRestaurantsDistance = 0;
	int pointsShowingOnMap = 0;
	
	for(Restaurant *restaurant in allRestaurants){
		CGPoint point = [self.mapView convertCoordinate:restaurant.location.coordinate toPointToView:nil];
		
		if(closestRestaurantsDistance == 0 || closestRestaurantsDistance > restaurant.distance){
			closestRestaurantsDistance = restaurant.distance;
			closestRestaurantsCoordinate = restaurant.location.coordinate;
		}
	
		if( (point.x > 0 && point.x < 320) && (point.y > 0 && point.y < 480) ) {
			NSLog(@"Adding annotation at x:%f y:%f", point.x, point.y);
			MapAnnotation *annotation = [[MapAnnotation alloc] init];
			annotation.restaurant = restaurant;
			annotation.coordinate = restaurant.location.coordinate;
			annotation.title = restaurant.name;
			annotation.subtitle = restaurant.address;
			[self.mapView addAnnotation:annotation];
			[annotation release];
			pointsShowingOnMap += 1;
		}
		
		if(pointsShowingOnMap > 100) break;
	}
	
	if(pointsShowingOnMap == 0 && isFirstTimeMapViewIsLoaded == YES){
		isFirstTimeMapViewIsLoaded = NO;
		MKCoordinateRegion region;
		MKCoordinateSpan span;
		span.latitudeDelta=0.05f;
		span.longitudeDelta=0.05f;
		region.span=span;
		region.center=closestRestaurantsCoordinate;
		[self.mapView setRegion:region animated:YES];
		[self.mapView regionThatFits:region];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	NSString *reuseIdentifier = @"pin";
	MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
	if(pinAnnotationView == nil){
		pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	}
	pinAnnotationView.canShowCallout =YES;
	pinAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Map" style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[self navigationItem] setBackBarButtonItem: newBackButton];
	[newBackButton release];
	
	RestaurantDetailsController *restaurantDetailsController = [[RestaurantDetailsController alloc] initWithNibName:@"RestaurantDetails" bundle:[NSBundle mainBundle]];
	restaurantDetailsController.restaurant = ((MapAnnotation *)view.annotation).restaurant;
	[self.navigationController pushViewController:restaurantDetailsController animated:YES];
	[restaurantDetailsController release];
}

- (void)infoButtonClicked:(id)sender{
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Map" style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[self navigationItem] setBackBarButtonItem: newBackButton];
	[newBackButton release];
	
	AboutController *aboutController = [[AboutController alloc] initWithNibName:@"About" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:aboutController animated:YES];
	[aboutController release];
}

- (void)listButtonClicked:(id)sender{
	[self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	mapView.delegate = nil;
	[mapView release];
	[allRestaurants release];
	[restaurants release];
    [super dealloc];
}


@end
