#import "AboutController.h"

@implementation AboutController

@synthesize mainText;

- (void)viewDidLoad {
	self.title = @"About";
	self.mainText.font = [UIFont systemFontOfSize:13];
	
	NSError *error;
	NSString *url = @"/about";
	NSLog(@"Track URL: %@", url);
	if (![[GANTracker sharedTracker] trackPageview:url withError:&error]) {
		NSLog(@"Error tracking page using google analytics: %@", error);
	}
}

-(IBAction)emailButtonClicked{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://glutenfreensw@idarko.com"]];
}

- (void)dealloc {
	[mainText release];
    [super dealloc];
}


@end
