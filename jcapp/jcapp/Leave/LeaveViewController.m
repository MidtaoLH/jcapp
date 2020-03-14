//
//  LeaveViewController.m
//  jcapp
//
//  Created by zclmac on 2019/11/29.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "LeaveViewController.h"
#import "MJExtension.h"
#import "../Model/LeaveListModel.h"
#import "LeaveListCell.h"
#import "../TaskViewBack/TaskBackInfoViewController.h"
#import "../MJRefresh/MJRefresh.h"
#import "LeaveDetailController.h"
 #import "ViewController.h"

static NSString * identifier = @"LeaveListCell";

@interface LeaveViewController (){
    UIButton *_progressHUD;
      UIView *_HUDContainer;
      UIActivityIndicatorView *_HUDIndicatorView;
      UILabel *_HUDLable;
    MJRefreshBackNormalFooter *footer;
}

@end

@implementation LeaveViewController

@synthesize listOfMovies;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    CGFloat headimageW = self.view.frame.size.width;
    CGFloat headimageH =  self.view.frame.size.height;
    self.NewTableView.frame = CGRectMake(0, 0, headimageW, headimageH);
    
    //e注册自定义 cell
    [_NewTableView registerClass:[LeaveListCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight =kScreenHeight/5;
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
    
    NSLog(@"%@",@"viewDidLoad-end");
}
// 2.实现下拉刷新和上拉加载的事件。
// 头部的下拉刷新触发事件
- (void)headerClick {
    // 可在此处实现下拉刷新时要执行的代码
    // ......
    //if(currentPageCount>1)
    //currentPageCount--;
    currentPageCount=5;
         listOfMovies=nil;
      [self LoadData];
       [NSThread sleepForTimeInterval:0.5];
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
   [NSThread sleepForTimeInterval:0.5];
    // 结束刷新
    [self.NewTableView.mj_footer endRefreshing];
}
-(void)LoadData
{
    
     [self showProgressHUD];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    empname = [defaults objectForKey:@"empname"];
    groupid = [defaults objectForKey:@"Groupid"];
    UserHour = [defaults objectForKey:@"UserHour"];

    iosid = [defaults objectForKey:@"adId"];
    //设置需要访问的ws和传入参数
    // code, string userID, string menuID
    NSString *currentPageCountstr = [NSString stringWithFormat: @"%ld", (long)currentPageCount];
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetLeaveListData?pasgeIndex=%@&pageSize=%@&userID=%@&GroupID_FK=%@&CaseName=%@&ApplyGroupID_FK=%@&EmpCName=%@&ProcessStutas=%@&iosid=%@", @"1",currentPageCountstr,userID,groupid,@"",@"2",@"",@"1",iosid];
    
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
    @try {
           [self hideProgressHUD];
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if([xmlString containsString: Common_MoreDeviceLoginFlag])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"" message: Common_MoreDeviceLoginErrMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            ViewController * valueView = [[ViewController alloc] initWithNibName:@"ViewController"bundle:[NSBundle mainBundle]];
            //跳转
            [self presentModalViewController:valueView animated:YES];
        }
        else
        {
            NSLog(@"%@", @"kaishidayin");
            NSLog(@"%@", xmlString);
            
            // 字符串截取
            NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
            NSRange endRagne = [xmlString rangeOfString:@"</string>"];
            NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
            NSString *resultString = [xmlString substringWithRange:reusltRagne];
            
            NSLog(@"%@", resultString);
            
            NSString *requestTmp = [NSString stringWithString:resultString];
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            if([LeaveListModel mj_objectArrayWithKeyValuesArray:resultDic].count==listOfMovies.count){
                // 设置状态
                [footer setState:MJRefreshStateNoMoreData];
            }
            else{
                                                         [self.NewTableView.mj_footer resetNoMoreData];
                                                      }
            listOfMovies = [LeaveListModel mj_objectArrayWithKeyValuesArray:resultDic];
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [_NewTableView reloadData];
            }];
            [_NewTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [CATransaction commit];
            NSLog(@"%@",@"connection1-end");
        }
        
      
        
    }
    @catch (NSException *exception) {
        NSArray *arr = [exception callStackSymbols];
        NSString *reason = [exception reason];
        NSString *name = [exception name];
        NSLog(@"\n%@\n%@\n%@",arr,reason,name);
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
    LeaveListCell * cell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.leavelistitem =self.listOfMovies[indexPath.row];//取出数据元素
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaveListCell *cell = (LeaveListCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *code= cell.leavelistitem.AwardID_FK;
    NSString *taskcode= cell.leavelistitem.ProcessInstanceID;
    
    if([cell.leavelistitem.ProcessStutasName isEqualToString:@"待承认"] || [cell.leavelistitem.ProcessStutasName isEqualToString:@"承认中"] || [cell.leavelistitem.ProcessStutasName isEqualToString:@"已驳回"])
    {
        LeaveDetailController * VCCollect = [[LeaveDetailController alloc] init];
        VCCollect.awardID_FK=code;
        VCCollect.processInstanceID=taskcode;
        VCCollect.ProcessApplyCode=cell.leavelistitem.ProcessApplyCode;
        VCCollect.title=@"请假申请";
        [self.navigationController pushViewController:VCCollect animated:YES];
    }
    else
    {
        TaskBackInfoViewController *order = [[TaskBackInfoViewController alloc] init];
        order.pagetype=@"1";
        order.code=taskcode;
        order.title=@"请假";
        [self.navigationController pushViewController:order animated:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
      [self LoadData];
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
