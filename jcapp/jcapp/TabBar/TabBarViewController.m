//
//  AttendanceSummaryTabBarViewController.m
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//


#import "TabBarViewController.h"
#import "ToBeReviewViewController.h"
#import "AlreadyEndViewController.h"
#import "HomePageViewController.h"
#import "UsersViewController.h"
#import "PendingViewController.h"
#import "PendingApprovedViewController.h"
#import "WaitHandleViewController.h"
#import "ApprovedViewController.h"
#import "ApprovingViewController.h"
#import "WaitingApplyViewController.h"
#import "WaitApplyViewController.h"
#import "VatcationMainView.h"
#import "LeaveViewController.h"
#import "BWaitApplyViewController.h"
#import "SWFormCommonController.h"
#import "BApprovedViewController.h"
#import "GoOutWaitController.h"
#import "GoOutViewController.h"
#import "AttendanceCalendarViewController.h"
#import "AttendanceSummaryViewController.h"
#import "AgentViewController.h"
#import "SetAgentViewController.h"
#import "NewViewController.h"
#import "Masonry.h"
#import "AppDelegate.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if([myDelegate.tabbarType isEqualToString:@"1"])
    {
        [self addChildViewController:childViewControllerHomePage(@"首页", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerUsers(@"我的", @"tabBar_friendTrends_icon", 1)];
        self.navigationItem.title=@"北京中道益通软件技术有限公司";
    }
    else if([myDelegate.tabbarType isEqualToString:@"2"])
    {
        [self addChildViewController:childViewControllerWaitingApply(@"待申请", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerApproving(@"审批中", @"drop", 1)];
        [self addChildViewController:childViewControllerApproved(@"已决裁", @"drop", 2)];
        [self addChildViewController:childViewControllerWaitHandle(@"待处理", @"drop", 3)];
        self.navigationItem.title=@"我的申请";
    }
    else if([myDelegate.tabbarType isEqualToString:@"3"])
    {
        [self addChildViewController:childViewControllerPending(@"待审批", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerPendingApproved(@"待审批", @"drop", 1)];
        self.navigationItem.title=@"待我审批";
    }
    else if([myDelegate.tabbarType isEqualToString:@"4"])
    {
        [self addChildViewController:childViewControllerToBeReview(@"待回览", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerAlreadyEnd(@"已回览", @"drop", 1)];
        self.navigationItem.title=@"待我回览";
    }
    else if([myDelegate.tabbarType isEqualToString:@"5"])
    {
        myDelegate.AppRoveType =@"qingjia";
        [self addChildViewController:childViewControllerWaitApply(@"待申请", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerVatcationMain(@"", @"publish-text", 1)];
        [self addChildViewController:childViewControllerLeave(@"请假记录", @"drop", 2)];
        self.navigationItem.title=@"请假";
    }
    else if([myDelegate.tabbarType isEqualToString:@"6"])
    {
        myDelegate.businessTripid=@"0";
        myDelegate.processid=@"0";
        myDelegate.pageType=@"1";
        [self addChildViewController:childViewControllerBWaitApply(@"待申请", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerSWFormCommon(@"", @"publish-text", 1)];
        [self addChildViewController:childViewControllerBApproved(@"出差记录", @"drop", 2)];
        self.navigationItem.title=@"出差";
    }
    else if([myDelegate.tabbarType isEqualToString:@"7"])
    {
        myDelegate.AppRoveType =@"waichu";
        [self addChildViewController:childViewControllerGoOutWait(@"待申请", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerVatcationMain(@"", @"publish-text", 1)];
        [self addChildViewController:childViewControllerGoOut(@"外出记录", @"drop", 2)];
        self.navigationItem.title=@"外出";
    }
    else if([myDelegate.tabbarType isEqualToString:@"8"])
    {
        [self addChildViewController:childViewControllerAttendanceCalendar(@"考勤日历", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerAttendanceSummary(@"考勤月汇总", @"drop", 1)];
        self.navigationItem.title=@"考勤日历";
    }
    else if([myDelegate.tabbarType isEqualToString:@"9"])
    {
        myDelegate.AppRoveType =@"agent";
        [self addChildViewController:childViewControllerAgent(@"待申请", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerSetAgent(@"", @"publish-text", 1)];
        [self addChildViewController:childViewControllerAgent(@"", @"", 2)];
        self.navigationItem.title=@"代理人设置";
    }
    else if([myDelegate.tabbarType isEqualToString:@"10"])
    {
        [self addChildViewController:childViewControllerNewView(@"公告", @"tabBar_essence_icon", 0)];
        self.navigationItem.title=@"公告";
    }
    self.tabBar.tintColor = kColor_tintColor;
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = kColor_unselectedItemTintColor;
    } else {
        // Fallback on earlier versions
    }
    if(![myDelegate.tabbarType isEqualToString:@"1"])
    {
       self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    }
}
UIViewController *childViewControllerHomePage (NSString *title, NSString *imgName, NSUInteger tag) {
    HomePageViewController *vc = [[HomePageViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(0);
        // 添加上
        make.top.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(vc.view.width,200));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}

/// 系统样式UITabBarItem
UIViewController *childViewControllerUsers (NSString *title, NSString *imgName, NSUInteger tag) {
    UsersViewController *vc = [[UsersViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
// MARK: - UITabBarItem创建函数
/// 自定义样式UITabBarItem
UIViewController *childViewControllerToBeReview (NSString *title, NSString *imgName, NSUInteger tag) {
    ToBeReviewViewController *vc = [[ToBeReviewViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}

/// 系统样式UITabBarItem
UIViewController *childViewControllerAlreadyEnd (NSString *title, NSString *imgName, NSUInteger tag) {
    AlreadyEndViewController *vc = [[AlreadyEndViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerPending (NSString *title, NSString *imgName, NSUInteger tag) {
    PendingViewController *vc = [[PendingViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerPendingApproved (NSString *title, NSString *imgName, NSUInteger tag) {
    PendingApprovedViewController *vc = [[PendingApprovedViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 系统样式UITabBarItem
UIViewController *childViewControllerWaitingApply(NSString *title, NSString *imgName, NSUInteger tag) {
    WaitingApplyViewController *vc = [[WaitingApplyViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 系统样式UITabBarItem
UIViewController *childViewControllerApproving(NSString *title, NSString *imgName, NSUInteger tag) {
    ApprovingViewController *vc = [[ApprovingViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerApproved (NSString *title, NSString *imgName, NSUInteger tag) {
    ApprovedViewController *vc = [[ApprovedViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerWaitHandle (NSString *title, NSString *imgName, NSUInteger tag) {
    WaitHandleViewController *vc = [[WaitHandleViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerWaitApply (NSString *title, NSString *imgName, NSUInteger tag) {
    WaitApplyViewController *vc = [[WaitApplyViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerVatcationMain (NSString *title, NSString *imgName, NSUInteger tag) {
    VatcationMainView *vc = [[VatcationMainView alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
       //vc.tabBarController.tabBar.hidden = YES;
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerLeave (NSString *title, NSString *imgName, NSUInteger tag) {
    LeaveViewController *vc = [[LeaveViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerBWaitApply (NSString *title, NSString *imgName, NSUInteger tag) {
    BWaitApplyViewController *vc = [[BWaitApplyViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerSWFormCommon (NSString *title, NSString *imgName, NSUInteger tag) {
    SWFormCommonController *vc = [[SWFormCommonController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    //vc.tabBarController.tabBar.hidden = YES;
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerBApproved (NSString *title, NSString *imgName, NSUInteger tag) {
    BApprovedViewController *vc = [[BApprovedViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerGoOutWait (NSString *title, NSString *imgName, NSUInteger tag) {
    GoOutWaitController *vc = [[GoOutWaitController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerGoOut (NSString *title, NSString *imgName, NSUInteger tag) {
    GoOutViewController *vc = [[GoOutViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}

/// 自定义样式UITabBarItem
UIViewController *childViewControllerAttendanceCalendar (NSString *title, NSString *imgName, NSUInteger tag) {
    AttendanceCalendarViewController *vc = [[AttendanceCalendarViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerAttendanceSummary (NSString *title, NSString *imgName, NSUInteger tag) {
    AttendanceSummaryViewController *vc = [[AttendanceSummaryViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}


/// 自定义样式UITabBarItem
UIViewController *childViewControllerAgent (NSString *title, NSString *imgName, NSUInteger tag) {
    AgentViewController *vc = [[AgentViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    vc.NewTableView.frame = CGRectMake(0, 0, vc.view.width, vc.view.height);
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerSetAgent (NSString *title, NSString *imgName, NSUInteger tag) {
    SetAgentViewController *vc = [[SetAgentViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerNewView (NSString *title, NSString *imgName, NSUInteger tag) {
    NewViewController *vc = [[NewViewController alloc] init];
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
