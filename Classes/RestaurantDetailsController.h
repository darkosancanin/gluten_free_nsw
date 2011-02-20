#import <UIKit/UIKit.h>
#import "Restaurant.h"


@interface RestaurantDetailsController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	Restaurant *restaurant;
	IBOutlet UITableView *mainTableView;
	NSMutableArray *sections;
	IBOutlet UIView *footerView;
	IBOutlet UIButton *callButton;
}

@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) IBOutlet UIButton *callButton;

- (void)createHeader;
- (void)createSectionsArray;
- (NSString *)getTitleForSection:(NSInteger)section;
- (IBAction)callButtonClicked:(id)sender;
- (void)callPhoneNumber;
- (void)askUserIfTheyWantToGoToWebsite;
- (IBAction)viewOnMapButtonClicked:(id)sender;
- (BOOL)isiPhone;

@end
