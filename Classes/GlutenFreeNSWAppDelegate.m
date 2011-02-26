#import "GlutenFreeNSWAppDelegate.h"
#import "Reachability.h"
#import "GANTracker.h"

@implementation GlutenFreeNSWAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[Reachability setReachability:ReachableViaWiFi];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	reachability = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
    [reachability startNotifer];
	
	NSError *error;
	[[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-21513533-1" dispatchPeriod:10 delegate:nil];
	if (![[GANTracker sharedTracker] trackPageview:@"/application_start_page" withError:&error]) {
		NSLog(@"Error tracking page using google analytics: %@", error);
	}
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {    
	NSError *error;
	NSLog(@"Tracking event - Application, Activated");
	if (![[GANTracker sharedTracker] trackEvent:@"Application" action:@"Activated" label:@"" value:-1 withError:&error]) {
		NSLog(@"Error tracking page using google analytics: %@", error);
	}
}

- (void) reachabilityChanged: (NSNotification* )note {
    Reachability* currentReachability = [note object];
    NSParameterAssert([currentReachability isKindOfClass: [Reachability class]]);
    [Reachability setReachability:currentReachability.currentReachabilityStatus];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)dealloc {
	[[GANTracker sharedTracker] stopTracker];
	[reachability release];
	[navigationController release];
	[window release];
	[super dealloc];
}

@end

