//
//  ZDYTTabBarViewController.m
//  jcapp
//
//  Created by lihe on 2019/12/26.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AgentTabBarViewController.h"
#import "../Agent_list/AgentViewController.h"
#import "../AgentSet/SetAgentViewController.h"
#import "AppDelegate.h"

@interface AgentTabBarViewController ()

@end

@implementation AgentTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    /************************隐藏tabbar上的黑色线条***************************/
    //    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //    UIGraphicsBeginImageContext(rect.size);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    //    CGContextFillRect(context, rect);
    //    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    [self.tabBar setBackgroundImage:img];
    //    [self.tabBar setShadowImage:img];
    /************************隐藏tabbar上的黑色线条***************************/
    
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:@"代理列表" image:[[UIImage imageNamed:@"tabBar_essence_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    item1.selectedImage = [[UIImage imageNamed:@"tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@"publish-text"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    
    NSArray *controllers = @[@"AgentViewController",@"SetAgentViewController",@"AgentViewController"];
    for (int i = 0; i < 3; i++) {
        Class cls = NSClassFromString([NSString stringWithFormat:@"%@",controllers[i]]);
        UIViewController *controller = (UIViewController *)[[cls alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
        nc.tabBarItem = @[item1,item2,item3][i];
        [self addChildViewController:nc];
    }
    
    
    UIImageView *tabbarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.tabBar.frame.size.height - 61, 200, 61)];
    tabbarView.image = [UIImage imageNamed:@"tabbar"];
    [self.tabBar addSubview:tabbarView];
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == self.viewControllers[1]) {
        //点击中间tabbarItem，不切换，让当前页面跳转
        //VatcationMainViewController *order = [[VatcationMainViewController alloc] init];
        
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        myDelegate.AppRoveType =@"agent";
        
        SetAgentViewController *order = [[SetAgentViewController alloc] init];
        order.hidesBottomBarWhenPushed = YES;
        [(UINavigationController *)tabBarController.selectedViewController pushViewController:order animated:YES];
        return NO;
    }
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    
    [self.navigationItem setLeftBarButtonItem:backItem];
    self.navigationItem.title=@"代理列表";
}

- (void)goBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}
//- (void)viewWillAppear:(BOOL)animated {
//
//    self.navigationController.navigationBarHidden = YES;
//
//}


@end
