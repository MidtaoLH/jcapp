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

@interface TaskViewTabBarViewController ()

@end

@implementation TaskViewTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //    CGRect tempRect = self.view.frame;
    //    tempRect.size.height = 90;
    //    self.view.frame = tempRect;
    
    [self dismissViewControllerAnimated:NO completion: nil];
    UINavigationController *nav;
    UIViewController *mainVC = [[ToBeReviewViewController alloc]init];
    nav = [[UINavigationController alloc] initWithRootViewController: mainVC];
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon.png"];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_icon.png"];
    nav.tabBarItem.title = @"待回览";
    [self addChildViewController: nav];
    
    UIViewController *yjcVC = [[AlreadyEndViewController alloc]init];
    nav = [[UINavigationController alloc] initWithRootViewController: yjcVC];
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon.png"];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_icon.png"];
    nav.tabBarItem.title = @"已回览";
    [self addChildViewController: nav];
    
    //设置字体
    //    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:25], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == self.viewControllers[0]) {
        self.navigationItem.title=@"待回览";
    }else if (viewController == self.viewControllers[1]) {
        self.navigationItem.title=@"已回览";
    }
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    
    [self.navigationItem setLeftBarButtonItem:backItem];
    self.navigationItem.title=@"待回览";
}

- (void)goBack {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
