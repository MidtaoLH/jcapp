//
//  ToBeReviewViewController.m
//  jcapp
//
//  Created by lh on 2019/12/15.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AlreadyEndViewController.h"
#import "MJExtension.h"
#import "../Model/Pending.h"
#import "../PendingPage/PendingListCell.h"
#import "../MJRefresh/MJRefresh.h"
#import "TaskBackInfoViewController.h"
static NSString * identifier = @"PendingsListCell";
@interface AlreadyEndViewController ()

@end

@implementation AlreadyEndViewController
@synthesize listOfMovies;

- (void)viewDidLoad {
    [super viewDidLoad]; 
    //e注册自定义 cell
    [_NewTableView registerClass:[PendingListCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight = 150;
    currentPageCount=[Common_PageSize intValue];
    [self LoadData];
    
    // 添加头部的下拉刷新
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.NewTableView.mj_header = header;
    
    // 添加底部的上拉加载
    MJRefreshBackNormalFooter *footer = [[MJRefreshBackNormalFooter alloc] init];
    [footer setRefreshingTarget:self refreshingAction:@selector(footerClick)];
    self.NewTableView.mj_footer = footer;
    _NewTableView.top=-_NewTableView.mj_header.size.height+5;
}

-(void)LoadData
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"username"];
    NSString *userid = [defaults objectForKey:@"userid"];
    NSString *empID = [defaults objectForKey:@"EmpID"];
    //设置需要访问的ws和传入参数
    // code, string userID, string menuID
    NSString *currentPageCountstr = [NSString stringWithFormat: @"%ld", (long)currentPageCount];
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetViewBackList?pasgeIndex=%@&pageSize=%@&code=%@&userID=%@&menuID=%@",@"1",currentPageCountstr,empID,userid,@"8"];
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
    currentPageCount=currentPageCount+[Common_PageSizeAdd intValue]    ;
    [self LoadData];
    // 模拟延迟3秒
    //[NSThread sleepForTimeInterval:3];
    // 结束刷新
    [self.NewTableView.mj_footer endRefreshing];
}


//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 字符串截取
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
    NSRange endRagne = [xmlString rangeOfString:@"</string>"];
    NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
    NSString *resultString = [xmlString substringWithRange:reusltRagne];
    NSString *requestTmp = [NSString stringWithString:resultString];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    listOfMovies = [Pending mj_objectArrayWithKeyValuesArray:resultDic];
    //[self.listOfMovies addObjectsFromArray:self.listMovies];
    [self.NewTableView reloadData];
    [self.NewTableView layoutIfNeeded];
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

}

//解析xml回调方法
- (void)parserDidStartDocument:(NSXMLParser *)parser {
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
    // 默认有此行，请删除或注 释 #warning Incomplete method implementation.
    // 这里是返回节点的行数
    return self.listOfMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PendingListCell * cell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.pendinglistitem =self.listOfMovies[indexPath.row];//取出数据元素
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PendingListCell *cell = (PendingListCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *code= cell.pendinglistitem.PicID;
    TaskBackInfoViewController * VCCollect = [[TaskBackInfoViewController alloc] init];
    VCCollect.code=code;
    [self.navigationController pushViewController:VCCollect animated:YES];
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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self LoadData];
}

@end

