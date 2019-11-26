//
//  ViewController.m
//  jcapp
//
//  Created by lh on 2019/11/15.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "ViewController.h"
#import "HomePage/HomePageViewController.h"
#import "HomePage/ZDYTTabBarViewController.h"
#import "VatationPage/VatationPageViewController.h"


@interface ViewController ()
- (IBAction)Login:(id)sender;

@end

@implementation ViewController

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
    
   
    //
    //下边为手动释放内存需要进行设置MRC 和 ARC
    //[connection release];
    //[request release];
    
    
    //返回
    ////[self dismissModalViewControllerAnimated:YES];        }

}

-(IBAction)onClickButton:(id)sender {
    
                 VatationPageViewController * valueView = [[VatationPageViewController alloc] initWithNibName:@"VatationPageViewController"bundle:[NSBundle mainBundle]];
                 //从底部划入
                 [valueView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                 //跳转
                 [self presentModalViewController:valueView animated:YES];
}

-(IBAction)onClickButtontest:(id)sender {
    NSLog(@"%@", @"test");
    

}



//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    //upateData = [[NSData alloc] initWithData:data];
    //默认对于中文的支持不好
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *gbkNSString = [[NSString alloc] initWithData:data encoding: enc];
    NSLog(@"%@", @"test");
    NSLog(@"%@", gbkNSString);
    
    //如果是非UTF－8  NSXMLParser会报错。
    xmlString = [[NSString alloc] initWithString:[gbkNSString stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"gbk\"?>"
                                                                                        withString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"]];
    
    NSLog(@"%@", xmlString);
    //NSLog(@"%@", utf8NSString);
    //下边为手动释放内存需要进行设置MRC 和 ARC
    //[gbkNSString release];
    
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
    
    NSLog(@"%@", xmlString);
    NSLog(@"%@", @"kaishijiex");    //开始解析XML
    
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
    NSLog(@"value: %@\n", elementName);
    //NSLog(@"%@", @"jiedian1");    //设置标记查看解析到哪个节点
    currentTagName = elementName;
}

//取得我们需要的节点的数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"value: %@\n", string);
    //NSLog(@"value: %@\n", @"jiedian2");
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *message =@"";
    if ([currentTagName isEqualToString:@"string"]) {
        if (![string isEqualToString:@"1"]) {
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
            
            //保存用户名密码
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            
                        if (![txtuser.text isEqualToString:[defaults objectForKey:@"username"]]||![txtpassword.text isEqualToString:[defaults objectForKey:@"password"]] ) {
                
                                [defaults setObject:txtuser.text forKey:@"username"];
                
                                [defaults setObject:txtpassword.text forKey:@"password"];
                
                                [defaults synchronize];//保存到磁盘
                            }

    
            
//             HomePageViewController * valueView = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController"bundle:[NSBundle mainBundle]];
//             //从底部划入
//             [valueView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//             //跳转
//             [self presentModalViewController:valueView animated:YES];
            UITabBarController *tabBarCtrl = [[ZDYTTabBarViewController alloc]init];
            
            [self presentViewController:tabBarCtrl animated:NO completion:nil];
            
        }
        UITabBarController *tabBarCtrl = [[ZDYTTabBarViewController alloc]init];
        
        [self presentViewController:tabBarCtrl animated:NO completion:nil];
    //[alert release];
    
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
