#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Restaurant.h"
#import "GANTracker.h"

@interface RestaurantMapController : UIViewController<MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;
	Restaurant *restaurant;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) Restaurant *restaurant;

@end
