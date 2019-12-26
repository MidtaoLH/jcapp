//
//  AttendanceSummaryTabBarViewController.m
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "ToBeReviewViewController.h"
#import "AlreadyEndViewController.h"
#import "TaskViewTabBarViewController.h"
#import "TLAnimationTabBar.h"
@interface TaskViewTabBarViewController ()

@end

@implementation TaskViewTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self addChildViewController:childViewController(@"待回览", @"icon_pin_00160", 0)];
    [self addChildViewController:childViewController2(@"已回览", @"drop", 1)];
    
    self.tabBar.tintColor = kColor_tintColor;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.title=@"待我回览";
    
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = kColor_unselectedItemTintColor;
    } else {
        // Fallback on earlier versions
    }
    
}
// MARK: - UITabBarItem创建函数
/// 自定义样式UITabBarItem
UIViewController *childViewController (NSString *title, NSString *imgName, NSUInteger tag) {
    ToBeReviewViewController *vc = [[ToBeReviewViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
- (void)goBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}
/// 系统样式UITabBarItem
UIViewController *childViewController2 (NSString *title, NSString *imgName, NSUInteger tag) {
    AlreadyEndViewController *vc = [[AlreadyEndViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
// MARK: - 给UITabBarItem绑定动画
/// 给UITabBarItem绑定动画
void setAnimation(UITabBarItem *item, NSInteger index) {
    item.animation = @[
                       bounceAnimation(), rotationAnimation(), transitionAniamtion(),
                       fumeAnimation(), frameAnimation()
                       ][index];
}


// MARK: - 创建动画函数
TLBounceAnimation *bounceAnimation(){
    TLBounceAnimation *anm = [TLBounceAnimation new];
    anm.isPlayFireworksAnimation = YES;
    return anm;
}

TLRotationAnimation *rotationAnimation(){
    TLRotationAnimation *anm = [TLRotationAnimation new];
    return anm;
}

TLTransitionAniamtion *transitionAniamtion(){
    TLTransitionAniamtion *anm = [TLTransitionAniamtion new];
    anm.direction = 1; // 1~6
    anm.disableDeselectAnimation = NO;
    return anm;
}

TLFumeAnimation *fumeAnimation(){
    TLFumeAnimation *anm = [TLFumeAnimation new];
    return anm;
}

TLFrameAnimation *frameAnimation(){
    TLFrameAnimation *anm = [TLFrameAnimation new];
    anm.images = imgs();
    anm.isPlayFireworksAnimation = YES;
    return anm;
}

NSArray *imgs (){
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = 28 ; i <= 65; i++) {
        NSString *imgName = [NSString stringWithFormat:@"Tools_000%zi", i];
        CGImageRef img = [UIImage imageNamed:imgName].CGImage;
        [temp addObject:(__bridge id _Nonnull)(img)];
    }
    return temp;
}

// MARK: - UITabBarItemDelegate 监听TabBarItem点击事件
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
}
@end
