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
@interface AttendanceSummaryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblname;
@property (weak, nonatomic) IBOutlet UILabel *lbldept;
@property (weak, nonatomic) IBOutlet UIImageView *myHeadPortrait;
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
    self.lbldept.frame=CGRectMake(self.myHeadPortrait.width+40, tabBarHeight+self.myHeadPortrait.height/5, headimageW, headimageH);
    headimageW = self.view.frame.size.width * 0.3;
     [self loadinfo];
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
@end
