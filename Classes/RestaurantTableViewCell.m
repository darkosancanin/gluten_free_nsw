#import "RestaurantTableViewCell.h"

@implementation RestaurantTableViewCell

@synthesize name;
@synthesize address;
@synthesize suburb;
@synthesize distance;
@synthesize isSortedByDistance;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		name = [[UILabel alloc]init];
		name.font = [UIFont boldSystemFontOfSize:13];
		[self.contentView addSubview:name];
		
		address = [[UILabel alloc]init];
		address.font = [UIFont systemFontOfSize:11];
		[self.contentView addSubview:address];
		
		suburb = [[UILabel alloc]init];
		suburb.font = [UIFont systemFontOfSize:11];
		[self.contentView addSubview:suburb];
		
		distance = [[UILabel alloc]init];
		distance.font = [UIFont systemFontOfSize:11];
		[self.contentView addSubview:distance];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	int distanceOffset;
	if(self.isSortedByDistance == YES){
		distanceOffset = 15;
	}
	else{
		distanceOffset = 0;
	}
	
	name.frame = CGRectMake(12, 2, 213, 18);
	address.frame = CGRectMake(12, 19, 213, 17);
	suburb.frame = CGRectMake(12, 34, 213, 17);
	distance.frame = CGRectMake(233 + distanceOffset, 16, 61, 17);
}

- (void)dealloc {
	[distance release];
	[suburb release];
	[name release];
	[address release];
	[super dealloc];
}

@end
