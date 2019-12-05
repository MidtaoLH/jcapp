//
//  ZDYTTabBarViewController.m
//  jcapp
//
//  Created by youkare on 2019/11/20.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "MyApplyTabBarViewController.h"
#import "WaitHandleViewController.h"
#import "ApprovedViewController.h"
#import "ApprovingViewController.h"
#import "WaitingApplyViewController.h"

@interface MyApplyTabBarViewController ()

@end

@implementation MyApplyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    CGRect tempRect = self.view.frame;
//    tempRect.size.height = 90;
//    self.view.frame = tempRect;
    
    [self dismissViewControllerAnimated:NO completion: nil];
    UINavigationController *nav;
    UIViewController *mainVC = [[WaitingApplyViewController alloc]init];
    nav = [[UINavigationController alloc] initWithRootViewController: mainVC];
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon.png"];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_icon.png"];
    nav.tabBarItem.title = @"待申请";

    [self addChildViewController: nav];

    UIViewController* mineVC = [[ApprovingViewController alloc] init];
    nav = [[UINavigationController alloc] initWithRootViewController: mineVC];
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon.png"];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_friendTrends_icon.png"];
    nav.tabBarItem.title = @"审批中";

    [self addChildViewController: nav];
    UIViewController *yjcVC = [[ApprovedViewController alloc]init];
    nav = [[UINavigationController alloc] initWithRootViewController: yjcVC];
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon.png"];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_icon.png"];
    nav.tabBarItem.title = @"已决裁";
    
    [self addChildViewController: nav];
    
    UIViewController* dclVC = [[WaitHandleViewController alloc] init];
    nav = [[UINavigationController alloc] initWithRootViewController: dclVC];
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon.png"];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_friendTrends_icon.png"];
    nav.tabBarItem.title = @"待处理";
    
    [self addChildViewController: nav];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"返回";
    self.navigationItem.hidesBackButton=false;
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
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
- (void)viewWillAppear:(BOOL)animated {
    //UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(goBack)];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    //UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    //backItem.title =@"返回";
    
    [self.navigationItem setLeftBarButtonItem:backItem];
    self.navigationItem.title=@"待申请记录";
}

- (void)goBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //[self.navigationController setNavigationBarHidden:NO animated:NO];
////    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
////    temporaryBarButtonItem.title =@"返回";
////    self.navigationItem.hidesBackButton=false;
////    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
//}
@end
