#import "RestaurantRepository.h"
#import "Restaurant.h"
#import "sqlite3.h"
#import "Alphabet.h"
#import "LocationRepository.h"

@implementation RestaurantRepository

+ (NSDictionary *)getRestaurantsBySearchText:(NSString*)searchText andSearchType:(NSInteger)searchType andSortType:(NSInteger)sortType{
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	
	if(sortType == kRestaurantSortTypeDistance)
		[dictionary setObject:[[[NSMutableArray alloc] init] autorelease] forKey:@"All"];
	else{
		for(NSString *letter in [Alphabet letters]){
			[dictionary setObject:[[[NSMutableArray alloc] init] autorelease] forKey:letter];
		}
	}
	
	NSString *pathToDatabase = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"glutenfreensw.sqlite"];
	sqlite3 *database;
	if (sqlite3_open([pathToDatabase UTF8String], &database) == SQLITE_OK) {
		
		sqlite3_create_function(database, "distanceinkm", 4, SQLITE_UTF8, NULL, &distanceFunction, NULL, NULL);
		
		NSMutableString *sql = [[NSMutableString alloc] init];
		[sql appendFormat:@"SELECT restaurantId, name, address, suburb, latitude, longitude, distanceinkm(latitude, longitude, %f, %f) as distance FROM restaurants WHERE (stateId = 1 OR stateId = 2) ", [LocationRepository latitude], [LocationRepository longitude]];
		
		if(searchText != nil && searchText.length > 0){
			if(searchType == kRestaurantSearchTypeName){
				[sql appendString:@"AND (name LIKE ?001)"];
			}
			else if(searchType == kRestaurantSearchTypeAddress){
				[sql appendString:@"AND (address LIKE ?001 OR suburb LIKE ?001)"];
			}
			else{
				[sql appendString:@"AND (name LIKE ?001 OR address LIKE ?001 OR suburb LIKE ?001)"];	
			}
		}
		
		if(sortType == kRestaurantSortTypeDistance)
			[sql appendString:@"ORDER BY distance "];
		else if(sortType == kRestaurantSortTypeSuburb){
			[sql appendString:@"ORDER BY suburb, name "];
		}
		else if(sortType == kRestaurantSortTypeName){
			[sql appendString:@"ORDER BY name"];
		}
		
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			NSString *likeSearchText = [NSString stringWithFormat:@"%%%@%%", searchText];
			sqlite3_bind_text(statement, 1, [likeSearchText UTF8String], -1, SQLITE_TRANSIENT);
			while (sqlite3_step(statement) == SQLITE_ROW) {
				Restaurant *restaurant = [[Restaurant alloc] init];        
				int primaryKey = sqlite3_column_int(statement, 0);
				restaurant.restaurantId = primaryKey;
				restaurant.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				restaurant.address = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				restaurant.suburb = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				restaurant.latitude = sqlite3_column_double(statement, 4);
				restaurant.longitude = sqlite3_column_double(statement, 5);
				restaurant.distance = sqlite3_column_double(statement, 6);
				CLLocation *location = [[CLLocation alloc] initWithLatitude:restaurant.latitude longitude:restaurant.longitude];
				restaurant.location = location;
				[location release];
				NSMutableArray *restaurantArray;
				if(sortType == kRestaurantSortTypeDistance)
					restaurantArray = [dictionary objectForKey:@"All"];
				else if(sortType == kRestaurantSortTypeSuburb){
					NSString *firstLetterInSuburb = [restaurant.suburb substringWithRange:NSMakeRange(0, 1)];
					restaurantArray = [dictionary objectForKey:firstLetterInSuburb];
				}
				else if(sortType == kRestaurantSortTypeName){
					NSString *firstLetterInName = [restaurant.name substringWithRange:NSMakeRange(0, 1)];
					restaurantArray = [dictionary objectForKey:firstLetterInName];
				}
				
				[restaurantArray addObject:restaurant];
				
				[restaurant release];
			}
		}
		else {
			NSAssert1(0, @"Failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
		
		sqlite3_finalize(statement);
		
		if (sqlite3_close(database) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
		}
		
		[sql release];
	} else {
		sqlite3_close(database);
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
	
	return [dictionary autorelease];
}

+ (void)hydrateRestaurant:(Restaurant*)restaurant{
	if(restaurant.isFullyLoaded == YES)
		return;
	
	NSString *pathToDatabase = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"glutenfreensw.sqlite"];
	sqlite3 *database;
	if (sqlite3_open([pathToDatabase UTF8String], &database) == SQLITE_OK) {
		NSString *sql = @"SELECT phone_number, website, description FROM restaurants WHERE restaurantId = ?";
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			sqlite3_bind_int(statement, 1, restaurant.restaurantId);
			if (sqlite3_step(statement) == SQLITE_ROW) {
				restaurant.phoneNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				restaurant.website = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				restaurant.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				restaurant.isFullyLoaded = YES;
			}
		}
		else {
			NSAssert1(0, @"Failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
		
		sqlite3_finalize(statement);
		
		if (sqlite3_close(database) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
		}
		
		[sql release];
	} else {
		sqlite3_close(database);
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
}


@end


#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180

static void distanceFunction(sqlite3_context *context, int argc, sqlite3_value **argv)
{
	if (sqlite3_value_type(argv[0]) == SQLITE_NULL || sqlite3_value_type(argv[1]) == SQLITE_NULL || sqlite3_value_type(argv[2]) == SQLITE_NULL || sqlite3_value_type(argv[3]) == SQLITE_NULL) {
		sqlite3_result_null(context);
		return;
	}
	
	double lat1 = sqlite3_value_double(argv[0]);
	double lon1 = sqlite3_value_double(argv[1]);
	double lat2 = sqlite3_value_double(argv[2]);
	double lon2 = sqlite3_value_double(argv[3]);
	// convert lat1 and lat2 into radians now, to avoid doing it twice below
	double lat1rad = DEG2RAD(lat1);
	double lat2rad = DEG2RAD(lat2);
	// apply the spherical law of cosines to our latitudes and longitudes, and set the result appropriately
	// 6378.1 is the approximate radius of the earth in kilometres
	sqlite3_result_double(context, acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DEG2RAD(lon2) - DEG2RAD(lon1))) * 6378.1);
}
