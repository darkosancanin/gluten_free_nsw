#import "AboutController.h"

@implementation AboutController

@synthesize mainText;

- (void)viewDidLoad {
	self.title = @"About";
	self.mainText.font = [UIFont systemFontOfSize:13];
}

-(IBAction)emailButtonClicked{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://glutenfreensw@idarko.com"]];
}

- (void)dealloc {
	[mainText release];
    [super dealloc];
}


@end
