#import <UIKit/UIKit.h>

@interface NSString (StringHelper)
- (CGFloat)textHeightForSystemFontOfSize:(CGFloat)size;
- (CGFloat)textHeightForBoldSystemFontOfSize:(CGFloat)size;
- (UILabel *)labelWithSystemFontOfSize:(CGFloat)size;
- (UILabel *)labelWithBoldSystemFontOfSize:(CGFloat)size;
@end

