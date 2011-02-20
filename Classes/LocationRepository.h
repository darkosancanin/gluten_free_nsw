#import <Foundation/Foundation.h>

@interface LocationRepository : NSObject {

}

+ (NSString *)formattedLocation;
+ (void)setAddress:(NSString *)address;
+ (CGFloat)latitude;
+ (CGFloat)longitude;
+ (CGFloat)accuracy;
+ (void)setLatitude:(CGFloat)latitude;
+ (void)setLongitude:(CGFloat)longitude;
+ (void)setAccuracy:(CGFloat)accuracy;

@end
