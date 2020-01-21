//
//  WaitHandleViewController.m
//  jcapp
//
//  Created by youkare on 2019/12/2.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "WaitHandleViewController.h"
#import "MJExtension.h"
#import "../Model/Pending.h"
#import "../PendingPage/PendingListCell.h"
#import "../MJRefresh/MJRefresh.h"
#import "../Leave/LeaveDetailController.h"
#import "../AppDelegate.h"
#import "../BusinessTrip/BusinessTripDetailViewController.h"
#import "../GoOut/GoOutDeatileController.h"
#import "../ViewController.h"

static NSString * identifier = @"PendingListCell";

@interface WaitHandleViewController (){
    MJRefreshBackNormalFooter *footer;
}

@end

@implementation WaitHandleViewController
NSInteger currentPageCountwait3;
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
    currentPageCountwait3=[Common_PageSize intValue];
    _NewTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    iosid = [defaults objectForKey:@"adId"];
    

    
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
    NSString *currentPageCountstr = [NSString stringWithFormat: @"%ld", (long)currentPageCountwait3];
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetPendingInfo?pasgeIndex=%@&pageSize=%@&code=%@&userID=%@&menuID=%@&iosid=%@",@"1",currentPageCountstr,empID,userID,@"33",iosid];
    
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
    currentPageCountwait3=currentPageCountwait3+[Common_PageSizeAdd intValue];
    [self LoadData];
    // 模拟延迟3秒
    //[NSThread sleepForTimeInterval:3];
    // 结束刷新
    [self.NewTableView.mj_footer endRefreshing];
}


//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    @try {
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
        
        // 字符串截取
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
        NSRange endRagne = [xmlString rangeOfString:@"</string>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        if([Pending mj_objectArrayWithKeyValuesArray:resultDic].count==listOfMovies.count){
            // 设置状态
            [footer setState:MJRefreshStateNoMoreData];
        }
        listOfMovies = [Pending mj_objectArrayWithKeyValuesArray:resultDic];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [_NewTableView reloadData];
        }];
        [_NewTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [CATransaction commit];
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


//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//如果不设置section 默认就1组
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 默认有此行，请删除或注 释 #warning Incomplete method implementation.
    // 这里是返回节点的行数
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
    //根据不同类型的单据跳转到不同的画面
    if([pending.DocumentName isEqualToString:@"请假"]){
        LeaveDetailController *order = [[LeaveDetailController alloc] init];
        order.awardID_FK=pending.AidFK;
        order.processInstanceID=pending.PicID;
        order.title=@"请假申请";
        [self.navigationController pushViewController:order animated:YES];
    }
    else if([pending.DocumentName isEqualToString:@"出差"]){
        BusinessTripDetailViewController *order = [[BusinessTripDetailViewController alloc] init];
        order.processInstanceID=pending.PicID;
        order.awardID_FK=pending.AidFK;
        order.title=@"出差申请";
        [self.navigationController pushViewController:order animated:YES];
    }
    else if([pending.DocumentName isEqualToString:@"外出"]){
        GoOutDeatileController *order = [[GoOutDeatileController alloc] init];
        order.awardID_FK=pending.AidFK;
        order.processInstanceID=pending.PicID;
         order.title=@"外出申请";
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
@end

