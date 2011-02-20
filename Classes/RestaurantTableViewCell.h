#import <Foundation/Foundation.h>


@interface RestaurantTableViewCell : UITableViewCell {
	UILabel *name;
	UILabel *address;
	UILabel *suburb;
	UILabel *distance;
	BOOL isSortedByDistance;
}

@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *address;
@property (nonatomic, retain) UILabel *suburb;
@property (nonatomic, retain) UILabel *distance;
@property (nonatomic) BOOL isSortedByDistance;

@end
