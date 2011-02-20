#import "RestaurantDetailsController.h"
#import "NSStringExtensions.h"
#import "RestaurantRepository.h"
#import "Restaurant.h"
#import "RestaurantMapController.h"

#define kSectionDescription 0
#define kSectionPhoneNumber 1
#define kSectionWebsite	2
#define kSectionDistance 3

@implementation RestaurantDetailsController

@synthesize restaurant;
@synthesize mainTableView;
@synthesize footerView;
@synthesize callButton;

- (void)viewDidLoad{
	if([self isiPhone] == NO){
		self.callButton.alpha = 0;
	}

	if(restaurant.isFullyLoaded == NO){
		[RestaurantRepository hydrateRestaurant:restaurant];
	}
	
	[self.mainTableView setTableFooterView:self.footerView];
		
	[self createHeader];
	[self createSectionsArray];
}

- (void)createSectionsArray{
	sections = [[NSMutableArray alloc] init];
	if(restaurant.description.length > 2)
		[sections addObject:[NSNumber numberWithInt:kSectionDescription]];
	if(restaurant.phoneNumber.length > 2)
		[sections addObject:[NSNumber numberWithInt:kSectionPhoneNumber]];
	if(restaurant.website.length > 2)
		[sections addObject:[NSNumber numberWithInt:kSectionWebsite]];
	
	[sections addObject:[NSNumber numberWithInt:kSectionDistance]];
}

- (NSString *)getTitleForSection:(NSInteger)section{
	if(section == kSectionDescription)
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
	if(section == kSectionDescription)
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
	UILabel *titleLabel = [self.restaurant.name labelWithBoldSystemFontOfSize:20];
	titleLabel.text = self.restaurant.name;
	titleLabel.frame = CGRectMake(titleLabel.frame.origin.x + 9, titleLabel.frame.origin.y, titleLabel.frame.size.width, titleLabel.frame.size.height);
	
	UILabel *addressLabel = [self.restaurant.address labelWithSystemFontOfSize:14];
	addressLabel.text = self.restaurant.address;
	addressLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.size.height + titleLabel.frame.origin.y + 5, 280, addressLabel.frame.size.height);
	
	UILabel *suburbLabel = [self.restaurant.suburb labelWithSystemFontOfSize:14];
	suburbLabel.text = self.restaurant.suburb;
	suburbLabel.frame = CGRectMake(titleLabel.frame.origin.x, addressLabel.frame.size.height + addressLabel.frame.origin.y + 2, 280, suburbLabel.frame.size.height);
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, suburbLabel.frame.origin.y + suburbLabel.frame.size.height + 10)];
	[headerView addSubview:titleLabel];
	[headerView addSubview:addressLabel];
	[headerView addSubview:suburbLabel];
	self.mainTableView.tableHeaderView = headerView;
	
	[suburbLabel release];
	[addressLabel release];
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
	CGFloat height = [text textHeightForSystemFontOfSize:14] + 20.0;
	return height;
} 


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* cellIdentifier = @"DetailsCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
	}
	
	cell.textLabel.font = [UIFont systemFontOfSize:14];
	
	NSInteger sectionIndex = [[sections objectAtIndex:indexPath.section] intValue];
	UILabel *cellLabel = [[self getTextForSection:sectionIndex] labelWithSystemFontOfSize:14];
	 
	if((sectionIndex == kSectionPhoneNumber && [self isiPhone] == YES) || sectionIndex == kSectionWebsite)
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	else
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	[cell.contentView addSubview:cellLabel];
	[cellLabel release];
		
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSInteger sectionIndex = [[sections objectAtIndex:indexPath.section] intValue];
	if(sectionIndex == kSectionPhoneNumber && [self isiPhone] == YES)
		[self callPhoneNumber];
	if(sectionIndex == kSectionWebsite)
		[self askUserIfTheyWantToGoToWebsite];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)askUserIfTheyWantToGoToWebsite{
	NSString *message = [NSString stringWithFormat:@"Are you sure you would like to view this website? \n\n %@ \n\n Note: this will close the application.", self.restaurant.website];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:nil];
	[alertView addButtonWithTitle:@"Yes"];
	[alertView show];
	[alertView autorelease];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex != [alertView cancelButtonIndex]){
		NSString *addressURL = [NSString stringWithString:self.restaurant.website];
		addressURL = [addressURL stringByReplacingOccurrencesOfString:@" " withString:@"+"];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:addressURL]];
	}
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
