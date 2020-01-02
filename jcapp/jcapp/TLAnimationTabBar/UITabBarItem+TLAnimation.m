

#import "UITabBarItem+TLAnimation.h"
#import "TLAnimationProtocol.h"
#import <objc/runtime.h>

@implementation UITabBarItem (TLAnimation)
// MARK: - 关联属性
- (void)setAnimation:(id<TLAnimationProtocol>)animation {
    NSAssert([animation conformsToProtocol:@protocol(TLAnimationProtocol)], @"UITabBarItem: animation属性必须遵守TLAnimationProtocol协议");
    objc_setAssociatedObject(self, @selector(animation), animation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<TLAnimationProtocol>)animation {
    return objc_getAssociatedObject(self, _cmd);
}
@end

