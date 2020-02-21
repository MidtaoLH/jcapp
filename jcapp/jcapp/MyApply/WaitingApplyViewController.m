//
//  LeaveViewController.m
//  jcapp
//
//  Created by zclmac on 2019/11/29.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "WaitingApplyViewController.h"
#import "MJExtension.h"
#import "../Model/Pending.h"
#import "../PendingPage/PendingListCell.h"
//#import "ApplyListCell.h"
#import "../MJRefresh/MJRefresh.h"
#import "../VatationPage/VatcationMainViewController.h"
#import "../VatationPage/VatcationMainView.h"
#import "../BusinessTrip/BusinessTripEditViewController.h"
#import "../GoOut/GoOutEditController.h"
#import "../AppDelegate.h"
#import "../TabBar/TabBarViewController.h"
#import "../ViewController.h"

static NSString * identifier = @"PendingListCell";

@interface WaitingApplyViewController (){
    MJRefreshBackNormalFooter *footer;
}
@end

@implementation WaitingApplyViewController
NSInteger currentPageCountwait;
@synthesize listOfMovies;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置顶部导航栏的显示名称
//    self.navigationItem.title=@"待申请记录";
//    //设置子视图的f导航栏的返回按钮
//    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
//    temporaryBarButtonItem.title =@"返回";
//    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    //self.parentViewController.navigationItem.backBarButtonItem=temporaryBarButtonItem;
    //e注册自定义 cell
    [_NewTableView registerClass:[PendingListCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight =kScreenHeight/5;
    currentPageCountwait=[Common_PageSize intValue];
    _NewTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    iosid=[defaults objectForKey:@"adId"];
    [self LoadData];
    
    // 添加头部的下拉刷新
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.NewTableView.mj_header = header;

    // 添加底部的上拉加载
    footer = [[MJRefreshBackNormalFooter alloc] init];
    [footer setRefreshingTarget:self refreshingAction:@selector(footerClick)];
    self.NewTableView.mj_footer = footer;
    
    //_NewTableView.top=-_NewTableView.mj_header.size.height+5;
}

-(void)LoadData
{
    //设置需要访问的ws和传入参数
    // code, string userID, string menuID
    //设置需要访问的ws和传入参数
    NSString *currentPageCountstr = [NSString stringWithFormat: @"%ld", (long)currentPageCountwait];
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetPendingInfo?pasgeIndex=%@&pageSize=%@&code=%@&userID=%@&menuID=%@&iosid=%@",@"1",currentPageCountstr,empID,userID,@"2",iosid];
    
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
}

// 2.实现下拉刷新和上拉加载的事件。
// 头部的下拉刷新触发事件
- (void)headerClick {
    // 可在此处实现下拉刷新时要执行的代码
    // ......
    //if(currentPageCount>1)
    //currentPageCount--;
    [self LoadData];
    // 模拟延迟3秒
    //[NSThread sleepForTimeInterval:3];
    // 结束刷新
    [self.NewTableView.mj_header endRefreshing];
}
// 底部的上拉加载触发事件
- (void)footerClick {
    // 可在此处实现上拉加载时要执行的代码
    // ......
    currentPageCountwait=currentPageCountwait+[Common_PageSizeAdd intValue];
    [self LoadData];
    // 模拟延迟3秒
    //[NSThread sleepForTimeInterval:3];
    // 结束刷新
    [self.NewTableView.mj_footer endRefreshing];
}


//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    @try {
        NSLog(@"%@",@"connection1-begin");
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //判断账号是否总其他设备登录
        if([xmlString containsString: Common_MoreDeviceLoginFlag])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"" message: Common_MoreDeviceLoginErrMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            ViewController * valueView = [[ViewController alloc] initWithNibName:@"ViewController"bundle:[NSBundle mainBundle]];
            //跳转
            [self presentModalViewController:valueView animated:YES];
            return;
        }
        
        if([xmlString containsString:@"DelteProcessInstance"])
        {
            UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
              navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:navigationController animated:YES completion:nil];
        }
        else{
            // 字符串截取
            NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
            NSRange endRagne = [xmlString rangeOfString:@"</string>"];
            NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
            NSString *resultString = [xmlString substringWithRange:reusltRagne];
            
            NSLog(@"%@", resultString);
            
            NSString *requestTmp = [NSString stringWithString:resultString];
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            if([Pending mj_objectArrayWithKeyValuesArray:resultDic].count==listOfMovies.count){
                // 设置状态
                [footer setState:MJRefreshStateNoMoreData];
            }            listOfMovies = [Pending mj_objectArrayWithKeyValuesArray:resultDic];
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [_NewTableView reloadData];
            }];
            [_NewTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [CATransaction commit];
        }
        
    }
    @catch (NSException *exception) {
        NSArray *arr = [exception callStackSymbols];
        NSString *reason = [exception reason];
        NSString *name = [exception name];
        NSLog(@"err:\n%@\n%@\n%@",arr,reason,name);
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
    
    NSLog(@"%@", @"kaishijiex");    //开始解析XML
    
    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    ipParser.delegate = self;
    [ipParser parse];
    NSLog(@"%@",@"connectionDidFinishLoading-end");
}

//解析xml回调方法
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    info = [[NSMutableDictionary alloc] initWithCapacity: 1];
    
    NSLog(@"%@",@"parserDidStartDocument-end");
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
    NSLog(@"%@",@"parser-end");
}

//解析返回xml的节点elementName
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
    NSLog(@"value2: %@\n", elementName);
    //NSLog(@"%@", @"jiedian1");    //设置标记查看解析到哪个节点
    currentTagName = elementName;
    
    NSLog(@"%@",@"parser2-end");
}

//取得我们需要的节点的数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSLog(@"%@",@"parser3-begin");
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
}

//循环解析d节点
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    NSLog(@"%@",@"parserDidEndDocument-begin");
    
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
    NSLog(@"%@",@"numberOfSectionsInTableView-begin");
    // 默认有些行，请删除或注 释 #warning Potentially incomplete method implementation.
    // 这里是返回的节点数，如果是简单的一组数据，此处返回1，如果有多个节点，就返回节点 数
    return 1;
}

//如果不设置section 默认就1组
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 默认有此行，请删除或注 释 #warning Incomplete method implementation.
    // 这里是返回节点的行数
    NSLog(@"%@",@"tableView-begin");
    return self.listOfMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 大家还记得，之前让你们设置的Cell Identifier 的 值，一定要与前面设置的值一样，不然数据会显示不出来
     PendingListCell * cell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.pendinglistitem =self.listOfMovies[indexPath.row];//取出数据元素

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Pending * pending = self.listOfMovies[indexPath.row];
    NSLog(@"pending.PicID:%@",pending.DocumentName);
    //根据不同类型的单据跳转到不同的画面
    if([pending.DocumentName isEqualToString:@"请假"]){
        AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        //app.leaveid
        VatcationMainView *order = [[VatcationMainView alloc] init];
        order.vatcationid=pending.AidFK;
        order.processInstanceID=pending.PicID;
        order.edittype = @"2";
        order.urltype =@"getdata";
        [self.navigationController pushViewController:order animated:YES];
    }
    else if([pending.DocumentName isEqualToString:@"出差"]){
        AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        myDelegate.businessTripid=pending.AidFK;
        myDelegate.processid=pending.PicID;
        myDelegate.pageType=@"2";
        BusinessTripEditViewController *order = [[BusinessTripEditViewController alloc] init];
        [self.navigationController pushViewController:order animated:YES];
    }
    else if([pending.DocumentName isEqualToString:@"外出"]){
        GoOutEditController *order = [[GoOutEditController alloc] init];
        order.evectionID=pending.AidFK;
        order.processInstanceID=pending.PicID;
        order.edittype = @"2";
        order.urltype=@"getdata";
        [self.navigationController pushViewController:order animated:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!animated) {
        [self LoadData];
    }
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
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 初始化对话框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除？" preferredStyle:UIAlertControllerStyleAlert];
        // 确定注销
        _okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            Pending * pending = self.listOfMovies[indexPath.row];
            [self deleteData:pending.PicID];
        }];
        _cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:_okAction];
        [alert addAction:_cancelAction];
        // 弹出对话框
        [self presentViewController:alert animated:true completion:nil];
        
    }];
    //    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    return @[deleteRowAction];
}
- (void)deleteData:(NSString*)deleteID
{
    //设置需要访问的ws和传入参数
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/DelteProcessInstance?userID=%@&processInstanceID=%@&iosid=%@",userID,deleteID,iosid];
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
    
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
}
@end
