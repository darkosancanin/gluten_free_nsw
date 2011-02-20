#import "MapAnnotation.h"
#import <MapKit/MapKit.h>

@implementation MapAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize restaurant;

- (void)dealloc{
	[restaurant release];
	[title release];
	[subtitle release];
	[super dealloc];
}

@end
