//
//  AttendanceSummaryTabBarViewController.m
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AttendanceCalendarViewController.h"
#import "AttendanceSummaryViewController.h"
#import "AttendanceTabBarViewController.h"

@interface AttendanceTabBarViewController ()

@end

@implementation AttendanceTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    CGRect tempRect = self.view.frame;
    //    tempRect.size.height = 90;
    //    self.view.frame = tempRect;
    
    [self dismissViewControllerAnimated:NO completion: nil];
    UINavigationController *nav;
    UIViewController *mainVC = [[AttendanceCalendarViewController alloc]init];
    nav = [[UINavigationController alloc] initWithRootViewController: mainVC];
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon.png"];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_icon.png"];
    nav.tabBarItem.title = @"考勤日历";
    [self addChildViewController: nav];
    
    UIViewController *yjcVC = [[AttendanceSummaryViewController alloc]init];
    nav = [[UINavigationController alloc] initWithRootViewController: yjcVC];
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon.png"];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_icon.png"];
    nav.tabBarItem.title = @"考勤日历月汇总";
    [self addChildViewController: nav];
    
    //设置字体
    //    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:25], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    
}
//- (void)viewDidLayoutSubviews{
//    //    NSLog(@"%s",__func__);
//    //此方法在创建每个子View时都会调用，此类中调用两次，下方代码只需要一次
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        CGRect frame = CGRectMake(0
//                                  , self.tabBar.frame.origin.y-41
//                                  , self.tabBar.frame.size.width
//                                  , 90);
//        self.tabBar.frame = frame;
//        //NSLog(@"%lf, %lf, %lf, %lf,", self.tabBar.frame.origin.x, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//        //        self.tabBar.backgroundColor = [UIColor redColor];
//
//        UINavigationController *nav;
//        UIViewController *mainVC = [[HomePageViewController alloc]init];
//        nav = [[UINavigationController alloc] initWithRootViewController: mainVC];
//        nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon.png"];
//        nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_icon.png"];
//        nav.tabBarItem.title = @"首页";
//
//        [self addChildViewController: nav];
//
//        UIViewController* mineVC = [[UsersViewController alloc] init];
//        nav = [[UINavigationController alloc] initWithRootViewController: mineVC];
//        nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon.png"];
//        nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_friendTrends_icon.png"];
//        nav.tabBarItem.title = @"我的";
//
//        //[self addChildViewController: nav];
//        [self.tabBar addSubview:nav];
//
//    });
//}


-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
}
@end
