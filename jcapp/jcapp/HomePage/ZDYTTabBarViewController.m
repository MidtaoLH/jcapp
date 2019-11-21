//
//  ZDYTTabBarViewController.m
//  jcapp
//
//  Created by youkare on 2019/11/20.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "ZDYTTabBarViewController.h"
#import "HomePageViewController.h"
#import "myViewController.h"

@interface ZDYTTabBarViewController ()

@end

@implementation ZDYTTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dismissViewControllerAnimated:NO completion: nil];
    UINavigationController *nav;
    UIViewController *mainVC = [[HomePageViewController alloc]init];
    nav = [[UINavigationController alloc] initWithRootViewController: mainVC];
    nav.tabBarItem.image = [UIImage imageNamed:@"首页-灰色.png"];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"首页-绿色.png"];
    nav.tabBarItem.title = @"首页";
    [self addChildViewController: nav];
    
    UIViewController* mineVC = [[myViewController alloc] init];
    nav = [[UINavigationController alloc] initWithRootViewController: mineVC];
    nav.tabBarItem.image = [UIImage imageNamed:@"我的-灰色.png"];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:@"我的-绿色.png"];
    nav.tabBarItem.title = @"我的";
    [self addChildViewController: nav];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
}
@end
