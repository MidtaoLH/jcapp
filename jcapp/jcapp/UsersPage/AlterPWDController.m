//
//  AlterPWDController.m
//  jcapp
//
//  Created by lh on 2019/11/24.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AlterPWDController.h"
#import "UsersViewController.h"
@interface AlterPWDController ()
@property (weak, nonatomic) IBOutlet UITextField *txtpassword;
@property (weak, nonatomic) IBOutlet UITextField *txtenterpwd;
@property (weak, nonatomic) IBOutlet UITextField *txtoldpassword;
@property (weak, nonatomic) IBOutlet UIButton *btnupdate;
@property (weak, nonatomic) IBOutlet UILabel *lbloldpassword;
@property (weak, nonatomic) IBOutlet UILabel *lblenterpwd;
@property (weak, nonatomic) IBOutlet UILabel *lblpassword;
@end
NSString *xmlString;
NSMutableDictionary *info;
NSString *currentTagName;
NSString *currentValue;
NSString *resultString;
@implementation AlterPWDController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=0;
    self.view.backgroundColor=[UIColor colorWithRed:(242.0/255.0) green:(242.0/255.0) blue:(242.0/255.0) alpha:(1)];
    
    CGFloat headimageX = self.view.frame.size.width * 0.5;
    CGFloat headimageY = self.view.frame.size.height * 0.2;
    CGFloat headimageW = self.view.frame.size.width * 0.45;
    CGFloat headimageH = self.view.frame.size.height*0.05;
    self.txtoldpassword.frame = CGRectMake(headimageX, headimageY, headimageW, headimageH);
    headimageY = self.view.frame.size.height * 0.26;
    self.txtpassword.frame = CGRectMake(headimageX, headimageY, headimageW, headimageH);
    headimageY = self.view.frame.size.height * 0.32;
    self.txtenterpwd.frame = CGRectMake(headimageX, headimageY, headimageW, headimageH);
    
    headimageX = self.view.frame.size.width * 0.1;
    headimageY = self.view.frame.size.height * 0.2;
    self.lbloldpassword.frame = CGRectMake(headimageX, headimageY, headimageW, headimageH);
    headimageY = self.view.frame.size.height * 0.26;
    self.lblpassword.frame = CGRectMake(headimageX, headimageY, headimageW, headimageH);
    headimageY = self.view.frame.size.height * 0.32;
    self.lblenterpwd.frame = CGRectMake(headimageX, headimageY, headimageW, headimageH);
    
    headimageX = 0;
    headimageY = self.view.frame.size.height * 0.8;
    headimageW = self.view.frame.size.width*1.104;
    headimageH = self.view.frame.size.height*0.05;
    self.btnupdate.frame = CGRectMake(headimageX, headimageY, headimageW, headimageH);
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(IBAction)btnupdateClick:(id)sender {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"username"];
    NSString *oldpassword = self.txtoldpassword.text;
    NSString *password = self.txtpassword.text;
    NSString *enterpassword = self.txtenterpwd.text;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if(oldpassword.length==0)
    {
        if (version.doubleValue >= 9.0) {
            // 针对 9.0 以上的iOS系统进行处理
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"旧密码不能为空！" preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        } else {
            // 针对 9.0 以下的iOS系统进行处理
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息！"
                                  message: @"旧密码不能为空！"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(password.length==0)
    {
        if (version.doubleValue >= 9.0) {
            // 针对 9.0 以上的iOS系统进行处理
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"新密码不能为空！" preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        } else {
            // 针对 9.0 以下的iOS系统进行处理
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息！"
                                  message: @"新密码不能为空！"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(enterpassword.length==0)
    {
        if (version.doubleValue >= 9.0) {
            // 针对 9.0 以上的iOS系统进行处理
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"确认密码不能为空！" preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        } else {
            // 针对 9.0 以下的iOS系统进行处理
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息！"
                                  message: @"确认密码不能为空！"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(password!=enterpassword)
    {
        if (version.doubleValue >= 9.0) {
            // 针对 9.0 以上的iOS系统进行处理
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"两次新密码不一致！" preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        } else {
            // 针对 9.0 以下的iOS系统进行处理
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息！"
                                  message: @"两次新密码不一致！"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        //设置需要访问的ws和传入参数
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/UpdatePassWord?id=%@&password=%@&oldPassword=%@",user,password,oldpassword];
        //id,password,oldPassword
        NSURL *url = [NSURL URLWithString:strURL];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
    }
}
-(IBAction)btnreturnClick:(id)sender {
    UITabBarController *tabBarCtrl = [[UsersViewController alloc]init];
    [self presentViewController:tabBarCtrl animated:NO completion:nil];
}

//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //upateData = [[NSData alloc] initWithData:data];
    //默认对于中文的支持不好
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *gbkNSString = [[NSString alloc] initWithData:data encoding: enc];
    //如果是非UTF－8  NSXMLParser会报错。
    xmlString = [[NSString alloc] initWithString:[gbkNSString stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"gbk\"?>"
                                                                                        withString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"]];
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
}

//解析返回的xml系统自带方法不需要h中声明
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    ipParser.delegate = self;
    [ipParser parse];
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
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *message =@"";
    if ([currentTagName isEqualToString:@"string"]) {
        if ([string isEqualToString:@"1"]) {
            message = [[NSString alloc] initWithFormat:@"%@", @"修改成功！"];
            self.txtenterpwd.text=@"";
            self.txtpassword.text=@"";
            self.txtoldpassword.text=@"";
        }
        else if ([string isEqualToString:@"2"]) {
             message = [[NSString alloc] initWithFormat:@"%@", @"旧密码无效，请重新输入！"];
        }
        else{
             message = [[NSString alloc] initWithFormat:@"%@", @"修改失败！"];
        }
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"提示信息"
                              message: message
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
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
    [self.txtpassword resignFirstResponder];
    [self.txtoldpassword resignFirstResponder];
    [self.txtenterpwd resignFirstResponder];
}
@end
