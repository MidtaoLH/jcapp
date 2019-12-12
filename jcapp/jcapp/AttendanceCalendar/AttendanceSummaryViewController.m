//
//  AttendanceSummaryViewController.m
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AttendanceSummaryViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "ITDatePickerController.h"

@interface AttendanceSummaryViewController ()<ITDatePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblname;
@property (weak, nonatomic) IBOutlet UILabel *lbldept;
@property (weak, nonatomic) IBOutlet UIImageView *myHeadPortrait;
@property (weak, nonatomic) IBOutlet UIButton *btndate;
@property (strong, nonatomic) NSDate *startDate;
- (IBAction)startDateButtonOnClicked:(id)sender;
@end

@implementation AttendanceSummaryViewController

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
    self.lblname.frame=CGRectMake(self.myHeadPortrait.width+40, tabBarHeight-self.myHeadPortrait.height/5, headimageW, headimageH);
    self.lbldept.frame=CGRectMake(self.myHeadPortrait.width+40, tabBarHeight+self.myHeadPortrait.height/6, headimageW, headimageH);
    [self loadinfo];
   
    
    headimageH =  headimageW;
    headimageW = self.view.frame.size.width * 0.35;
    self.btndate.frame=CGRectMake(self.myHeadPortrait.width+ self.lblname.width+20, tabBarHeight, headimageW, headimageH);
    
    NSDate *newDate = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月"];
    NSString *dateString = [format stringFromDate:newDate];
    [self.btndate setTitle:dateString forState:UIControlStateNormal];
}
-(void)loadinfo{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"username"];
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetUserInfo?id=%@",user];
    //id,password,oldPassword
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if([infoString containsString:@"xmlns"])
    {
        infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // 字符串截取
        NSRange startRange = [infoString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">["];
        NSRange endRagne = [infoString rangeOfString:@"]</string>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [infoString substringWithRange:reusltRagne];
        
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        UserInfo *userinfo = [UserInfo mj_objectWithKeyValues:resultDic];
        self.lblname.text=userinfo.name;
        self.lbldept.text=userinfo.dept;
        
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        [self.myHeadPortrait setImage: myDelegate.userPhotoimageView.image];
        
    }
}
- (IBAction)startDateButtonOnClicked:(id)sender {
    
    ITDatePickerController *datePickerController = [[ITDatePickerController alloc] init];
    datePickerController.tag = 100;                     // Tag, which may be used in delegate methods
    datePickerController.delegate = self;               // Set the callback object
    datePickerController.showToday = NO;                // Whether to show "today", default is yes
    datePickerController.defaultDate = self.startDate;  // Default date
 
    [self presentViewController:datePickerController animated:YES completion:nil];
}
- (void)datePickerController:(ITDatePickerController *)datePickerController didSelectedDate:(NSDate *)date dateString:(NSString *)dateString {
    
    NSInteger tag = datePickerController.tag;
    UIButton *button = [self.view viewWithTag:tag];
    [self.btndate setTitle:dateString forState:UIControlStateNormal];
    if (datePickerController.tag == 100) {
        self.startDate = date;
    }
}
@end
