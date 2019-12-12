//
//  AppDelegate.h
//  jcapp
//
//  Created by lh on 2019/11/15.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/** 设置全局变量的属性. */
//用户头像
@property (nonatomic, strong) UIImageView *userPhotoimageView;


@property (nonatomic, strong) NSString *leaveid;

@property (nonatomic, strong) NSString *processid;

@property (nonatomic, strong) NSString *way_groupid;

@property (nonatomic, strong) NSString *way_groupname;

@property (nonatomic, strong) NSString *way_empid;

@property (nonatomic, strong) NSString *way_empname;

@end

