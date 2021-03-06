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
#import "BusinessTripEditViewController.h"
#import "BApprovedViewController.h"
#import "GoOutWaitController.h"
#import "GoOutViewController.h"
#import "GoOutEditController.h"
#import "AttendanceCalendarViewController.h"
#import "AttendanceSummaryViewController.h"
#import "AgentViewController.h"
#import "SetAgentViewController.h"
#import "NewViewController.h"
#import "AddWayView.h"

#import "SelectUserViewController.h"

#import "Masonry.h"
#import "AppDelegate.h"

@interface TabBarViewController ()
@end

@implementation TabBarViewController
NSInteger barheight;

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([myDelegate.tabbarType isEqualToString:@"1"])
    {
        titleview=[[UIView alloc]init];
        [self.view addSubview:titleview];
        [titleview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            
            make.left.mas_equalTo(0);
            // 添加大小约束
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, StatusBarAndNavigationBarHeight));
        }];
        UILabel *titlelabel=[[UILabel alloc]init];
        [titleview addSubview:titlelabel];
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            
            make.left.mas_equalTo(0);
            // 添加大小约束
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, StatusBarAndNavigationBarHeight/2));
        }];
        [titlelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        [titlelabel setTextColor:[UIColor blueColor]];
        titlelabel.text=@"北京中道益通软件技术有限公司";
        //titleview.backgroundColor=UIColor.orangeColor;
        //titlelabel.centerY=titleview.centerY;
        self.navigationItem.titleView=titleview;
        [self addChildViewController:childViewControllerHomePage(@"首页", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerUsers(@"我的", @"tabBar_icon_mine_default", 1)];
    }
    else if([myDelegate.tabbarType isEqualToString:@"2"])
    {
        [self addChildViewController:childViewControllerWaitingApply(@"待申请", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerApproving(@"审批中", @"drop", 1)];
        [self addChildViewController:childViewControllerApproved(@"已决裁", @"drop", 2)];
        [self addChildViewController:childViewControllerWaitHandle(@"待处理", @"drop", 3)];
        self.navigationItem.title=@"待申请";
    }
    else if([myDelegate.tabbarType isEqualToString:@"3"])
    {
        [self addChildViewController:childViewControllerPending(@"待审批", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerPendingApproved(@"已审批", @"drop", 1)];
        self.navigationItem.title=@"待审批";
    }
    else if([myDelegate.tabbarType isEqualToString:@"4"])
    {
        [self addChildViewController:childViewControllerToBeReview(@"待回览", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerAlreadyEnd(@"已回览", @"drop", 1)];
        if([myDelegate.tabbarIndex isEqualToString:@"1"])
        {
            self.navigationItem.title=@"已回览";            
        }
        else
        {
            self.navigationItem.title=@"待回览";
        }
    }
    else if([myDelegate.tabbarType isEqualToString:@"5"])
    {
        myDelegate.AppRoveType =@"qingjia";
        [self addChildViewController:childViewControllerWaitApply(@"待申请", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerVatcationMain(@"", @"increase_meituan", 1)];
        [self addChildViewController:childViewControllerLeave(@"请假记录", @"drop", 2)];
        self.navigationItem.title=@"待申请";
    }
    else if([myDelegate.tabbarType isEqualToString:@"6"])
    {
        myDelegate.AppRoveType =@"chuchai";
        myDelegate.businessTripid=@"0";
        myDelegate.processid=@"0";
        myDelegate.pageType=@"1";
        [self addChildViewController:childViewControllerBWaitApply(@"待申请", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerSWFormCommon(@"", @"increase_meituan", 1)];
        [self addChildViewController:childViewControllerBApproved(@"出差记录", @"drop", 2)];
        self.navigationItem.title=@"待申请";
    }
    else if([myDelegate.tabbarType isEqualToString:@"7"])
    {
        myDelegate.AppRoveType =@"waichu";
        [self addChildViewController:childViewControllerGoOutWait(@"待申请", @"tabBar_essence_icon", 0)];
        [self addChildViewController:childViewControllerGoOutEdit(@"", @"increase_meituan", 1)];
        [self addChildViewController:childViewControllerGoOut(@"外出记录", @"drop", 2)];
        self.navigationItem.title=@"待申请";
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
        [self addChildViewController:childViewControllerAgent(@"代理人列表", @"tabBar_essence_icon", 0)];
        //[self addChildViewController:childViewControllerSetAgent(@"", @"increase_meituan", 1)];
        //[self addChildViewController:childViewControllerSelectUser(@"", @"", 2)];
        self.navigationItem.title=@"代理人列表";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addAgent)];
    }
    else if([myDelegate.tabbarType isEqualToString:@"10"])
    {
        [self addChildViewController:childViewControllerNewView(@"公告", @"tabBar_essence_icon", 0)];
        self.navigationItem.title=@"公告";
    }
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = kColor_unselectedItemTintColor;
    } else {
        // Fallback on earlier versions
    }
    self.tabBar.tintColor = kColor_tintColor;
    if(![myDelegate.tabbarType isEqualToString:@"1"])
    {
       self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    }
    else{
   
    }
 
}
- (void)addAgent {
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    myDelegate.agentType=@"false";
    SetAgentViewController * VCCollect = [[SetAgentViewController alloc] init];
    VCCollect.agentID=@"0";
    [self.navigationController pushViewController:VCCollect animated:YES];
}
UIViewController *childViewControllerHomePage (NSString *title, NSString *imgName, NSUInteger tag) {
    HomePageViewController *vc = [[HomePageViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,Common_ScrollSize));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}

/// 系统样式UITabBarItem
UIViewController *childViewControllerUsers (NSString *title, NSString *imgName, NSUInteger tag) {
    UsersViewController *vc = [[UsersViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.myHeadPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize);
        
        make.left.mas_equalTo(Common_ColSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_UserImageSize,Common_UserImageSize));
    }];
    [vc.lblname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize);
        
        make.left.mas_equalTo(Common_ColSize*2+Common_UserImageSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_TxTHeight));
    }];
    [vc.lblcode mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize*2);
        
        make.left.mas_equalTo(Common_ColSize*2+Common_UserImageSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_TxTHeight));
    }];
    [vc.lbldept mas_makeConstraints:^(MASConstraintMaker *make) {    make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize*3);
        
        make.left.mas_equalTo(Common_ColSize*2+Common_UserImageSize);
        // 添加大小约束
       make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_TxTHeight));
    }];
    [vc.userslist mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize*2);
        
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,Common_UserTableHeight));
    }];
    [vc.btnloginout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_UserTableHeight+Common_RowSize*4);
        
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,Common_BtnHeight));
    }];
    
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
// MARK: - UITabBarItem创建函数
/// 自定义样式UITabBarItem
UIViewController *childViewControllerToBeReview (NSString *title, NSString *imgName, NSUInteger tag) {
    ToBeReviewViewController *vc = [[ToBeReviewViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}

/// 系统样式UITabBarItem
UIViewController *childViewControllerAlreadyEnd (NSString *title, NSString *imgName, NSUInteger tag) {
    AlreadyEndViewController *vc = [[AlreadyEndViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerPending (NSString *title, NSString *imgName, NSUInteger tag) {
    PendingViewController *vc = [[PendingViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-TabbarHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerPendingApproved (NSString *title, NSString *imgName, NSUInteger tag) {
    PendingApprovedViewController *vc = [[PendingApprovedViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-TabbarHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 系统样式UITabBarItem
UIViewController *childViewControllerWaitingApply(NSString *title, NSString *imgName, NSUInteger tag) {
    WaitingApplyViewController *vc = [[WaitingApplyViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 系统样式UITabBarItem
UIViewController *childViewControllerApproving(NSString *title, NSString *imgName, NSUInteger tag) {
    ApprovingViewController *vc = [[ApprovingViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-TabbarHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerApproved (NSString *title, NSString *imgName, NSUInteger tag) {
    ApprovedViewController *vc = [[ApprovedViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-TabbarHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerWaitHandle (NSString *title, NSString *imgName, NSUInteger tag) {
    WaitHandleViewController *vc = [[WaitHandleViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-TabbarHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerWaitApply (NSString *title, NSString *imgName, NSUInteger tag) {
    WaitApplyViewController *vc = [[WaitApplyViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-TabbarHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}

/// 自定义样式UITabBarItem
UIViewController *childViewControllerGoOutEdit (NSString *title, NSString *imgName, NSUInteger tag) {
    GoOutEditController *vc = [[GoOutEditController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
       //vc.tabBarController.tabBar.hidden = YES;
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.formTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-TabbarHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerLeave (NSString *title, NSString *imgName, NSUInteger tag) {
    LeaveViewController *vc = [[LeaveViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-TabbarHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerBWaitApply (NSString *title, NSString *imgName, NSUInteger tag) {
    BWaitApplyViewController *vc = [[BWaitApplyViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-TabbarHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerSWFormCommon (NSString *title, NSString *imgName, NSUInteger tag) {
   UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    //vc.tabBarController.tabBar.hidden = YES;
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerVatcationMain (NSString *title, NSString *imgName, NSUInteger tag) {
    UIViewController *vc = [[UIViewController alloc] init];
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
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-TabbarHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerGoOutWait (NSString *title, NSString *imgName, NSUInteger tag) {
    GoOutWaitController *vc = [[GoOutWaitController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-TabbarHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerGoOut (NSString *title, NSString *imgName, NSUInteger tag) {
    GoOutViewController *vc = [[GoOutViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-TabbarHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}

/// 自定义样式UITabBarItem
UIViewController *childViewControllerAttendanceCalendar (NSString *title, NSString *imgName, NSUInteger tag) {
    AttendanceCalendarViewController *vc = [[AttendanceCalendarViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    
    [vc.myHeadPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize);
        
        make.left.mas_equalTo(Common_ColSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TableUserImageSize,Common_TableUserImageSize));
    }];
    [vc.lblname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize);
        
        make.left.mas_equalTo(Common_ColSize*2+Common_UserImageSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_TxTHeight));
    }];
    [vc.lbldept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize*2);
        
        make.left.mas_equalTo(Common_ColSize*2+Common_UserImageSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_TxTHeight));
    }];
    [vc.calview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_TableUserImageSize+Common_RowSize*2);
        
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight*0.47));
    }];
    [vc.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_TableUserImageSize+kScreenHeight*0.45+Common_RowSize*2);
        
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight*0.2));
    }]; 
    vc.myHeadPortrait.layer.masksToBounds = YES;
    vc.myHeadPortrait.layer.cornerRadius = Common_TableUserImageSize * 0.5;
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerAttendanceSummary (NSString *title, NSString *imgName, NSUInteger tag) {
    AttendanceSummaryViewController *vc = [[AttendanceSummaryViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.myHeadPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize);
        
        make.left.mas_equalTo(Common_ColSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TableUserImageSize,Common_TableUserImageSize));
    }];
    [vc.lblname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize);
        
        make.left.mas_equalTo(Common_ColSize*2+Common_UserImageSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_TxTHeight));
    }];
    [vc.lbldept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize*2);
        
        make.left.mas_equalTo(Common_ColSize*2+Common_UserImageSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_TxTHeight));
    }];
    [vc.btndate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize);
        
        make.left.mas_equalTo(kScreenWidth*0.5);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_BtnHeight));
    }];
    [vc.foldingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_TableUserImageSize);
        
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-(StatusBarAndNavigationBarHeight+Common_TableUserImageSize+Common_RowSize*2)));
    }];
    vc.myHeadPortrait.layer.masksToBounds = YES;
    vc.myHeadPortrait.layer.cornerRadius = Common_TableUserImageSize * 0.5;
    setAnimation(vc.tabBarItem, tag);
    return vc;
}

/// 自定义样式UITabBarItem
UIViewController *childViewControllerAgent (NSString *title, NSString *imgName, NSUInteger tag) {
    AgentViewController *vc = [[AgentViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}

/// 自定义样式UITabBarItem
UIViewController *childViewControllerSelectUser (NSString *title, NSString *imgName, NSUInteger tag) {
    
    SelectUserViewController *vc = [[SelectUserViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerAddWay (NSString *title, NSString *imgName, NSUInteger tag) {
    
    AddWayView *vc = [[AddWayView alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerSetAgent (NSString *title, NSString *imgName, NSUInteger tag) {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    
    vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 5);
    vc.tabBarItem.imageInsets=UIEdgeInsetsMake(-1,0,1,0);
    
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
/// 自定义样式UITabBarItem
UIViewController *childViewControllerNewView (NSString *title, NSString *imgName, NSUInteger tag) {
    NewViewController *vc = [[NewViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imgName] tag:tag];
    [vc.NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(0);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight));
    }];
    setAnimation(vc.tabBarItem, tag);
    return vc;
}
- (void)goBack {
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    myDelegate.tabbarType=@"1";
    UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:nil];
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
TLTransitionAniamtion *bounceAnimation(){
    TLTransitionAniamtion *anm = [TLTransitionAniamtion new];
    anm.direction = 1; // 1~6
    anm.disableDeselectAnimation = NO;
    return anm;

}

TLTransitionAniamtion *rotationAnimation(){
    TLTransitionAniamtion *anm = [TLTransitionAniamtion new];
    anm.direction = 1; // 1~6
    anm.disableDeselectAnimation = NO;
    return anm;

}

TLTransitionAniamtion *transitionAniamtion(){
    TLTransitionAniamtion *anm = [TLTransitionAniamtion new];
    anm.direction = 1; // 1~6
    anm.disableDeselectAnimation = NO;
    return anm;
}

TLTransitionAniamtion *fumeAnimation(){
    TLTransitionAniamtion *anm = [TLTransitionAniamtion new];
    anm.direction = 1; // 1~6
    anm.disableDeselectAnimation = NO;
    return anm;

}

TLTransitionAniamtion *frameAnimation(){
    TLTransitionAniamtion *anm = [TLTransitionAniamtion new];
    anm.direction =1; // 1~6
    anm.disableDeselectAnimation = NO;
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
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
     self.navigationItem.title=item.title;
    if([myDelegate.tabbarType isEqualToString:@"1"]){
        if(tabBar.selectedIndex==0){
            titleview.hidden=FALSE;
        }
        else{
            titleview.hidden=TRUE;
        }
    }
    
    if([myDelegate.tabbarType isEqualToString:@"6"]&&tabBar.selectedIndex==1)
    {
      
        BusinessTripEditViewController * VCCollect = [[BusinessTripEditViewController alloc] init];
        AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        myDelegate.pageType=@"1";
        [self.navigationController pushViewController:VCCollect animated:YES];
    }
    else if([myDelegate.tabbarType isEqualToString:@"5"]&&tabBar.selectedIndex==1)
    {
       
        VatcationMainView * VCCollect = [[VatcationMainView alloc] init];
        VCCollect.edittype=@"1";
        [self.navigationController pushViewController:VCCollect animated:YES];
    }
    else if([myDelegate.tabbarType isEqualToString:@"7"]&&tabBar.selectedIndex==1)
    {
       
        GoOutEditController  * VCCollect = [[GoOutEditController alloc] init];
        VCCollect.edittype = @"1"; //追加
        VCCollect.ProcessApplyCode= @""; 
        [self.navigationController pushViewController:VCCollect animated:YES];
    }
    else if([myDelegate.tabbarType isEqualToString:@"9"]&&tabBar.selectedIndex==1)
    {
        AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        myDelegate.agentType=@"false";
        SetAgentViewController  * VCCollect = [[SetAgentViewController alloc] init];
        VCCollect.agentID=@"0";
        [self.navigationController pushViewController:VCCollect animated:YES];
    }
}

@end
