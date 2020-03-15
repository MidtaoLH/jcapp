//
//  PendingApprovedViewController.m
//  jcapp
//
//  Created by lh on 2019/12/4.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "PendingApprovedViewController.h"
#import "MJExtension.h"
#import "../Model/Pending.h"
#import "PendingListCell.h"
#import "../MJRefresh/MJRefresh.h"
#import "../TaskViewBack/TaskBackInfoViewController.h"
#import "../ViewController.h"

static NSString * identifier = @"PendingListCell";
@interface PendingApprovedViewController (){
    UIButton *_progressHUD;
           UIView *_HUDContainer;
           UIActivityIndicatorView *_HUDIndicatorView;
           UILabel *_HUDLable;
    MJRefreshBackNormalFooter *footer;
}

@end

@implementation PendingApprovedViewController
@synthesize listOfMovies;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    user = [defaults objectForKey:@"username"];
    userid = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    iosid = [defaults objectForKey:@"adId"];
    
    //e注册自定义 cell
    [_NewTableView registerClass:[PendingListCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight = kScreenHeight/5;
    currentPageCount=[Common_PageSize intValue];
   _NewTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
      [self showProgressHUD];
    //设置需要访问的ws和传入参数
    // code, string userID, string menuID
    NSString *currentPageCountstr = [NSString stringWithFormat: @"%ld", (long)currentPageCount];
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetPendingInfo?pasgeIndex=%@&pageSize=%@&code=%@&userID=%@&menuID=%@&iosid=%@",@"1",currentPageCountstr,empID,userid,@"6",iosid];
    
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
       currentPageCount=5;
       listOfMovies=nil;
       [self LoadData];
       // 模拟延迟3秒
       [NSThread sleepForTimeInterval:0.5];
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
    [NSThread sleepForTimeInterval:0.5];
    // 结束刷新
    [self.NewTableView.mj_footer endRefreshing];
}


//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    @try {
         [self hideProgressHUD];
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
               else{
                  [self.NewTableView.mj_footer resetNoMoreData];
               }
        listOfMovies = [Pending mj_objectArrayWithKeyValuesArray:resultDic];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [_NewTableView reloadData];
        }];
        [_NewTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [CATransaction commit];
        //[self.listOfMovies addObjectsFromArray:self.listMovies];
        
        
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
    Pending * pending = self.listOfMovies[indexPath.row];
    NSLog(@"pending.PicID:%@",pending.DocumentName);
    //根据不同类型的单据跳转到不同的画面
    if([pending.DocumentName isEqualToString:@"请假"]){
        TaskBackInfoViewController *order = [[TaskBackInfoViewController alloc] init];
        order.pagetype=@"1";
        order.code=pending.PicID;
        order.title=@"请假申请";
        [self.navigationController pushViewController:order animated:YES];
    }
    else if([pending.DocumentName isEqualToString:@"出差"]){
        TaskBackInfoViewController *order = [[TaskBackInfoViewController alloc] init];
        order.pagetype=@"1";
        order.code=pending.PicID;
        order.title=@"出差申请";
        [self.navigationController pushViewController:order animated:YES];
    }
    else if([pending.DocumentName isEqualToString:@"外出"]){
        TaskBackInfoViewController *order = [[TaskBackInfoViewController alloc] init];
        order.pagetype=@"1";
        order.code=pending.PicID;
        order.title=@"外出申请";
        [self.navigationController pushViewController:order animated:YES];
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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!animated) {
        [self LoadData];
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
