#import "Reachability.h"

@interface GlutenFreeNSWAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	Reachability *reachability;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (void) reachabilityChanged: (NSNotification* )note;

@end

