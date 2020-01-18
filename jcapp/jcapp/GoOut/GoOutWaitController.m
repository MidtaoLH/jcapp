//
//  GoOutWaitController.m
//  jcapp
//
//  Created by zclmac on 2019/12/17.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "GoOutWaitController.h"
#import "MJExtension.h"
#import "../Model/MdlGoOutList.h"
#import "GoOutWaitCell.h"
#import "GoOutEditController.h"
#import "../MJRefresh/MJRefresh.h"
#import "GoOutDeatileController.h"
#import "../TabBar/TabBarViewController.h"
@interface GoOutWaitController ()

@end

@implementation GoOutWaitController

static NSString *identifier =@"GoOutWaitCell";

@synthesize listDatas;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    CGFloat headimageW = self.view.frame.size.width;
    CGFloat headimageH =  self.view.frame.size.height;
    self.NewTableView.frame = CGRectMake(0, 0, headimageW, headimageH);
    
    //e注册自定义 cell
    [_NewTableView registerClass:[GoOutWaitCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight =kScreenHeight/5;
    _NewTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    //_NewTableView.top=-_NewTableView.mj_header.size.height+5;
    
    NSLog(@"%@",@"viewDidLoad-end");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self LoadData];
}

// 2.实现下拉刷新和上拉加载的事件。
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
-(void)LoadData
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    empname = [defaults objectForKey:@"empname"];
    groupid = [defaults objectForKey:@"Groupid"];
    UserHour = [defaults objectForKey:@"UserHour"];
 
    //设置需要访问的ws和传入参数
    // code, string userID, string menuID
    NSString *currentPageCountstr = [NSString stringWithFormat: @"%ld", (long)currentPageCount];
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetGoOutListData?pasgeIndex=%@&pageSize=%@&userID=%@&GroupID_FK=%@&CaseName=%@&ApplyGroupID_FK=%@&EmpCName=%@&ProcessStutas=%@", @"1",currentPageCountstr,userID,groupid,@"",groupid,@"",@"0"];
    
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
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
    
    if([xmlString containsString:@"DelteProcessInstance"])
    {
        UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else{
        // 字符串截取
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
                              NSRange endRagne = [xmlString rangeOfString:@"</string>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        listDatas = [MdlGoOutList mj_objectArrayWithKeyValuesArray:resultDic];
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
    
    [self.NewTableView reloadData];
    [self.NewTableView layoutIfNeeded];
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
    NSLog(@"%d",self.listDatas.count);
    return self.listDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSLog(@"%@",@"tableViewUITableViewCellbegin");
    GoOutWaitCell * cell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
 
    cell.MdlGoOutListItem =self.listDatas[indexPath.row];//取出数据元素
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoOutWaitCell *cell = (GoOutWaitCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *code= cell.MdlGoOutListItem.AwardID_FK;
    NSString *taskcode= cell.MdlGoOutListItem.ProcessInstanceID;
 
    //待申请任务 进入明细编辑画面为修改操作
    GoOutEditController * VCCollect = [[GoOutEditController alloc] init];
    VCCollect.evectionID=code;
    VCCollect.processInstanceID=taskcode;
    VCCollect.ProcessApplyCode=cell.MdlGoOutListItem.ProcessApplyCode;
    VCCollect.edittype = @"2"; //编辑
    VCCollect.urltype = @"getdata";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // presentedVC 为被弹出的控制器
        VCCollect.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    } else {
        // rootVC 为window的rootViewController
        VCCollect.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [self.navigationController pushViewController:VCCollect animated:YES];
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
            MdlGoOutList * pending = self.listDatas[indexPath.row];
            [self deleteData:pending.ProcessInstanceID];
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
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *userid= [defaults objectForKey:@"userid"];
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/DelteProcessInstance?userID=%@&processInstanceID=%@",userid,deleteID];
    
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
}
@end
