//
//  WayViewController.m
//  jcapp
//
//  Created by zhaodan on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "WayViewController.h"
#import "../Model/Way.h"
#import "../MJExtension/MJExtension.h"
#import "TableCell.h"
#import "AddWayView.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "VatcationMainView.h"
#import "BusinessTripEditViewController.h"
#import "GoOutEditController.h"
#import "../ViewController.h"

static NSString * identifier = @"TableCell";

NSString * saveflag = @"flase";
NSString * suessflag = @"false";
@interface WayViewController ()
{
    UIButton *_progressHUD;
    UIView *_HUDContainer;
    UIActivityIndicatorView *_HUDIndicatorView;
    UILabel *_HUDLable;
}
@end

@implementation WayViewController

NSInteger currentPageCountwait_new;
@synthesize listOfWay;


- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    iosid = [defaults objectForKey:@"adId"];
    
    [self loadstyle];
    [self loadinfo];
   
    self.navigationItem.title=@"路径确认";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
}

-(void)loadstyle{
    [_NewTableView registerClass:[TableCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight = SetAddTableRowSize;
    _NewTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(0);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight-SetTabbarHeight-StatusBarAndNavigationBarHeight));
    }];
}
-(void)loadinfo
{
    currentPageCountwait_new=[Common_PageSize intValue];
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    userID = [defaults objectForKey:@"userid"];
//    empID = [defaults objectForKey:@"EmpID"];
//    iosid = [defaults objectForKey:@"adId"];
    
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    myDelegate.way_refresh =@"false";
    if(listOfWay.count > 0)
    {
        if ([myDelegate.way_post_delete isEqualToString:@"true"]) {
            myDelegate.way_post_delete = @"false";
            int *index = [myDelegate.way_post_index_delete intValue];
            
            // [listOfWay insertObject:m atIndex:index];
            [listOfWay removeObjectAtIndex:index];
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [_NewTableView reloadData];
            }];
            [_NewTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [CATransaction commit];
        }
        else
        {
            if(myDelegate.way_empid.length!=0&&![myDelegate.way_empid isEqualToString:@"0"])
            {
                Way *m = [Way new] ;
                m.levelname = myDelegate.way_post_level;
                m.name = myDelegate.way_empname;
                m.nameid= myDelegate.way_empid;
                m.groupname = myDelegate.way_groupname;
                m.groupid =myDelegate.way_groupid;
                m.englishname =myDelegate.way_empenglishname;
                if([m.levelname isEqualToString:@"一级审批人"])
                {
                    m.level =@"1";
                }
                else if([m.levelname isEqualToString:@"二级审批人"])
                {
                    m.level =@"2";
                }
                else if([m.levelname isEqualToString:@"三级审批人"])
                {
                    m.level =@"3";
                }
                else if([m.levelname isEqualToString:@"四级审批人"])
                {
                    m.level =@"4";
                }
                else if([m.levelname isEqualToString:@"五级审批人"])
                {
                    m.level =@"5";
                }
                else if([m.levelname isEqualToString:@"六级审批人"])
                {
                    m.level =@"6";
                }
                else if([m.levelname isEqualToString:@"七级审批人"])
                {
                    m.level =@"7";
                }
                else if([m.levelname isEqualToString:@"回览人"])
                {
                    m.level =@"99";
                }
                else
                {
                    m.level =@"1";
                }
                m.editflag = @"1";
                int *index = [myDelegate.way_post_index intValue];
                [listOfWay insertObject:m atIndex:index];
                
                [CATransaction begin];
                [CATransaction setCompletionBlock:^{
                    [_NewTableView reloadData];
                }];
                [_NewTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                [CATransaction commit];
                
            }
        }
    }
    else
    {
        saveflag = @"false";
        [self LoadData];
        
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //myDelegate.userPhotoimageView;
    
    if ([myDelegate.way_refresh isEqualToString:@"true"]) {
        
        myDelegate.way_refresh = @"false";
        NSLog(@"执行刷新了");
        
        [self viewDidLoad];
    }
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, kScreenHeight-TabbarHeight, kScreenWidth, SetTabbarHeight)];
    [self.view addSubview:toolBar];
    UIImage* itemImage= [UIImage imageNamed:@"save.png"];
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * addBtn =[[UIBarButtonItem  alloc]initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    addBtn.width=self.view.width;
    NSArray *toolbarItems = [NSArray arrayWithObjects:addBtn, nil];
    [toolBar setItems:toolbarItems animated:NO];
}



-(void)LoadData
{
//    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    NSString *userid = [defaults objectForKey:@"userid"];
//    
    
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetWay?id=%@&processid=%@&iosid=%@&userid=%@",userID,self.processid ,iosid,userID];
    
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
    NSURL *url = [NSURL URLWithString:strURL];
    
    //NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetWay?id=%@&processid=%@", userid,self.processid];
    //myDelegate.processid
    //NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
    
}
//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    @try {
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self hideProgressHUD];
        //判断账号是否总其他设备登录
        if([xmlString containsString: Common_MoreDeviceLoginFlag])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"" message: Common_MoreDeviceLoginErrMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            ViewController * valueView = [[ViewController alloc] initWithNibName:@"ViewController"bundle:[NSBundle mainBundle]];
            //跳转
            [self presentModalViewController:valueView animated:YES];
            return;
        }
        else
        {
            
        // 字符串截取
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
        NSRange endRagne = [xmlString rangeOfString:@"</string>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        
        if([saveflag isEqualToString:@"false"])
        {
            NSString *requestTmp = [NSString stringWithString:resultString];
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            listOfWay = [Way mj_objectArrayWithKeyValuesArray:resultDic];
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [_NewTableView reloadData];
                [_NewTableView layoutIfNeeded];
            }];
            [_NewTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [CATransaction commit];
        }
        else
        {
            if([resultString isEqualToString:@"suess"])
            {
                suessflag = @"true";
                //显示信息。正式环境时改为跳转
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @""
                                      message: @"保存成功"
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                
                
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @""
                                      message: resultString
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        }
    }
    @catch (NSException *exception) {
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([suessflag isEqualToString:@"true"])
    {
        [self.navigationController popViewControllerAnimated:YES];
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
}

//解析返回xml的节点elementName
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
    //NSLog(@"%@", @"jiedian1");    //设置标记查看解析到哪个节点
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


//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 默认有些行，请删除或注 释 #warning Potentially incomplete method implementation.
    // 这里是返回的节点数，如果是简单的一组数据，此处返回1，如果有多个节点，就返回节点 数
    return 1;
}

//如果不设置section 默认就1组
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     
    return self.listOfWay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 大家还记得，之前让你们设置的Cell Identifier 的 值，一定要与前面设置的值一样，不然数据会显示不出来
    TableCell * cell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.index =    [NSString stringWithFormat:@"%d",indexPath.row];
    if(self.listOfWay.count>indexPath.row+1)
    {
        Way * w =self.listOfWay[indexPath.row+1];
        cell.nextlevel=w.level;
        cell.netxtype=w.name;
    }
    else
    {
        cell.nextlevel=@"100";
        cell.netxtype=@"100";
    }
    if(indexPath.row>=1)
    {
         Way * w =self.listOfWay[indexPath.row-1];
         cell.toptype=w.name;
    }
    else
    {
        cell.toptype=@"null";
    }
    cell.Waylist =self.listOfWay[indexPath.row];//取出数据元素    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Way *w =self.listOfWay[indexPath.row];
    if([w.name isEqualToString:@"button"]||[ w.name isEqualToString:@"null"])
    {
        return SetAddButtonRowSize;
    }
    else
    {
        return SetAddTableRowSize;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)save{
    saveflag = @"true";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *userid = [defaults objectForKey:@"userid"];
    
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    // Model array -> JSON array
    NSArray *dictArray = [Way mj_keyValuesArrayWithObjectArray:listOfWay];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [NSString stringWithFormat:@"%@",jsonString];
    
    //////////////////////////////////
    NSString *post = [NSString stringWithFormat:@"strjson=%@&userid=%@&processid=%@&iosid=%@",
                      jsonString,userid,_processid];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
//    NSURL *webServiceURL = [NSURL URLWithString:@"http://47.94.85.101:8095/AppWebService.asmx/InsertProcessChange?"];
    NSURL *webServiceURL = [NSURL URLWithString:[NSString stringWithFormat:Common_WSUrl,@"InsertProcessChange?"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webServiceURL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
    if (!connection) {
        NSLog(@"Failed to submit request");
    } else {
        NSLog(@"Request submitted");
    }
     [self showProgressHUD];
}


- (void)cellAddBtnClicked:(id)sender event:(id)event
{
    
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
    if ([_NewTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_NewTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_NewTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_NewTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)showProgressHUD {
    if (!_progressHUD) {
        _progressHUD = [UIButton buttonWithType:UIButtonTypeCustom];
        [_progressHUD setBackgroundColor:[UIColor clearColor]];
        
        _HUDContainer = [[UIView alloc] init];
        _HUDContainer.frame = CGRectMake(150, 300, 100,100 );
        _HUDContainer.layer.cornerRadius = 8;
        _HUDContainer.clipsToBounds = YES;
        _HUDContainer.backgroundColor = [UIColor darkGrayColor];
        _HUDContainer.alpha = 0.7;
        
        _HUDIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _HUDIndicatorView.frame = CGRectMake(45, 15, 30, 30);
        
        _HUDLable = [[UILabel alloc] init];
        _HUDLable.frame = CGRectMake(0,40, 100, 50);
        _HUDLable.textAlignment = NSTextAlignmentCenter;
        _HUDLable.text = @"正在处理...";
        _HUDLable.font = [UIFont systemFontOfSize:15];
        _HUDLable.textColor = [UIColor whiteColor];
        
        [_HUDContainer addSubview:_HUDLable];
        [_HUDContainer addSubview:_HUDIndicatorView];
        [_progressHUD addSubview:_HUDContainer];
    }
    [_HUDIndicatorView startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:_progressHUD];
}

- (void)hideProgressHUD {
    if (_progressHUD) {
        [_HUDIndicatorView stopAnimating];
        [_progressHUD removeFromSuperview];
    }
}
@end
