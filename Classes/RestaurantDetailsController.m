#import "RestaurantDetailsController.h"
#import "NSStringExtensions.h"
#import "RestaurantRepository.h"
#import "Restaurant.h"
#import "RestaurantMapController.h"
#import "LocationRepository.h"

#define kSectionAddress 0
#define kSectionDescription 1
#define kSectionWebsite	2
#define kSectionPhoneNumber 3
#define kSectionDistance 4

@implementation RestaurantDetailsController

@synthesize restaurant;
@synthesize mainTableView;
@synthesize footerView;
@synthesize callButton;
@synthesize viewWebsiteButton;
@synthesize directionsButton;

- (void)viewDidLoad{
	if([self isiPhone] == NO){
		self.callButton.alpha = 0;
	}

	if(restaurant.isFullyLoaded == NO){
		[RestaurantRepository hydrateRestaurant:restaurant];
	}
	
	if(self.restaurant.website.length <= 2){
		self.viewWebsiteButton.alpha = 0;
	}
	
	if([LocationRepository latitude] == 0 || [LocationRepository longitude] == 0){
		self.directionsButton.alpha = 0;
	}
	
	
	[self.mainTableView setTableFooterView:self.footerView];
	[self.mainTableView setSeparatorColor:[UIColor clearColor]];
		
	[self createHeader];
	[self createSectionsArray];
}

- (void)createSectionsArray{
	sections = [[NSMutableArray alloc] init];
	[sections addObject:[NSNumber numberWithInt:kSectionAddress]];
	if(restaurant.description.length > 2)
		[sections addObject:[NSNumber numberWithInt:kSectionDescription]];
	if(restaurant.website.length > 2)
		[sections addObject:[NSNumber numberWithInt:kSectionWebsite]];
	if(restaurant.phoneNumber.length > 2)
		[sections addObject:[NSNumber numberWithInt:kSectionPhoneNumber]];
	if([LocationRepository latitude] > 0 && [LocationRepository longitude] > 0){
		[sections addObject:[NSNumber numberWithInt:kSectionDistance]];
	}
}

- (NSString *)getTitleForSection:(NSInteger)section{
	if(section == kSectionAddress)
		return @"Address";
	else if(section == kSectionDescription)
		return @"Description";
	else if(section == kSectionPhoneNumber)
		return @"Phone Number";
	else if(section == kSectionWebsite)
		return @"Website";
	else if(section == kSectionDistance)
		return @"Distance";
	else
		return nil;
}

- (NSString *)getTextForSection:(NSInteger)section{
	if(section == kSectionAddress)
		return [NSString stringWithFormat:@"%@\n%@",restaurant.address, restaurant.suburb];
	else if(section == kSectionDescription)
		return restaurant.description;
	else if(section == kSectionPhoneNumber)
		return restaurant.phoneNumber;
	else if(section == kSectionWebsite)
		return restaurant.website;
	else if(section == kSectionDistance)
		return [NSString stringWithFormat:@"%1.2fkm", restaurant.distance];
	else
		return nil;
}

- (void)createHeader{
	self.title = @"Restaurant Details";
	int titleFontSize = 22;
	
	UILabel *titleLabel = [self.restaurant.name labelWithBoldSystemFontOfSize:titleFontSize];
	titleLabel.text = self.restaurant.name;
	titleLabel.textColor = [UIColor colorWithRed:0.1058 green:0.1686 blue:0.3921 alpha:1];
	titleLabel.frame = CGRectMake(titleLabel.frame.origin.x + 9, titleLabel.frame.origin.y + 20, titleLabel.frame.size.width, titleLabel.frame.size.height);

	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, titleLabel.frame.size.height + titleLabel.frame.origin.y + 12)];
	[headerView addSubview:titleLabel];
	self.mainTableView.tableHeaderView = headerView;
	
	[titleLabel release];
	[headerView release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	NSInteger sectionIndex = [[sections objectAtIndex:section] intValue];
	return [self getTitleForSection:sectionIndex];
} 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger sectionIndex = [[sections objectAtIndex:indexPath.section] intValue];
	NSString *text = [self getTextForSection:sectionIndex];
	CGFloat height = [text textHeightForSystemFontOfSize:14];
	return height;
} 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* cellIdentifier = @"DetailsCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
	}
	
	cell.textLabel.font = [UIFont systemFontOfSize:14];
	cell.backgroundColor = [UIColor clearColor];
	
	NSInteger sectionIndex = [[sections objectAtIndex:indexPath.section] intValue];
	UILabel *cellLabel = [[self getTextForSection:sectionIndex] labelWithSystemFontOfSize:14];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	[cell.contentView addSubview:cellLabel];
	[cellLabel release];
		
	return cell;
}

- (IBAction)callButtonClicked:(id)sender{
	[self callPhoneNumber];
}

- (BOOL)isiPhone{
	NSString *deviceType = [UIDevice currentDevice].model;
	return [deviceType isEqualToString:@"iPhone"]; //|| [deviceType isEqualToString:@"iPhone Simulator"];
}

- (void)callPhoneNumber{
	NSString *phoneNumberUrl = [NSString stringWithFormat:@"tel://%@", self.restaurant.phoneNumber];
	phoneNumberUrl = [phoneNumberUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumberUrl]];
}

- (IBAction)viewOnMapButtonClicked:(id)sender{
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Details" style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[self navigationItem] setBackBarButtonItem: newBackButton];
	[newBackButton release];
	
	RestaurantMapController *restaurantMapController = [[RestaurantMapController alloc] initWithNibName:@"RestaurantMap" bundle:[NSBundle mainBundle]];
	restaurantMapController.restaurant = self.restaurant;
	[self.navigationController pushViewController:restaurantMapController animated:YES];
	[restaurantMapController release];
}

- (IBAction)viewWebsiteButtonClicked:(id)sender{
	NSString *addressURL = [NSString stringWithString:self.restaurant.website];
	addressURL = [addressURL stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:addressURL]];
}

- (IBAction)directionsButtonClicked:(id)sender{
	NSString *destinationLatLong = [NSString stringWithFormat:@"%f,%f", self.restaurant.latitude, self.restaurant.longitude];
	NSString *userLatLong = [NSString stringWithFormat:@"%f,%f", [LocationRepository latitude], [LocationRepository longitude]];
	NSString *url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%@&daddr=%@", userLatLong, destinationLatLong];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[callButton release];
	[footerView release];
	[sections release];
	[restaurant release];
	[mainTableView release];
    [super dealloc];
}


@end
