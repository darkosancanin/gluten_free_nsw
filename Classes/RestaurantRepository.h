#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Restaurant.h"

#define kRestaurantSortTypeDistance 0
#define kRestaurantSortTypeSuburb 1
#define kRestaurantSortTypeName 2

#define kRestaurantSearchTypeAll 0
#define kRestaurantSearchTypeName 1
#define kRestaurantSearchTypeAddress 2

static void distanceFunction(sqlite3_context *context, int argc, sqlite3_value **argv);

@interface RestaurantRepository : NSObject {

}

+ (NSDictionary *)getRestaurantsBySearchText:(NSString*)searchText andSearchType:(NSInteger)searchType andSortType:(NSInteger)sortType;
+ (void)hydrateRestaurant:(Restaurant*)restaurant;

@end
