//
//  SetAgentViewController.m
//  jcapp
//
//  Created by lh on 2019/12/23.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AgentInfoViewController.h"
#import "BRPickerView.h"
#import "AgentInfoCell.h"
#import "Masonry.h"
#import "../Model/BRInfoModel.h"
#import "../Model/MessageInfo.h"
#import "../Model/AgentInfo.h"
#import "../ViewController.h"
#import "../VatationPage/AddWayView.h"
#import "SelectUserViewController.h"
#import "AppDelegate.h"
#import "MJExtension.h"

@interface AgentInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>


@end

@implementation AgentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"代理人设置";
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickGoto)];
    [self loadstyle];
    [self loadData];
    [self initUI];
}
-(IBAction)savebtnClick:(id)sender {
    NSLog(@"-----保存数据-----");
    NSLog(@"编号：%@", self.infoModel.codeStr);
    NSLog(@"姓名：%@", self.infoModel.nameStr);
    NSLog(@"开始日期：%@", self.infoModel.startdayStr);
    NSLog(@"结束时间：%@", self.infoModel.enddayStr);
    NSLog(@"部门：%@", self.infoModel.deptStr);
}
- (void)loadData {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"userid"];
    NSString *empID = [defaults objectForKey:@"EmpID"];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
   
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetAgentSet?userID=%@&agentID=%@",userID,self.infoModel.agentID];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
}
- (void)initUI {
    self.tableView.hidden = YES;
}
- (void)clickGoto {
    ViewController *returnVC = [[ViewController alloc]init];
    [self.navigationController pushViewController:returnVC animated:YES];
}
- (void)loadstyle {
    CGFloat tabBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    CGFloat width=self.view.size.width;
    CGFloat height=self.view.size.height;
    NSInteger TxTHeight=[Common_TxTHeight intValue];//文本高度
    NSInteger TableHeight=[Common_TableHeight intValue];//列表高度
    NSInteger RowSize=[Common_RowSize intValue];//行高
    NSInteger ColSize=[Common_ColSize intValue];//列宽
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(0);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(width,TableHeight));
    }];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [_stopbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(ColSize);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+TableHeight+RowSize*2);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(width-ColSize*2,TxTHeight));
    }];
    _stopbtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _stopbtn.font = kFont_Lable_16;
    _stopbtn.titleLabel.textAlignment= NSTextAlignmentCenter;
    _stopbtn.titleLabel.text  = @"终止";
  
}
- (UITextField *)getTextField:(CGRect)frame placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.placeholder = placeholder;
    textField.delegate = self;
    return textField;
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"agentInfoCell";
    AgentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[AgentInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *arr= self.titleArr[indexPath.row];
   
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text= _agentInfo.EmpName;
            cell.infoLabel.text=_agentInfo.DeptName;
            cell.dateLabel.text=_agentInfo.AgentDate;
            cell.statusDateLabel.text=_agentInfo.AgentStatus;
            cell.isTitle = YES;
        }
            break;
        case 1:
        {
            cell.infoLabel.text=_agentInfo.CreateDate;
            cell.dateLabel.text=_agentInfo.AppDate;
            cell.isTitle = NO;
        }
            break;
        
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

#pragma mark - 获取地区数据源
- (NSArray *)getAddressDataSource {
    // 加载地区数据源（实际开发中这里可以写网络请求，从服务端请求数据。可以把 BRCity.json 文件的数据放到服务端去维护，通过接口获取这个数据源数组）
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"BRCity.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *dataSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    return dataSource;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    [self handlerTextFieldSelect:textField];
    return NO; // 当前 textField 不可编辑，可以响应点击事件
}

#pragma mark - 处理点击事件
- (void)handlerTextFieldSelect:(UITextField *)textField {
   
}

#pragma mark - 快捷设置自定义样式 - 适配默认深色模式样式

//#pragma mark - 刷新指定行的数据
//- (void)reloadData:(NSInteger)section row:(NSInteger)row {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"代理人", @"代理人部门"];
        return _titleArr;
    }
    return _titleArr;
}

- (BRInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[BRInfoModel alloc]init];
    }
    return _infoModel;
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
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(IBAction)btnstopClick:(id)sender {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"userid"];
    NSString *empID = [defaults objectForKey:@"EmpID"];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/AgentSetEND?userID=%@&AgentSetAPP=%@",userID,self.infoModel.agentID];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
}
//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 字符串截取
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">["];
    NSRange endRagne = [xmlString rangeOfString:@"]</string>"];
    NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
    NSString *resultString = [xmlString substringWithRange:reusltRagne];
    
    NSLog(@"%@", resultString);
    
    NSString *requestTmp = [NSString stringWithString:resultString];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    if([xmlString containsString:@"msg"])
    {
        MessageInfo *messageInfo = [MessageInfo mj_objectWithKeyValues:resultDic];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"提示信息！"
                              message: messageInfo.msg
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }else
    {
         _agentInfo = [AgentInfo mj_objectWithKeyValues:resultDic];
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];        
        self.tableView.hidden = NO;
    }
    
    
}
@end
