#import "Restaurant.h"


@implementation Restaurant

@synthesize restaurantId;
@synthesize name;
@synthesize address;
@synthesize suburb;
@synthesize website;
@synthesize description;
@synthesize latitude;
@synthesize longitude;
@synthesize distance;
@synthesize phoneNumber;
@synthesize isFullyLoaded;
@synthesize location;

- (id)init{
	if(self == [super init]){
		isFullyLoaded = NO;
	}
	return self;
}

- (void)dealloc {
	[location release];
	[website release];
	[description release];
	[phoneNumber release];
	[name release];
	[address release];
	[suburb release];
	[super dealloc];
}

@end
