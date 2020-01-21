//
//  SetAgentViewController.m
//  jcapp
//
//  Created by lh on 2019/12/23.
//  Copyright © 2019 midtao. All rights reserved.
//
#import "SetAgentViewController.h"
#import "SWForm.h"
#import "SWFormHandler.h"
#import "../VatationPage/CalendaViewController.h"
#import "../MJRefresh/MJRefresh.h"
#import "../MJExtension/MJExtension.h"
#import "../AppDelegate.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#import "Masonry.h"
#import "TabBarViewController.h"
#import "../Model/MessageInfo.h"
#import "../Model/AgentInfo.h"
#import "SelectUserViewController.h"
#import "../ViewController.h"


@interface SetAgentViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) SWFormItem *businessTripStart;
@property (nonatomic, strong) SWFormItem *businessTripEnd;
@property (nonatomic, strong) SWFormItem *agentname;
@end

@implementation SetAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    iosid = [defaults objectForKey:@"adId"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.title=@"代理人设定";
    
    datePickers = [[UIDatePicker alloc] init]; datePickers.datePickerMode = UIDatePickerModeDate;
    [datePickers setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    datePickere = [[UIDatePicker alloc] init]; datePickere.datePickerMode = UIDatePickerModeDate;
    [datePickere setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    [self.formTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight);
        // 添加左
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,Common_TableHeight));
    }];
    
    [self loadData];
    self.formTableView.scrollEnabled  = NO;
    //self.formTableView.scrollEnabled = YES;
}
/**
 数据源处理
 */
- (void)datas {
     AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    SWWeakSelf
    NSMutableArray *items = [NSMutableArray array];
    self.agentname = SWFormItem_Add(@"代理人", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
    //self.name.showLength = YES;
    self.agentname.maxInputLength = 30;
    self.agentname.itemSelectCompletion = ^(SWFormItem *item) {
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"tableviewtype" forKey:@"type"];
        [defaults synchronize];//保存到磁盘
        SelectUserViewController  * VCCollect = [[SelectUserViewController alloc] init];
        myDelegate.agentid=self.agentID;
        [self.navigationController pushViewController:VCCollect animated:YES];
    };
    [items addObject:_agentname];
    SWFormItem *dept = SWFormItem_Info(@"代理人部门",  myDelegate.way_groupname, SWFormItemTypeInput);
    dept.keyboardType = UIReturnKeyDefault;
    [items addObject:dept];
    self.businessTripStart = SWFormItem_Add(@"开始日期", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
    //self.name.showLength = YES;
    self.businessTripStart.maxInputLength = 30;
    self.businessTripStart.itemSelectCompletion = ^(SWFormItem *item) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil 　　preferredStyle:UIAlertControllerStyleActionSheet];
        [alert.view addSubview:datePickers];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            //实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
            NSString *dateString = [dateFormat stringFromDate:datePickers.date];
            //求出当天的时间字符串
            NSLog(@"%@",dateString);
            self.businessTripStart.info=dateString;
            myDelegate.TimeStart=dateString;
            [self.formTableView beginUpdates];
            [self.formTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            [self.formTableView endUpdates];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            　 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{ }];
    };
    [items addObject:_businessTripStart];
    self.businessTripEnd = SWFormItem_Add(@"结束日期", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
    self.businessTripEnd.maxInputLength = 30;
    //self.age.info=@"2019-12-15";
    self.businessTripEnd.itemSelectCompletion = ^(SWFormItem *item) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil 　　preferredStyle:UIAlertControllerStyleActionSheet];
        [alert.view addSubview:datePickere];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            //实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
            NSString *dateString = [dateFormat stringFromDate:datePickere.date];
            //求出当天的时间字符串
            NSLog(@"%@",dateString);
            self.businessTripEnd.info=dateString;
            myDelegate.TimeEnd=dateString;
            [self.formTableView beginUpdates];
            [self.formTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            [self.formTableView endUpdates];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            　 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{ }];
    };
    [items addObject:_businessTripEnd];
    SWFormSectionItem *sectionItem = SWSectionItem(items);
    //    sectionItem.headerHeight = 10;
    //    sectionItem.footerView = [self footerView];
    //    sectionItem.footerHeight = 80;
    [self.mutableItems addObject:sectionItem];
}

- (void)loadData {
      AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([myDelegate.agentType isEqualToString:@"info"]) {
        myDelegate.agentType=@"";
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *userID = [defaults objectForKey:@"userid"];
        //设置需要访问的ws和传入参数
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetAgentSetInfo?userID=%@&agentID=%@&iosid=%@",userID,self.agentID ,iosid];
        NSURL *url = [NSURL URLWithString:strURL];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
        
    }
    else if ([myDelegate.agentType isEqualToString:@"true"]) {
        [self datas];
        AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        // 日期格式化类
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        // 设置日期格式 为了转换成功
        format.dateFormat = @"yyyy-MM-dd";
        self.agentname.info=myDelegate.way_empname;
        self.businessTripStart.info=myDelegate.TimeStart;
        self.businessTripEnd.info=myDelegate.TimeEnd;
        self.agentID=myDelegate.agentid;
        NSString *string = self.businessTripStart.info;
        if(string.length>0)
        {
            NSDate *data = [format dateFromString: string];
            [datePickers setDate:data animated:YES];
        }
        // 时间字符串
        string = self.businessTripEnd.info;
        if(string.length>0)
        {
            NSDate *data = [format dateFromString:string];
            [datePickere setDate:data animated:YES];
        }
        [self.formTableView reloadData];
        [self.formTableView layoutIfNeeded];
    }
    else{
        AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        myDelegate.way_empid=@"";
        myDelegate.way_empname=@"";
        myDelegate.way_groupname=@"";
        myDelegate.TimeStart=@"";
        myDelegate.TimeEnd=@"";
        myDelegate.agentid=@"0";
        [self datas];
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
    
}

//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    @try {
        
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if([xmlString containsString: Common_MoreDeviceLoginFlag])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"" message: Common_MoreDeviceLoginErrMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            ViewController * valueView = [[ViewController alloc] initWithNibName:@"ViewController"bundle:[NSBundle mainBundle]];
            //跳转
            [self presentModalViewController:valueView animated:YES];
        }
        else
        {
            // 字符串截取
            NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">["];
            NSRange endRagne = [xmlString rangeOfString:@"]</string>"];
            NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
            NSString *resultString = [xmlString substringWithRange:reusltRagne];
            
            NSString *requestTmp = [NSString stringWithString:resultString];
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            if([xmlString containsString:@"msg"])
            {
                MessageInfo *messageInfo = [MessageInfo mj_objectWithKeyValues:resultDic];
                if([messageInfo.msg containsString:@"成功"])
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @""
                                          message: messageInfo.msg
                                          delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @""
                                          message: messageInfo.msg
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
            }
            else
            {
                
                AgentInfo *agentInfo = [AgentInfo mj_objectWithKeyValues:resultDic];
                
                AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                myDelegate.way_empid=agentInfo.EmpID;
                myDelegate.way_empname=agentInfo.EmpName;
                myDelegate.way_groupname=agentInfo.DeptName;
                myDelegate.TimeStart=agentInfo.AgentStartDate;
                myDelegate.TimeEnd=agentInfo.AgentEndDate;
                myDelegate.agentid=agentInfo.AgentSetID;
                [self datas];
                // 日期格式化类
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                // 设置日期格式 为了转换成功
                format.dateFormat = @"yyyy-MM-dd";
                self.agentname.info=myDelegate.way_empname;
                self.businessTripStart.info=myDelegate.TimeStart;
                self.businessTripEnd.info=myDelegate.TimeEnd;
                self.agentID=myDelegate.agentid;
                NSString *string = self.businessTripStart.info;
                if(string.length>0)
                {
                    NSDate *data = [format dateFromString: string];
                    [datePickers setDate:data animated:YES];
                }
                // 时间字符串
                string = self.businessTripEnd.info;
                if(string.length>0)
                {
                    NSDate *data = [format dateFromString:string];
                    [datePickere setDate:data animated:YES];
                }
                [self.formTableView reloadData];
                [self.formTableView layoutIfNeeded];
            }
        }
    }
    @catch (NSException *exception) {
        NSArray *arr = [exception callStackSymbols];
        NSString *reason = [exception reason];
        NSString *name = [exception name];
        NSLog(@"err:\n%@\n%@\n%@",arr,reason,name);
    }
    
}

- (void)addAction {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"userid"];
    NSString *empID = [defaults objectForKey:@"EmpID"];
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([self.agentID isEqual:@"0"])
    {
        //设置需要访问的ws和传入参数
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/AgentSetADD?userID=%@&auditEmpID=%@&agentEmpID=%@&startDate=%@&endDate=%@",userID,empID,myDelegate.way_empid,self.businessTripStart.info,self.businessTripEnd.info];
        NSURL *url = [NSURL URLWithString:strURL];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
    }
    else{
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/AgentSetUpdate?userID=%@&auditEmpID=%@&agentEmpID=%@&startDate=%@&endDate=%@&agentSetID=%@",userID,empID,myDelegate.way_empid,self.businessTripStart.info,self.businessTripEnd.info,self.agentID];
        NSURL *url = [NSURL URLWithString:strURL];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
    }
    
}


- (void)submitAction {

        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *userID = [defaults objectForKey:@"userid"];
        NSString *empID = [defaults objectForKey:@"EmpID"];
        AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        //设置需要访问的ws和传入参数
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/AgentSetAPP?userID=%@&auditEmpID=%@&agentEmpID=%@&startDate=%@&endDate=%@&agentSetID=%@",userID,empID,myDelegate.way_empid,self.businessTripStart.info,self.businessTripEnd.info,self.agentID];
        NSURL *url = [NSURL URLWithString:strURL];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (void)goBack {
     [self.navigationController popViewControllerAnimated:YES];
    //    UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
//    [self presentViewController:navigationController animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    [self.view addSubview:toolBar];
    [toolBar  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScreenHeight-TabbarHeight);
        
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, TabbarHeight));
    }];
    UIImage* itemImage= [UIImage imageNamed:@"save.png"];
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * addBtn =[[UIBarButtonItem  alloc]initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(addAction)];
    addBtn.width=kScreenWidth/2;
    itemImage= [UIImage imageNamed:@"enable.png"];
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * submitBtn =[[UIBarButtonItem  alloc]initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(submitAction)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:addBtn,submitBtn, nil];
    submitBtn.width=kScreenWidth/2;
    [toolBar setItems:toolbarItems animated:NO];
}

- (void)textFieldWithText:(UITextField *)textField
{
    [myData replaceObjectAtIndex:textField.tag withObject:textField.text];
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
    if ([self.formTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.formTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.formTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.formTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
