//
//  AttendanceCalendarViewController.m
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AttendanceCalendarViewController.h"
#import "AttendanceTabBarViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "../Calendar/WHUCalendarView.h"
#import "../Calendar/WHUCalendarPopView.h"
@interface AttendanceCalendarViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblname;
@property (weak, nonatomic) IBOutlet UILabel *lbldept;
@property (weak, nonatomic) IBOutlet UIImageView *myHeadPortrait;
@property (weak, nonatomic) WHUCalendarPopView *pop;
@property (weak, nonatomic) IBOutlet WHUCalendarView *calview;
@end

@implementation AttendanceCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat tabBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height+20;
    CGFloat headimageW = self.view.frame.size.width * 0.25;
    CGFloat headimageH = headimageW;
    self.myHeadPortrait.frame = CGRectMake(20, tabBarHeight*0.9, headimageW, headimageH);
    //这句必须写
    self.myHeadPortrait.layer.masksToBounds = YES;
    self.myHeadPortrait.layer.cornerRadius = headimageW * 0.5;
    self.myHeadPortrait.image = [UIImage imageNamed:@"1"];
    self.myHeadPortrait.backgroundColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
    
    headimageW = self.view.frame.size.width * 0.25;
    headimageH =  headimageW;
     self.lblname.frame=CGRectMake(self.myHeadPortrait.width+40, tabBarHeight-self.myHeadPortrait.height/6, headimageW, headimageH);
    self.lbldept.frame=CGRectMake(self.myHeadPortrait.width+40, tabBarHeight+self.myHeadPortrait.height/5, headimageW, headimageH);
    headimageW = self.view.frame.size.width * 0.3;
    
    self.calview.tagStringOfDate=^NSString*(NSArray* calm,NSArray* itemDateArray){
        NSLog(@"%@",calm);
        //如果当前日期中的天数,可以被5整除,显示 预约
        if([itemDateArray[2] integerValue]%5==0){
            return @"请假";
        }
        else{
            return nil;
        }
    };
    self.calview.onDateSelectBlk=^(NSDate* date){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy年MM月dd"];
        NSString *dateString = [format stringFromDate:date];
        NSLog(@"calview:%@",dateString);
    };
    self.pop=[[WHUCalendarPopView alloc] init];
    self.pop.onDateSelectBlk=^(NSDate* date){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy年MM月dd"];
        NSString *dateString = [format stringFromDate:date];
        NSLog(@"%@",dateString);
    };
    
    [self loadinfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)loadinfo{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    empname = [defaults objectForKey:@"empname"];
    groupname = [defaults objectForKey:@"GroupName"];
    self.lblname.text=empname;
    self.lbldept.text=groupname;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    [self.myHeadPortrait setImage: myDelegate.userPhotoimageView.image];
}

@end
