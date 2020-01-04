//
//  ViewController.m
//  jcapp
//
//  Created by lh on 2019/11/15.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "ViewController.h"
#import "HomePage/HomePageViewController.h"
#import "VatationPage/VatationPageViewController.h"
#import "VatationPage/VatcationMainViewController.h"
#import "VatationPage/VatcationMainView.h"
#import "MJExtension/MJExtension.h"
#import "Model/UserLogin.h"
#import "Agent_list/AgentViewController.h"
#import "ExamineProj/ExamineEditLController.h"
#import "BusinessTrip/BusinessTripDetailViewController.h"


#import "Leave/LeaveViewController.h"
#import "Leave/LeaveTabBar.h"
#import "Leave/LeaveDetailController.h"
#import "Notice/NewViewController.h"
#import "Leave/WaitTaskController.h"
#import "DemoTableViewVC/SDTableViewController.h"
#import "GoOut/GoOutViewController.h"
#import "GoOut/GoOutWaitController.h"
#import "GoOut/GoOutDeatileController.h"
#import "GoOut/GoOutEditController.h"
#import "TaskViewBack/TaskBackInfoViewController.h"

#import "PendingPage/PendingViewController.h"
#import "AppDelegate.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AgentSet/AgentInfoViewController.h"

#import "Common/CommonApplyController.h"

#import "TabBar/TabBarViewController.h"
#import "BusinessTrip/BusinessTripEditViewController.h"

@interface ViewController ()
- (IBAction)Login:(id)sender;

@end

@implementation ViewController
@synthesize listOfUser;

//设置控件属性设置完才可以进行赋值等操作
@synthesize txtuser;
@synthesize txtpassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)Login:(id)sender {


    NSString *user = txtuser.text;
    NSString *password = txtpassword.text;
    if(user.length==0  || password.length == 0)
    {
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"提示信息！"
                              message: @"用户名密码不能为空！"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];   
        
        
    }
    else
    {
        
        //先输出一下控件的值作为断点确认数据
        NSLog(@"%@", txtuser.text);
        NSLog(@"%@", txtpassword.text);
        //设置需要访问的ws和传入参数
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/CheckUser?User=%@&Password=%@", txtuser.text,txtpassword.text];
        NSURL *url = [NSURL URLWithString:strURL];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
        
    }
    

}

-(IBAction)onClickButton:(id)sender {
    
    /*
                 VatationPageViewController * valueView = [[VatationPageViewController alloc] initWithNibName:@"VatationPageViewController"bundle:[NSBundle mainBundle]];
                 //从底部划入
                 [valueView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                 //跳转
                 [self presentModalViewController:valueView animated:YES];
    */
    
    //AgentViewController * valueView = [[AgentViewController alloc] initWithNibName:@"AgentViewController"bundle:[NSBundle mainBundle]];
    //从底部划入
    //[valueView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    //跳转
    //[self presentModalViewController:valueView animated:YES];

    //BusinessTripDetailViewController *nextVc = [[BusinessTripDetailViewController alloc]init];//初始化下一个界面
    //[self presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
    
    
   
    VatcationMainViewController *nextVc = [[VatcationMainViewController alloc]init];//初始化下一个界面
    [self presentViewController:nextVc animated:YES completion:nil];//跳转到下一个


}

-(IBAction)onClickButtontest:(id)sender {
    NSLog(@"%@", @"test");

}	
-(IBAction)onClickButtonLeave:(id)sender {

     ExamineEditLController * valueView = [[ExamineEditLController alloc] initWithNibName:@"ExamineEditLController"bundle:[NSBundle mainBundle]];
    
      [valueView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
     //跳转
     [self presentModalViewController:valueView animated:YES];
     

    }

-(IBAction)onClickButtonLeaveP:(id)sender {
    BusinessTripEditViewController * valueView = [[BusinessTripEditViewController alloc] initWithNibName:@"BusinessTripEditViewController"bundle:[NSBundle mainBundle]];
    //从底部划入
    [valueView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    //跳转
    [self presentModalViewController:valueView animated:YES];
    
}
//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    
    NSLog(@"%@",@"connection1-begin");

    
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
    NSRange endRagne = [xmlString rangeOfString:@"</string>"];
    NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
    NSString *resultString = [xmlString substringWithRange:reusltRagne];
    
    NSLog(@"%@", resultString);
    
    NSString *requestTmp = [NSString stringWithString:resultString];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    

    
    NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    listOfUser = [UserLogin mj_objectArrayWithKeyValuesArray:resultDic];
    
}

//弹出消息框
-(void) connection:(NSURLConnection *)connection
  didFailWithError: (NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [error localizedDescription]
                               message: [error localizedFailureReason]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    //[errorAlert release];
    
}

//解析返回的xml系统自带方法不需要h中声明
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    
    //NSLog(@"%@", listOfUser.count);
    
       //开始解析XML
    
    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    ipParser.delegate = self;
    [ipParser parse];
    NSString *message = @"";
    
    if(listOfUser.count > 0)
    {
        
        UserLogin *m =self.listOfUser[0];//取出数据元素
        
        if (![ m.flag isEqualToString:@"1"]) {
            //返回不为1显示登陆失败
            message = [[NSString alloc] initWithFormat:@"%@", @"登录失败"];
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"登录结果"
                                  message: message
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }else
        {
            //返回1为1显示登陆成功
            message = [[NSString alloc] initWithFormat:@"%@", @"登录成功！"];
            //将当前用户的头像存到全局变量
            UIImageView *imageView = [[UIImageView alloc] init];
            NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,txtuser.text];
            [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString] placeholderImage:nil options:SDWebImageRefreshCached];
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            myDelegate.userPhotoimageView=imageView;
            //保存用户名密码
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            
                        if (![txtuser.text isEqualToString:[defaults objectForKey:@"username"]]||![txtpassword.text isEqualToString:[defaults objectForKey:@"password"]] ) {
                
                                [defaults setObject:txtuser.text forKey:@"username"];
                
                                [defaults setObject:txtpassword.text forKey:@"password"];
                
                               
                            }
            
            [defaults setObject:m.id forKey:@"userid"];
            [defaults setObject:m.EmpID forKey:@"EmpID"];
            [defaults setObject:m.name forKey:@"empname"];
            [defaults setObject:m.Groupid forKey:@"Groupid"];
            [defaults setObject:m.GroupName forKey:@"GroupName"];
            [defaults setObject:m.UserNO forKey:@"UserNO"];
            [defaults setObject:m.UserHour forKey:@"UserHour"];
            [defaults setObject:m.IsNotice forKey:@"IsNotice"];
            
            //如果需要追加其他字段，只需要修改实体，修改后台，然后存入磁盘就好
            [defaults synchronize];//保存到磁盘
            //跳转到首页
            myDelegate.tabbarType=@"1";
            UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
        
    }
    else
    {
        NSLog(@"%@", @"123");
        //返回不为1显示登陆失败
        message = [[NSString alloc] initWithFormat:@"%@", @"登录失败"];
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"登录结果"
                              message: message
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];    }
    
}

//解析xml回调方法
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    info = [[NSMutableDictionary alloc] initWithCapacity: 1];
}

//回调方法出错弹框
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [parseError localizedDescription]
                               message: [parseError localizedFailureReason]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    //[errorAlert release];
}

//解析返回xml的节点elementName
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {

    currentTagName = elementName;
}

//取得我们需要的节点的数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
   
    
    }


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
}

//循环解析d节点
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    NSMutableString *outstring = [[NSMutableString alloc] initWithCapacity: 1];
    for (id key in info) {
        [outstring appendFormat: @"%@: %@\n", key, [info objectForKey:key]];
    }
    
    
    
    //[outstring release];
    //[xmlString release];
}



//输入完成键盘退出
-(IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}
//点击背景键盘退出
-(IBAction)backgroundTap:(id)sender {
    [txtuser resignFirstResponder];
    [txtuser resignFirstResponder];
    
}

@end
