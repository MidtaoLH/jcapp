//
//  ZDYTTabBarViewController.m
//  jcapp
//
//  Created by youkare on 2019/11/20.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "LeaveTabBarViewController.h"
#import "LeaveViewController.h"
#import "WaitApplyViewController.h"
#import "../VatationPage/VatcationMainViewController.h"
#import "../VatationPage/VatcationMainView.h"
#import "AppDelegate.h"

@interface LeaveTabBarViewController ()

@end

@implementation LeaveTabBarViewController

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
    
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:@"待申请" image:[[UIImage imageNamed:@"tabBar_essence_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    item1.selectedImage = [[UIImage imageNamed:@"tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:@"" image:[[UIImage imageNamed:@"publish-text"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:@"请假记录" image:[[UIImage imageNamed:@"tabBar_friendTrends_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    item3.selectedImage = [[UIImage imageNamed:@"tabbar_person_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


    NSArray *controllers = @[@"WaitApplyViewController",@"VatcationMainViewController",@"WaitApplyViewController"];
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
        VatcationMainViewController *order = [[VatcationMainViewController alloc] init];
        
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        myDelegate.AppRoveType =@"qingjia";
        
        //VatcationMainView *order = [[VatcationMainView alloc] init];
        
        
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
    self.navigationItem.title=@"待请假记录";
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
