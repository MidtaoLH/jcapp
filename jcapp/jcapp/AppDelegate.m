//
//  AppDelegate.m
//  jcapp yjl
//
//  Created by lh on 2019/11/15.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    CGRect rect=[[UIScreen mainScreen]bounds];
    //创建UIWindow
    self.window=[[UIWindow alloc] initWithFrame:rect];
    //设置背景颜色
    self.window.backgroundColor=[UIColor whiteColor];
    //设置keyWindow，并使其可见
    [self.window makeKeyAndVisible];
    //添加主控制器
    ViewController * vc=[[ViewController alloc] init];
    self.window.rootViewController=vc;
    return YES;
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSLog(@"\n%@\n%@\n%@",arr,reason,name);
    
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: @""
                               message: @"程序出错了"
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    /**
     *  获取异常崩溃信息
     */
//    NSArray *callStack = [exception callStackSymbols];
//    NSString *reason = [exception reason];
//    NSString *name = [exception name];
//    NSString *content = [NSString stringWithFormat:@"\n========异常错误报告========\n位置:%s\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@\n", __FUNCTION__,name,reason,[callStack componentsJoinedByString:@"\n"]];
//    NSLog(@"\n%@\n",content);
//    /**
//     *  把异常崩溃信息发送至开发者邮件
//     */
//    NSMutableString *mailUrl = [NSMutableString string];
//    [mailUrl appendString:@"yangjl@midtao.com"];
//    [mailUrl appendString:@"?subject=程序异常崩溃，请配合发送异常报告，谢谢合作！"];
//    [mailUrl appendFormat:@"&body=%@", content];
//    // 打开地址
//    NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];

}


























@end
