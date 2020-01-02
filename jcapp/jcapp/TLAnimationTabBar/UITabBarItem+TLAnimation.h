
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@protocol TLAnimationProtocol;
@interface UITabBarItem (TLAnimation)

@property(nonatomic, strong) id <TLAnimationProtocol>animation;

@end

NS_ASSUME_NONNULL_END
