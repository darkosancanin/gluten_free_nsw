#import "Alphabet.h"

@implementation Alphabet

+ (NSArray *)letters {
	
	static NSArray *letters;
	if(letters == nil){
		letters = [NSArray arrayWithObjects:
				   @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L",
				   @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
		
		[letters retain];
	}
	
	return letters;
}

+ (NSString *)letterAtIndex:(NSInteger)index{
	return [[self letters] objectAtIndex:index];
}

@end
