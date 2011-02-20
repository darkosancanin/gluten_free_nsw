#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Restaurant.h"

@interface MapAnnotation : NSObject<MKAnnotation> {
	Restaurant *restaurant;
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) Restaurant *restaurant;

@end
