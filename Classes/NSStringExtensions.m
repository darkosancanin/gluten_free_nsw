#import "NSStringExtensions.h"

@implementation NSString (StringHelper)

#pragma mark Methods to determine the height of a string for resizeable table cells
- (CGFloat)textHeightForSystemFontOfSize:(CGFloat)size {
	CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 50;
	CGFloat maxHeight = 9999;
	CGSize maximumSize = CGSizeMake(maxWidth,maxHeight);
	
	CGSize expectedSize = [self sizeWithFont:[UIFont systemFontOfSize:size] 
						   constrainedToSize:maximumSize 
							   lineBreakMode:UILineBreakModeWordWrap]; 
	
	return expectedSize.height;
}

- (CGFloat)textHeightForBoldSystemFontOfSize:(CGFloat)size {
	CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 50;
	CGFloat maxHeight = 9999;
	CGSize maximumSize = CGSizeMake(maxWidth,maxHeight);
	
	CGSize expectedSize = [self sizeWithFont:[UIFont boldSystemFontOfSize:size]
						   constrainedToSize:maximumSize 
							   lineBreakMode:UILineBreakModeWordWrap]; 
	
	return expectedSize.height;
}

- (UILabel *)labelWithSystemFontOfSize:(CGFloat)size {
	CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
	CGFloat height = [self textHeightForSystemFontOfSize:size] + 10.0;
	CGRect frame = CGRectMake(10.0f, 10.0f, width, height);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentLeft;
	label.font = [UIFont systemFontOfSize:size];
	
	label.text = self; 
	label.numberOfLines = 0; 
	[label sizeToFit];
	return label;
}

- (UILabel *)labelWithBoldSystemFontOfSize:(CGFloat)size {
	CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
	CGFloat height = [self textHeightForSystemFontOfSize:size] + 10.0;
	CGRect frame = CGRectMake(10.0f, 10.0f, width, height);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentLeft;
	label.font = [UIFont boldSystemFontOfSize:size];
	
	label.text = self; 
	label.numberOfLines = 0; 
	[label sizeToFit];
	return label;
}

@end
