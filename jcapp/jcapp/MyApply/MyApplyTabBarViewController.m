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
    self.delegate = self;
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
        
    //设置字体
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:25], NSFontAttributeName, nil] forState:UIControlStateNormal];
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == self.viewControllers[0]) {
        self.navigationItem.title=@"待申请记录";
    }else if (viewController == self.viewControllers[1]) {
        self.navigationItem.title=@"审批中记录";
    }else if (viewController == self.viewControllers[2]) {
        self.navigationItem.title=@"已决裁记录";
    }else if (viewController == self.viewControllers[3]) {
        self.navigationItem.title=@"待处理记录";
    }
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    
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
