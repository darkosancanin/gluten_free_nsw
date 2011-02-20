#import "RestaurantsController.h"
#import "RestaurantDetailsController.h"
#import "RestaurantTableViewCell.h"
#import "RestaurantRepository.h"
#import "Alphabet.h"
#import "RetrieveGPSLocationController.h"
#import "LocationRepository.h"
#import "MapListController.h"
#import "AboutController.h"

@implementation RestaurantsController

@synthesize sortSegmentedControl;
@synthesize sortView;
@synthesize mainTableView;
@synthesize restaurants;
@synthesize headerSearchBar;
@synthesize locationLabel;
@synthesize tableFooterView;
@synthesize resultCountLabel;

- (void)viewDidLoad{
	[self.mainTableView setContentOffset:CGPointMake(0,44) animated:YES];
	searchBarIsActive = NO;
	sectionIndexBuffer = 3;
	locationLabel.text = [LocationRepository formattedLocation];
	[self.mainTableView setTableHeaderView:self.sortView];
	[self.mainTableView setTableFooterView:self.tableFooterView];
	
	UIBarButtonItem *mapBarButtonItem = [[UIBarButtonItem alloc] 
										 initWithTitle:@"Map" 
										 style:UIBarButtonItemStyleBordered 
										 target:self 
										 action:@selector(mapButtonClicked:)];
	self.navigationItem.rightBarButtonItem = mapBarButtonItem;
	[mapBarButtonItem release];
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	self.navigationItem.leftBarButtonItem = infoButtonItem;	
	[infoButton release];
	
	searchingOverlayView = [[UIView alloc] init];
	searchingOverlayView.frame = CGRectMake(0,sortView.bounds.size.height,320,400);
	searchingOverlayView.alpha = 0.8;
	searchingOverlayView.backgroundColor = [UIColor blackColor];
	
	if([LocationRepository latitude] == 0 || [LocationRepository longitude] == 0){
		[sortSegmentedControl setEnabled:NO forSegmentAtIndex:0];
		[sortSegmentedControl setSelectedSegmentIndex:1];	
		[self retrieveGPSLocation];
	}
	
	self.restaurants = [RestaurantRepository getRestaurantsBySearchText:headerSearchBar.text andSearchType:[self searchType] andSortType:[self sortType]];
	[self setResultCountLabel];
}

- (void)setResultCountLabel{
	int restaurantsCount = 0;
	for (id key in self.restaurants) {
		restaurantsCount += [[self.restaurants objectForKey:key] count];
	}
	if(restaurantsCount == 0)
		self.resultCountLabel.text = @"No restaurants found.";
	else if (restaurantsCount == 1)
		self.resultCountLabel.text = [NSString stringWithFormat:@"%d restaurant found.", restaurantsCount];
	else
		self.resultCountLabel.text = [NSString stringWithFormat:@"%d restaurants found.", restaurantsCount];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if([self sortType] == kRestaurantSortTypeDistance)
		return 1;
	else
		return [[Alphabet letters] count] + sectionIndexBuffer;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if([self sortType] != kRestaurantSortTypeDistance && section >= sectionIndexBuffer){
		NSArray *restaurantsArray = [self.restaurants objectForKey:[Alphabet letterAtIndex:(section - sectionIndexBuffer)]];
		if(restaurantsArray.count > 0)
			return [[Alphabet letters] objectAtIndex:(section - sectionIndexBuffer)];
		else
			return @"";
	}
	else
		return @"";
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (searchBarIsActive == YES) return nil;
	NSMutableArray *titles = [[NSMutableArray alloc] init];
	if([self sortType] != kRestaurantSortTypeDistance){
		for(int i = 0; i < sectionIndexBuffer; i++){
			[titles addObject:@""];
		}
		for(NSString *letter in [Alphabet letters]){
			[titles addObject:letter];
		}
	}
	return [titles autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section < sectionIndexBuffer){
		return [[self.restaurants objectForKey:@"All"] count];
	}
	
	NSArray *restaurantsArray = [self.restaurants objectForKey:[Alphabet letterAtIndex:(section - sectionIndexBuffer)]];
    return restaurantsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* cellIdentifier = @"RestaurantCell";
	RestaurantTableViewCell *cell = (RestaurantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil){
		cell = [[RestaurantTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier];
	}
	
	Restaurant *restaurant;
	if([self sortType] == kRestaurantSortTypeDistance)
		restaurant = [[self.restaurants objectForKey:@"All"] objectAtIndex:indexPath.row];
	else
		restaurant = [[self.restaurants objectForKey:[Alphabet letterAtIndex:(indexPath.section - sectionIndexBuffer)]] objectAtIndex:indexPath.row];
	
	cell.name.text = restaurant.name;
	[cell.name sizeToFit];
	cell.address.text = restaurant.address;
	cell.suburb.text = restaurant.suburb;
	cell.isSortedByDistance = (self.sortType == kRestaurantSortTypeDistance);
	
	if([LocationRepository latitude] != 0 && [LocationRepository longitude] != 0)
	{
		if(restaurant.distance > 50){
			cell.distance.text = [NSString stringWithFormat:@"%1.0fkm", restaurant.distance];
		}
		else{
			cell.distance.text = [NSString stringWithFormat:@"%1.2fkm", restaurant.distance];	
		}
	}
	else
		cell.distance.text = @"";
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"List" style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[self navigationItem] setBackBarButtonItem: newBackButton];
	[newBackButton release];
	
	RestaurantDetailsController *restaurantDetailsController = [[RestaurantDetailsController alloc] initWithNibName:@"RestaurantDetails" bundle:[NSBundle mainBundle]];
	Restaurant *restaurant;
	if([self sortType] == kRestaurantSortTypeDistance)
		restaurant = [[self.restaurants objectForKey:@"All"] objectAtIndex:indexPath.row];
	else
		restaurant = [[self.restaurants objectForKey:[Alphabet letterAtIndex:(indexPath.section - sectionIndexBuffer)]] objectAtIndex:indexPath.row];
	restaurantDetailsController.restaurant = restaurant;
	[self.navigationController pushViewController:restaurantDetailsController	animated:YES];
	[restaurantDetailsController release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 55;
}

- (void)mapButtonClicked:(id)sender{
	MapListController *mapListController = [[MapListController alloc] initWithNibName:@"MapList" bundle:[NSBundle mainBundle]];
	mapListController.restaurants = self.restaurants;
	[self.navigationController pushViewController:mapListController animated:NO];
	[mapListController release];
}

- (void)infoButtonClicked:(id)sender{
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"List" style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[self navigationItem] setBackBarButtonItem: newBackButton];
	[newBackButton release];
	
	AboutController *aboutController = [[AboutController alloc] initWithNibName:@"About" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:aboutController animated:YES];
	[aboutController release];
}

- (IBAction)sortSegmentedControlClicked:(id)sender{
	[self refreshTable];
}

- (NSInteger)sortType{
	if(sortSegmentedControl.selectedSegmentIndex == 0)
		return kRestaurantSortTypeDistance;
	else if(sortSegmentedControl.selectedSegmentIndex == 1)
		return kRestaurantSortTypeSuburb;
	else
		return kRestaurantSortTypeName;
}

- (NSInteger)searchType{
	if(headerSearchBar.selectedScopeButtonIndex == 1)
		return kRestaurantSearchTypeName;
	else if(headerSearchBar.selectedScopeButtonIndex == 2)
		return kRestaurantSearchTypeAddress;
	else
		return kRestaurantSearchTypeAll;
}

- (void) refreshTable{
	self.restaurants = [RestaurantRepository getRestaurantsBySearchText:headerSearchBar.text andSearchType:[self searchType] andSortType:[self sortType]];
	[mainTableView reloadData];
	[self setResultCountLabel];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[self hideSearchBar];
	[self refreshTable];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	[self hideSearchBar];
	[self refreshTable];
}	

- (void)hideSearchBar{
	searchBarIsActive = NO;
	self.headerSearchBar.showsScopeBar = NO;
	[self.headerSearchBar sizeToFit];
	[searchingOverlayView removeFromSuperview];
	[headerSearchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	searchBar.showsCancelButton = YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
	[self.view addSubview:searchingOverlayView];
	self.headerSearchBar.showsScopeBar = YES;
	[self.headerSearchBar sizeToFit];
	searchBarIsActive = YES;
	[mainTableView reloadData];
	return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
	searchBar.showsCancelButton = NO;
}

- (IBAction)retrieveGPSLocationButtonClicked:(id)sender{
	[self retrieveGPSLocation];
}

- (void)retrieveGPSLocation{
	CLLocationManager *locationManager = [[CLLocationManager alloc] init];
	BOOL locationServicesAreEnabled = [CLLocationManager locationServicesEnabled];
	[locationManager release];
    if (locationServicesAreEnabled == NO) {
        UIAlertView *locationDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. To use the location features of this application, please enable location services." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [locationDisabledAlert show];
        [locationDisabledAlert release];
		return;
    }           
	
	RetrieveGPSLocationController *retrieveGPSLocationController = [[RetrieveGPSLocationController alloc] initWithNibName:@"RetrieveGPSLocation" bundle:[NSBundle mainBundle]];
	retrieveGPSLocationController.delegate = self;
	[self presentModalViewController:retrieveGPSLocationController animated:NO];
	[retrieveGPSLocationController release];	
}

- (void)didFinishRetrievingGPSLocation{
	locationLabel.text = [LocationRepository formattedLocation];
	if([LocationRepository latitude] != 0 && [LocationRepository longitude] != 0){
		[sortSegmentedControl setEnabled:YES forSegmentAtIndex:0];
	}
	[self refreshTable];
}

- (void)didFailRetrievingGPSLocationWithError:(NSError *)error{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to retrieve location" message:[error description] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alert show];
	[alert release];
	locationLabel.text = [LocationRepository formattedLocation];
}

- (void)didTimeOutWhileRetrievingGPSLocation{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Timed out while retrieving location" message:@"Please try again in a few minutes." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alert show];
	[alert release];
	locationLabel.text = [LocationRepository formattedLocation];
}

- (void)didFailRetrievingAddressWithError:(NSError *)error{
	locationLabel.text = [LocationRepository formattedLocation];
	[self refreshTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[searchingOverlayView release];
	[locationLabel release];
	[sortSegmentedControl release];
	[sortView release];
	[mainTableView release];
	[restaurants release];
	[headerSearchBar release];
	[tableFooterView release];
	[resultCountLabel release];
    [super dealloc];
}


@end
