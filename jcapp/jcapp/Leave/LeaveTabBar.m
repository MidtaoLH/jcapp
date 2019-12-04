//
//  LeaveTabBar.m
//  jcapp
//
//  Created by zclmac on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "LeaveTabBar.h"
#import "WaitApplyViewController.h"
#import "LeaveViewController.h"

@interface LeaveTabBar ()

@end

@implementation LeaveTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
 
        //    CGRect tempRect = self.view.frame;
        //    tempRect.size.height = 90;
        //    self.view.frame = tempRect;
        
        [self dismissViewControllerAnimated:NO completion: nil];
        UINavigationController *nav;
        UIViewController *mainVC = [[WaitApplyViewController alloc]init];
        nav = [[UINavigationController alloc] initWithRootViewController: mainVC];
        nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon.png"];
        nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_icon.png"];
        nav.tabBarItem.title = @"待申请记录";
        
        [self addChildViewController: nav];
    
    [self addChildViewController: nav];
    
    UIViewController* midVC = [[LeaveViewController alloc] init];
    nav = [[UINavigationController alloc] initWithRootViewController: midVC];
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon.png"];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_friendTrends_icon.png"];
 
    
    [self addChildViewController: nav];
    
        UIViewController* mineVC = [[LeaveViewController alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController: mineVC];
        nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon.png"];
        nav.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_friendTrends_icon.png"];
        nav.tabBarItem.title = @"请假记录";
        
        [self addChildViewController: nav];
        //设置字体
        //    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:25], NSFontAttributeName, nil] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
}

@end
