#import <UIKit/UIKit.h>

@interface AboutController : UIViewController {
	IBOutlet UITextView *mainText;
}

@property (nonatomic, retain) IBOutlet UITextView *mainText;

-(IBAction)emailButtonClicked;

@end
