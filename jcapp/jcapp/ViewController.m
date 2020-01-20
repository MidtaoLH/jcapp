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
#import <AdSupport/AdSupport.h>
#import "Masonry.h"
@interface ViewController () <UITextFieldDelegate>
- (IBAction)Login:(id)sender;

@end

NSString *usercount_str = @"";
int usercount_int = 0;
NSString *urlflag = @"";
NSString *Loginflag = @"false";
NSString *adId = @"";
NSString *adduserlistflag = @"true";

@implementation ViewController
@synthesize listOfUser;

//设置控件属性设置完才可以进行赋值等操作
@synthesize txtuser;
@synthesize txtpassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSArray *arr = @[@(0),@(1)];
    //NSLog(@"%@",arr[2]);//模拟越界异常
    
    adduserlistflag = @"true";
    
    self.usernamelist.delegate=self;
    self.usernamelist.dataSource=self;
    self.usernamelist.hidden = true;
    self.usernamelist.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.txtuser.delegate = self;
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
     NSString *userID = [defaults objectForKey:@"username"];
    usercount_str = [defaults objectForKey:@"usercount"];
    
    if(userID.length > 0)
    {
        
        NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,userID];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:userurlString]];
        
        
        
        if(data.length > 0)
        {
            UIImage *userimage = [UIImage imageWithData:data]; // 取得图片
            // 保存文件的名称1
            [self.myHeadPortrait setImage:userimage];
        }
        else
        {
            NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,@"moren"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:userurlString]];
            UIImage *userimage = [UIImage imageWithData:data]; // 取得图片
            // 保存文件的名称
            [self.myHeadPortrait setImage:userimage];
        }
            
        
    }
    else
    {
        NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,@"moren"];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:userurlString]];
        UIImage *userimage = [UIImage imageWithData:data]; // 取得图片
        // 保存文件的名称
        [self.myHeadPortrait setImage:userimage];
    }
    
    if(usercount_str.length > 0)
    {
       usercount_int =  [usercount_str intValue];
    }
    
    txtuser.text = userID;
    adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [defaults setObject:adId forKey:@"adId"];
    
    if(userID.length > 0)
    {
        urlflag = @"GetLoginStatus";
        adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        //设置需要访问的ws和传入参数
        
        NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetLoginStatus?User=%@&macid=%@", txtuser.text,adId];
        
        NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
        NSURL *url = [NSURL URLWithString:strURL];
        
        
        //NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetLoginStatus?User=%@&macid=%@", txtuser.text,adId];
        //NSURL *url = [NSURL URLWithString:strURL];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
    }
    [self loadstyle];
    // Do any additional setup after loading the view, typically from a nib.
    
}
-(void)loadstyle
{
    [self.myHeadPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScreenHeight*0.2);
        
        make.left.mas_equalTo(kScreenWidth*0.5-Common_LoginImage*0.5);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_LoginImage,Common_LoginImage));
    }];
    
    [self.lbltitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 添加上
        make.top.mas_equalTo(kScreenHeight*0.9);
        // 添加左
        //make.left.mas_equalTo(kScreenWidth*0.1);
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight*0.05));
    }];
    [self.txtuser mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 添加上
        make.top.mas_equalTo(kScreenHeight*0.4);
        // 添加左
        //make.left.mas_equalTo(kScreenWidth*0.1);
        make.left.mas_equalTo(Common_LoginLeft);
        // 添加大小约束
        //make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.8,kScreenHeight*0.05));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-Common_LoginLeft*2,kScreenHeight*0.05));
    }];
    [self.txtpassword mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 添加上
        //make.top.mas_equalTo(kScreenHeight*0.5);
        make.top.equalTo(self.txtuser).offset(self.txtpassword.height+Common_RowSize);
        // 添加左
        //make.left.mas_equalTo(kScreenWidth*0.1);
        make.left.mas_equalTo(Common_LoginLeft);
        // 添加大小约束
        //make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.8,kScreenHeight*0.05));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-Common_LoginLeft*2,kScreenHeight*0.05));
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 添加上
        make.top.mas_equalTo(kScreenHeight*0.6);
        // 添加左
        make.left.equalTo(self.txtuser);
        // 添加大小约束
        //make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.7,kScreenHeight*0.05));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-Common_LoginLeft*2,kScreenHeight*0.05));
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        // 添加上
        //make.top.mas_equalTo(kScreenHeight*0.4);
        make.right.equalTo(self.txtuser);
        make.bottom.equalTo(self.txtuser).offset(-10);

        // 添加左
        //make.left.mas_equalTo(kScreenWidth*0.9);
        //make.left.mas_equalTo(kScreenWidth-Common_LoginLeft-15);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(15,15));
    }];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"pull.png"] forState:(UIControlStateNormal)];

//    txtuser.layer.borderWidth= 1.0;
//    txtuser.borderStyle = UITextBorderStyleNone;
//    txtuser.layer.cornerRadius =15.0;
//    txtuser.layer.borderColor= [UIColor lightGrayColor].CGColor;

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,txtuser.height, kScreenWidth-Common_LoginLeft*2, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [txtuser addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.txtuser);
        make.bottom.equalTo(self.txtuser);
        make.right.equalTo(self.txtuser);
        make.size.mas_equalTo(CGSizeMake(1,1));
    }];
    float usercout=[usercount_str floatValue]+1;
    if(usercout>5){
        usercout=6;
    }
    [self.usernamelist mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 添加上
        make.top.equalTo(lineView);
        // 添加左
        //make.left.mas_equalTo(kScreenWidth*0.1);
        make.left.equalTo(self.txtuser);
        // 添加大小约束
        //make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.8,kScreenHeight*0.2));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-Common_LoginLeft*2, usercout*kScreenHeight*0.05));
    }];
//    txtpassword.layer.borderWidth= 1.0;
//    txtpassword.borderStyle = UITextBorderStyleNone;
//    txtpassword.layer.cornerRadius =15.0;
//    txtpassword.layer.borderColor= [UIColor lightGrayColor].CGColor;
    UIView *lineViewPW = [[UIView alloc]initWithFrame:CGRectMake(0,txtpassword.height, kScreenWidth-Common_LoginLeft*2, 1)];
    lineViewPW.backgroundColor = [UIColor blackColor];
    [txtpassword addSubview:lineViewPW];
    [lineViewPW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.txtpassword);
        make.bottom.equalTo(self.txtpassword);
        make.right.equalTo(self.txtpassword);
        make.size.mas_equalTo(CGSizeMake(1,1));
    }];
    
    self.usernamelist.layer.borderWidth = 0.5;
    self.usernamelist.layer.borderColor = [[UIColor blackColor] CGColor];//设置列表边框
    //self.usernamelist.layer.cornerRadius =15.0;
//    UIView *lineViewUList = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenHeight*0.05, kScreenWidth-Common_LoginLeft*2, 1)];
//    lineViewUList.backgroundColor = [UIColor blackColor];
//    [self.usernamelist addSubview:lineViewUList];
//    [lineViewUList mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.usernamelist);
//        make.bottom.equalTo(self.usernamelist);
//        make.right.equalTo(self.usernamelist);
//        make.size.mas_equalTo(CGSizeMake(1,1));
//    }];
    
    self.myHeadPortrait.layer.masksToBounds = YES;
    self.myHeadPortrait.layer.cornerRadius = Common_LoginImage * 0.5;
    //设置圆角的半径
    [_loginBtn.layer setCornerRadius:15];
    //切割超出圆角范围的子视图
    _loginBtn.layer.masksToBounds = YES;
    //设置边框的颜色
    [_loginBtn.layer setBorderColor:[UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1].CGColor];
    //设置边框的粗细
    [_loginBtn.layer setBorderWidth:1.0];
}

-(IBAction)onClickButtonChose:(id)sender
{
    self.usernamelist.hidden = false;
    [self.view bringSubviewToFront:txtuser];
}

//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(usercount_int > 0)
    {
        return usercount_int;
    }
    else
    {
        return 1;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *stringInt = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    NSString *keyname = [NSString stringWithFormat:@"%@-username",stringInt];
    NSString *username = [defaults objectForKey:keyname];
    
    txtuser.text =username;
    
    if( txtuser.text.length > 0)
    {
        NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,txtuser.text];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:userurlString]];
        
        if(data.length > 0)
        {
            UIImage *userimage = [UIImage imageWithData:data]; // 取得图片
            // 保存文件的名称1
            [self.myHeadPortrait setImage:userimage];
        }
        else
        {
            NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,@"moren"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:userurlString]];
            UIImage *userimage = [UIImage imageWithData:data]; // 取得图片
            // 保存文件的名称
            [self.myHeadPortrait setImage:userimage];
        }

    }
    else
    {
        NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,@"moren"];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:userurlString]];
        UIImage *userimage = [UIImage imageWithData:data]; // 取得图片
        // 保存文件的名称
        [self.myHeadPortrait setImage:userimage];
    }

    tableView.hidden = true;
    //tableView.show
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *stringInt = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    NSString *keyname = [NSString stringWithFormat:@"%@-username",stringInt];
    NSString *username = [defaults objectForKey:keyname];
    cell.textLabel.text = username;
    
    return cell;
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    //是否显示默认图片，一开始显示默认
    NSString *showflag = @"true";
    
    for(int i=1;i<=usercount_int;i++)
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *stringInt = [NSString stringWithFormat:@"%d",i];
        NSString *keyname = [NSString stringWithFormat:@"%@-username",stringInt];
        NSString *username = [defaults objectForKey:keyname];
       if([username isEqualToString: txtuser.text])
       {
           showflag = @"false";
           NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,txtuser.text];
           NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:userurlString]];
           
           if(data.length > 0)
           {
               UIImage *userimage = [UIImage imageWithData:data]; // 取得图片
               // 保存文件的名称1
               [self.myHeadPortrait setImage:userimage];
           }
           else
           {
               NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,@"moren"];
               NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:userurlString]];
               UIImage *userimage = [UIImage imageWithData:data]; // 取得图片
               // 保存文件的名称
               [self.myHeadPortrait setImage:userimage];
           }
       }
    }
    
    if([showflag isEqualToString:@"true"])
    {
        NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,@"moren"];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:userurlString]];
        UIImage *userimage = [UIImage imageWithData:data]; // 取得图片
        // 保存文件的名称
        [self.myHeadPortrait setImage:userimage];
    }
}

- (IBAction)Login:(id)sender {


    NSString *user = txtuser.text;
    NSString *password = txtpassword.text;
    if(user.length==0  || password.length == 0)
    {
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"用户名密码不能为空"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];   
        
        
    }
    else
    {
        urlflag = @"CheckUser";
        //先输出一下控件的值作为断点确认数据
        NSLog(@"%@", txtuser.text);
        NSLog(@"%@", txtpassword.text);
        //设置需要访问的ws和传入参数
        
        NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/CheckUser?User=%@&Password=%@&macid=%@", txtuser.text,txtpassword.text,adId];
        
        NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
        NSURL *url = [NSURL URLWithString:strURL];
        
        //NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/CheckUser?User=%@&Password=%@&macid=%@", txtuser.text,txtpassword.text,adId];
        //NSURL *url = [NSURL URLWithString:strURL];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
        
    }
    

}

-(IBAction)onClickButton:(id)sender {

    BusinessTripDetailViewController *nextVc = [[BusinessTripDetailViewController alloc]init];//初始化下一个界面
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
    
    @try {
       // NSLog(@"%@",@"hellotest");
        
        if([urlflag isEqualToString:@"CheckUser"])
        {
            
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
        else
        {
            xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
            NSRange endRagne = [xmlString rangeOfString:@"</string>"];
            NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
            NSString *resultString = [xmlString substringWithRange:reusltRagne];
            
            if([resultString isEqualToString:@"1"])
            {
                
                Loginflag = @"true";
            }
            else
            {
                Loginflag = @"false";
            }
            
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
}

//弹出消息框
-(void) connection:(NSURLConnection *)connection
  didFailWithError: (NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: @""
                               message: Common_NetErrMsg
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    //[errorAlert release];
    
}
//解析返回的xml系统自带方法不需要h中声明
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    
    if([urlflag isEqualToString:@"CheckUser"])
    {
        NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
        ipParser.delegate = self;
        [ipParser parse];
        NSString *message = @"";
        if(listOfUser.count > 0)
        {
            UserLogin *m =self.listOfUser[0];//取出数据元素
            if (![ m.flag isEqualToString:@"1"]) {
                //返回不为1显示登陆失败
                message = [[NSString alloc] initWithFormat:@"%@", @"用户名不存在或密码错误，登录失败"];
                //显示信息。正式环境时改为跳转
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @""
                                      message: message
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }else
            {
                //返回1为1显示登陆成功
                message = [[NSString alloc] initWithFormat:@"%@", @"登录成功！"];
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
                
                //test
                // fun1
                //self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(run) object:nil];
                //[self.thread start];
                
                
                //Loginflag = @"true";
                
                //fun2
                //[self performSelectorInBackground:@selector(multithread) withObject:nil];
                
                //fun3
                //NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadFunc) object:nil];
                //[thread start];

                //test
                
                
                //shezhi xialakuang
                 if(usercount_int > 0)
                 {
                     for(int i = 1; i<= usercount_int;i++)
                     {
                         NSString *stringInt = [NSString stringWithFormat:@"%d",i];
                        NSString *keyname = [NSString stringWithFormat:@"%@-username",stringInt];
                         NSString *username = [defaults objectForKey:keyname];
                         
                         
                         if([txtuser.text isEqualToString:username])
                         {
                             adduserlistflag = @"false";
                         }
                     }
                 }
                else
                {
                    [defaults setObject:@"1" forKey:@"usercount"];
                    NSString *keyname = [NSString stringWithFormat:@"%@-username",@"1"];
                    [defaults setObject:txtuser.text forKey:keyname];
                }
                
                if([adduserlistflag isEqualToString:@"true"])
                {
                    usercount_int = usercount_int + 1;
                    [defaults setObject:[NSString stringWithFormat:@"%d",usercount_int] forKey:@"usercount"];
                    
                    NSString *keyname = [NSString stringWithFormat:@"%@-username",[NSString stringWithFormat:@"%d",usercount_int]];
                    [defaults setObject:txtuser.text forKey:keyname];
                    
                }
                
                
                //如果需要追加其他字段，只需要修改实体，修改后台，然后存入磁盘就好
                [defaults synchronize];//保存到磁盘
                
                //将当前用户的头像存到全局变量
                UIImageView *imageView = [[UIImageView alloc] init];
                NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,txtuser.text];
                //[imageView sd_setImageWithURL:[NSURL URLWithString:userurlString] placeholderImage:nil options:SDWebImageRefreshCached];
//                //首先得拿到照片的路径，也就是下边的string参数，转换为NSData型。同步加载
//                NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userurlString]];
//                //然后就是添加照片语句，记得使用imageWithData:方法，不是imageWithName:。
//                UIImage* resultImage = [UIImage imageWithData: imageData];
//                AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//                myDelegate.userPhotoimageView=imageView;
//                //跳转到首页
//                myDelegate.tabbarType=@"1";
//                UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
//                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
//                [self presentViewController:navigationController animated:YES completion:nil];
//
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    myDelegate.userPhotoimageView=imageView;
                    //跳转到首页
                    myDelegate.tabbarType=@"1";
                    UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                    [self presentViewController:navigationController animated:YES completion:nil];
                }];
            }
        }
        else
        {
            NSLog(@"%@", @"123");
            //返回不为1显示登陆失败
            message = [[NSString alloc] initWithFormat:@"%@", @"用户名不存在或密码错误，登录失败"];
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: message
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }
    else
    {
        //zidong denglu
        if([Loginflag isEqualToString:@"true"])
        {
            //test
            //self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(run) object:nil];
            //[self.thread start];
            
            
            //[self performSelectorInBackground:@selector(multithread) withObject:nil];
            
            //NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadFunc) object:nil];
            //[thread start];

            //test
            
            //将当前用户的头像存到全局变量
            UIImageView *imageView = [[UIImageView alloc] init];
            NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,txtuser.text];
            //[imageView sd_setImageWithURL:[NSURL URLWithString:userurlString] placeholderImage:nil options:SDWebImageRefreshCached];
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                myDelegate.userPhotoimageView=imageView;
                //跳转到首页
                myDelegate.tabbarType=@"1";
                UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
            }];
        }
    }

}

//test

- (void)run{

    @autoreleasepool {
        
        //1、添加一个input source
        //[[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        //[[NSRunLoop currentRunLoop] run];
        //2、添加一个定时器
            NSTimer *timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
           [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}

-(void)multithread
{
    NSLog(@"HE");
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];


    [[NSRunLoop currentRunLoop]run];
    
    //创建后需要手动加入到runloop中
    //NSTimer * timer2 = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(timeAction:) userInfo:@"hello world" repeats:YES];
    //[[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
    
}
-(void)timeAction
{
    NSLog(@"HELLO");
    
    if( [Loginflag isEqualToString: @"false"])
    {
        //qiangzhi tuichu
         NSLog(@"tuichu app");
        
        ViewController * valueView = [[ViewController alloc] initWithNibName:@"ViewController"bundle:[NSBundle mainBundle]];
       
        //跳转
        [self presentModalViewController:valueView animated:YES];
        
        //abort();
    }
    else
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *userID = [defaults objectForKey:@"username"];
        
        urlflag = @"GetLoginStatus";
        adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        //设置需要访问的ws和传入参数
        
        NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetLoginStatus?User=%@&macid=%@", userID,adId];
        
        NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
        NSURL *url = [NSURL URLWithString:strURL];
        
        
        //NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetLoginStatus?User=%@&macid=%@", txtuser.text,adId];
        //NSURL *url = [NSURL URLWithString:strURL];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
        
        NSLog(@"yunxingzhong");
    }

    
}


- (void)threadFunc
{
   
    //NSTimer * timer1 = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
}

//test


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

}

//输入完成键盘退出
-(IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}
//点击背景键盘退出
-(IBAction)backgroundTap:(id)sender {
    [txtuser resignFirstResponder];
    [txtpassword resignFirstResponder];
    self.usernamelist.hidden = true;
    
}
//解决tableview线不对的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
//解决tableview线不对的问题
- (void)viewDidLayoutSubviews
{
    if ([_usernamelist respondsToSelector:@selector(setSeparatorInset:)]) {
        [_usernamelist setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_usernamelist respondsToSelector:@selector(setLayoutMargins:)]) {
        [_usernamelist setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
