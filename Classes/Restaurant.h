#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Restaurant : NSObject {
	NSInteger restaurantId;
	NSString *name;
	NSString *address;
	NSString *suburb;
	NSString *phoneNumber;
	NSString *website;
	NSString *description;
	CGFloat latitude;
	CGFloat longitude;
	CGFloat distance;
	BOOL isFullyLoaded;
	CLLocation *location;
}

@property (nonatomic) NSInteger restaurantId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *suburb;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) CGFloat distance;
@property (nonatomic) BOOL isFullyLoaded;

@end
