#import <Foundation/Foundation.h>

@protocol RetrieveGPSLocationControllerDelegate <NSObject>

@required
- (void)didFinishRetrievingGPSLocation;
- (void)didFailRetrievingGPSLocationWithError:(NSError *)error;
- (void)didFailRetrievingAddressWithError:(NSError *)error;
- (void)didTimeOutWhileRetrievingGPSLocation;

@end
