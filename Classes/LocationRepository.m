#import "LocationRepository.h"

@implementation LocationRepository

+ (NSString *)formattedLocation{
	NSString *formattedAccuracy;
	CGFloat accuracy = [LocationRepository accuracy];
	if(accuracy > 50){
		formattedAccuracy = [NSString stringWithFormat:@" (+/-%1.0fm)", accuracy];
	}
	else{
		formattedAccuracy = @"";
	}
	
	NSString *address = [[NSUserDefaults standardUserDefaults] stringForKey:@"address"];
	if(address != nil && address.length > 0)
		return [NSString stringWithFormat:@"%@%@", address, formattedAccuracy];
	
	CGFloat latitude = [LocationRepository latitude];
	CGFloat longitude = [LocationRepository longitude];
	if(latitude != 0 && longitude != 0)
		return [NSString stringWithFormat:@"%1.3f, %1.3f%@", latitude, longitude, formattedAccuracy];
		
	return @"";
}

+ (void)setAddress:(NSString *)address{
	[[NSUserDefaults standardUserDefaults] setObject:address forKey:@"address"];
}

+ (void)setLatitude:(CGFloat)latitude{
	[[NSUserDefaults standardUserDefaults] setFloat:latitude forKey:@"latitude"];
}

+ (void)setLongitude:(CGFloat)longitude{
	[[NSUserDefaults standardUserDefaults] setFloat:longitude forKey:@"longitude"];
}

+ (void)setAccuracy:(CGFloat)accuracy{
	[[NSUserDefaults standardUserDefaults] setFloat:accuracy forKey:@"accuracy"];
}

+ (CGFloat)latitude{
	return [[NSUserDefaults standardUserDefaults] floatForKey:@"latitude"];
}

+ (CGFloat)longitude{
	return [[NSUserDefaults standardUserDefaults] floatForKey:@"longitude"];
}

+ (CGFloat)accuracy{
	CGFloat accuracy = [[NSUserDefaults standardUserDefaults] floatForKey:@"accuracy"];
	
	if(accuracy <= 100){
		accuracy = round(accuracy / 10) * 10;
	}
	else if(accuracy <= 1000){
		accuracy = round(accuracy / 50) * 50;
	}
	else if(accuracy > 1000){
		accuracy = round(accuracy / 100) * 100;
	}
	
	return accuracy;
}

@end
		
		
		
		
		
		
		
		
		
