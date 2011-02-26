#import "RestaurantTableViewCell.h"

@implementation RestaurantTableViewCell

@synthesize name;
@synthesize address;
@synthesize suburb;
@synthesize distance;
@synthesize isSortedByDistance;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		UIColor *textColor = [UIColor colorWithRed:0.1058 green:0.1686 blue:0.3921 alpha:1];
		name = [[UILabel alloc]init];
		name.backgroundColor = [UIColor clearColor];
		name.font = [UIFont boldSystemFontOfSize:13];
		name.textColor = textColor;
		[self.contentView addSubview:name];
		
		address = [[UILabel alloc]init];
		address.backgroundColor = [UIColor clearColor];
		address.font = [UIFont systemFontOfSize:11];
		address.textColor = textColor;
		[self.contentView addSubview:address];
		
		suburb = [[UILabel alloc]init];
		suburb.backgroundColor = [UIColor clearColor];
		suburb.font = [UIFont systemFontOfSize:11];
		suburb.textColor = textColor;
		[self.contentView addSubview:suburb];
		
		distance = [[UILabel alloc]init];
		distance.backgroundColor = [UIColor clearColor];
		distance.font = [UIFont systemFontOfSize:11];
		distance.textColor = textColor;
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
