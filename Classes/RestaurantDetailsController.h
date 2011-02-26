#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "LocationRepository.h"

@interface RestaurantDetailsController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	Restaurant *restaurant;
	IBOutlet UITableView *mainTableView;
	NSMutableArray *sections;
	IBOutlet UIView *footerView;
	IBOutlet UIButton *callButton;
	IBOutlet UIButton *viewWebsiteButton;
	IBOutlet UIButton *directionsButton;
}

@property (nonatomic, retain) Restaurant *restaurant;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) IBOutlet UIButton *callButton;
@property (nonatomic, retain) IBOutlet UIButton *viewWebsiteButton;
@property (nonatomic, retain) IBOutlet UIButton *directionsButton;

- (void)createHeader;
- (void)createSectionsArray;
- (NSString *)getTitleForSection:(NSInteger)section;
- (IBAction)callButtonClicked:(id)sender;
- (void)callPhoneNumber;
- (IBAction)viewOnMapButtonClicked:(id)sender;
- (IBAction)directionsButtonClicked:(id)sender;
- (IBAction)viewWebsiteButtonClicked:(id)sender;
- (BOOL)isiPhone;

@end
