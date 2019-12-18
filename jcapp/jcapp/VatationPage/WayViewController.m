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
#import "../MJRefresh/MJRefresh.h"
#import "AddWayView.h"
#import "AppDelegate.h"


static NSString * identifier = @"TableCell";

NSString * saveflag = @"flase";
@interface WayViewController ()

@end

@implementation WayViewController

NSInteger currentPageCountwait_new;
@synthesize listOfWay;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    //e注册自定义 cell
    [_NewTableView registerClass:[TableCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight = 150;
    currentPageCountwait_new=[Common_PageSize intValue];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    
     AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.way_refresh =@"false";
    if(listOfWay.count > 0)
    {
        if ([myDelegate.way_post_delete isEqualToString:@"true"]) {
            myDelegate.way_post_delete = @"false";
            int *index = [myDelegate.way_post_index_delete intValue];
            
           // [listOfWay insertObject:m atIndex:index];
            [listOfWay removeObjectAtIndex:index];
            
            NSLog(@"%@", @"添加成功");
            
            self.NewTableView.reloadData;
        }
        else
        {
            //myDelegate.userPhotoimageView;
            
            Way *m = [Way new] ;
            
            m.levelname = myDelegate.way_post_level;
            m.name = myDelegate.way_empname;
            m.nameid= myDelegate.way_empid;
            m.groupname = myDelegate.way_groupname;
            m.groupid =myDelegate.way_groupid;
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
            NSLog(@"%@", @"添加成功");
            
            self.NewTableView.reloadData;
        }
       
        
    }
    else
    {
        saveflag = @"false";
        [self LoadData];
        // 添加头部的下拉刷新
        MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
        [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
        self.NewTableView.mj_header = header;
        
        // 添加底部的上拉加载
        MJRefreshBackNormalFooter *footer = [[MJRefreshBackNormalFooter alloc] init];
        [footer setRefreshingTarget:self refreshingAction:@selector(footerClick)];
        self.NewTableView.mj_footer = footer;
        
        _NewTableView.top=-_NewTableView.mj_header.size.height+100;
    }
    
    
    NSLog(@"%@", @"刷新成功");
   
}



- (void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    //myDelegate.userPhotoimageView;
    
    if ([myDelegate.way_refresh isEqualToString:@"true"]) {
        
        NSLog(@"执行刷新了");
        
        [self viewDidLoad];
    }
    
}



-(void)LoadData
{
    //设置需要访问的ws和传入参数
    // code, string userID, string menuID
    //设置需要访问的ws和传入参数
    //NSString *currentPageCountstr = [NSString stringWithFormat: @"%ld", (long)currentPageCountwait];
    //NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetPendingInfo?pasgeIndex=%@&pageSize=%@&code=%@&userID=%@&menuID=%@",@"1",currentPageCountstr,userID,empID,@"2"];
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *userid = [defaults objectForKey:@"userid"];
    
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetWay?id=%@&processid=%@", userid,@"22755"];
    //myDelegate.processid
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
    currentPageCountwait_new=currentPageCountwait_new+[Common_PageSizeAdd intValue];
    [self LoadData];
    // 模拟延迟3秒
    //[NSThread sleepForTimeInterval:3];
    // 结束刷新
    [self.NewTableView.mj_footer endRefreshing];
}


//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%@",@"connection1-begin");
    
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", @"34443333kaishidayin");
    NSLog(@"%@", xmlString);
    
    // 字符串截取
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
    NSRange endRagne = [xmlString rangeOfString:@"</string>"];
    NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
    NSString *resultString = [xmlString substringWithRange:reusltRagne];
    
    NSLog(@"%@", resultString);
    
    if([saveflag isEqualToString:@"false"])
    {
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        listOfWay = [Way mj_objectArrayWithKeyValuesArray:resultDic];
    }
    else
    {
        if([resultString isEqualToString:@"suess"])
        {
           
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"保存结果"
                                  message: @"保存成功"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"保存结果"
                                  message: resultString
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    
    
    NSLog(@"%@",@"connection1-end");
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
    NSLog(@"%@",@"connection2-end");
}

//解析返回的xml系统自带方法不需要h中声明
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    
    NSLog(@"%@", @"kaishijiex");    //开始解析XML
    
    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    ipParser.delegate = self;
    [ipParser parse];
    NSLog(@"%@",@"connectionDidFinishLoading-end");
    
    [self.NewTableView reloadData];
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
    
    return self.listOfWay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 大家还记得，之前让你们设置的Cell Identifier 的 值，一定要与前面设置的值一样，不然数据会显示不出来
    TableCell * cell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSLog(@"%@",@"测试setway");
    
    cell.Waylist =self.listOfWay[indexPath.row];//取出数据元素
    NSLog(@"%@",@"测试setindex");
   
    cell.index =    [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSLog(@"%@",@"电视机删除");
}




-(IBAction)onClickButtonsave:(id)sender {
    
    NSLog(@"%@",@"测试josn发宋");
    saveflag = @"true";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *userid = [defaults objectForKey:@"userid"];
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    // Model array -> JSON array
    NSArray *dictArray = [Way mj_keyValuesArrayWithObjectArray:listOfWay];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonString);
    
    jsonString = [NSString stringWithFormat:@"%@",jsonString];
    
    //////////////////////////////////
    NSString *post = [NSString stringWithFormat:@"strjson=%@&userid=%@&processid=%@",
                      jsonString,userid,@"22755"];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *webServiceURL = [NSURL URLWithString:@"http://47.94.85.101:8095/AppWebService.asmx/InsertProcessChange?"];
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
    
    
    
    
    /////////////////////////////////////////

    
    
    /*
     NSData *data = [NSJSONSerialization dataWithJSONObject:listOfWay options:NSJSONWritingPrettyPrinted error:nil];
     
     NSString *tempStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
     
     NSLog(@"－－－－－－－－%@",tempStr);
     
     
     
     NSDictionary *params3 = [NSDictionary dictionaryWithObjectsAndKeys:
     listOfWay, @"json",
     nil];
     
     
     convert object to data
     NSData* jsonData =[NSJSONSerialization dataWithJSONObject:params3
     options:NSJSONWritingPrettyPrinted error:nil];
     
     //print out the data contents
     NSString* text =[[NSString alloc] initWithData:jsonData
     encoding:NSUTF8StringEncoding];
     
     
     //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:listOfWay options:0 error:nil];
     
     //NSLog(@"%@",@"测试josn发宋转data");
     
     //NSString *strJson = [[NSString alloc] initWithData:listOfWay encoding:NSUTF8StringEncoding];
     
     //NSLog(@"%@",@"测试josn发宋转json");
     */
    
    
   
}


- (void)cellAddBtnClicked:(id)sender event:(id)event
{
    
   NSLog(@"%@",@"dianjishanchu");
    
}

@end
