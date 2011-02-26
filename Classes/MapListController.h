#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GANTracker.h"

@interface MapListController : UIViewController<MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;
	NSDictionary *restaurants;
	NSMutableArray *allRestaurants;
	BOOL isFirstTimeMapViewIsLoaded;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSDictionary *restaurants;
@property (nonatomic, retain) NSMutableArray *allRestaurants;

- (void)listButtonClicked:(id)sender;
- (void)infoButtonClicked:(id)sender;

@end
