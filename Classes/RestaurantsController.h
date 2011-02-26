#import <UIKit/UIKit.h>
#import "RetrieveGPSLocationControllerDelegate.h"
#import "GANTracker.h"

@interface RestaurantsController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,RetrieveGPSLocationControllerDelegate> {
	IBOutlet UISegmentedControl *sortSegmentedControl;
	IBOutlet UIView *sortView;
	IBOutlet UITableView *mainTableView;
	NSDictionary *restaurants;
	NSInteger sectionIndexBuffer;
	IBOutlet UISearchBar *headerSearchBar;
	IBOutlet UILabel *locationLabel;
	BOOL searchBarIsActive;
	UIView *searchingOverlayView;
	IBOutlet UIView *tableFooterView;
	IBOutlet UILabel *resultCountLabel;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *sortSegmentedControl;
@property (nonatomic, retain) IBOutlet UIView *sortView;
@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSDictionary *restaurants;
@property (nonatomic, retain) IBOutlet UISearchBar *headerSearchBar;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UIView *tableFooterView;
@property (nonatomic, retain) IBOutlet UILabel *resultCountLabel;

- (void)refreshTable;
- (void)mapButtonClicked:(id)sender;
- (IBAction)sortSegmentedControlClicked:(id)sender;
- (IBAction)retrieveGPSLocationButtonClicked:(id)sender;
- (void)retrieveGPSLocation;
- (NSInteger)sortType;
- (NSInteger)searchType;
- (void)hideSearchBar;
- (void)infoButtonClicked:(id)sender;
- (void)setResultCountLabel;

@end
