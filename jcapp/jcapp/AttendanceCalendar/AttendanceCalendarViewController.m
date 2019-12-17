//
//  AttendanceCalendarViewController.m
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AttendanceCalendarViewController.h"
#import "AttendanceTabBarViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "../Model/AttendanceCalendar.h"

#import "AttendanceListCell.h"
NSString * identifierac= @"AttendanceListCell";
@interface AttendanceCalendarViewController ()
@end

@implementation AttendanceCalendarViewController
@synthesize listOfMovies;
@synthesize listOfMoviesDetail;

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子视图的f导航栏的返回按钮
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self loadinfo];
    
    CGFloat tabBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height+20;
    CGFloat headimageW = self.view.frame.size.width * 0.25;
    CGFloat headimageH = headimageW;
    self.myHeadPortrait.frame = CGRectMake(20, tabBarHeight*0.9, headimageW, headimageH);
    //这句必须写
    self.myHeadPortrait.layer.cornerRadius = headimageW * 0.5;
    
    self.lblname.frame=CGRectMake(self.myHeadPortrait.width+40, tabBarHeight-self.myHeadPortrait.height/6, headimageW, headimageH);
    self.lbldept.frame=CGRectMake(self.myHeadPortrait.width+40, tabBarHeight+self.myHeadPortrait.height/5, headimageW, headimageH);
   
    headimageW = self.view.frame.size.width;
    headimageH =  self.view.frame.size.height;
    self.NewTableView.frame = CGRectMake(0, self.myHeadPortrait.height+tabBarHeight+self.calview.height, headimageW, 300);
    
    //e注册自定义 cell
    [_NewTableView registerClass:[AttendanceListCell class] forCellReuseIdentifier:identifierac];
    _NewTableView.rowHeight = 100;
    self.calview.onDateSelectBlk=^(NSDate* date){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [format stringFromDate:date];
        [self loadacdinfo:dateString];
    };
    self.calview.tagStringOfDate=^NSString*(NSArray* calm,NSArray* itemDateArray){
        NSString *datestr = [NSString stringWithFormat:@"%@-%@-%@",itemDateArray[0],itemDateArray[1],itemDateArray[2]];
        NSString *msg=nil;
        for (AttendanceCalendar *perName in listOfMovies) {
            if ([perName.AttendanceCalendarTime isEqualToString:datestr])
            {
                msg=perName.DocumentName;
            }
        }
        return msg;
    };
}
-(void)loadinfo{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    empname = [defaults objectForKey:@"empname"];
    groupname = [defaults objectForKey:@"GroupName"];
    self.lblname.text=empname;
    self.lbldept.text=groupname;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    [self.myHeadPortrait setImage: myDelegate.userPhotoimageView.image];
    [self loadacinfo];
}
-(void)loadacinfo{
    //设置需要访问的ws和传入参数
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetAttendance?empid=%@",empID];
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
}
-(void)loadacdinfo:(NSString *)acdate
{
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetAttendanceDetail?empid=%@&attime=%@",empID,acdate];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        // 字符串截取
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
        NSRange endRagne = [xmlString rangeOfString:@"</string>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        if([xmlString containsString:@"AttendanceCalendarTime"])
        {
            listOfMovies = [AttendanceCalendar mj_objectArrayWithKeyValuesArray:resultDic];
            //[self.calview reloadInputViews];
        }
        else
        {
            listOfMoviesDetail = [AttendanceCalendarDetail mj_objectArrayWithKeyValuesArray:resultDic];
            [self.NewTableView reloadData];
            [self.NewTableView layoutIfNeeded];
        }
    });
}
//解析返回的xml系统自带方法不需要h中声明
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
   
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
    return self.listOfMoviesDetail.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttendanceListCell * cell = [self.NewTableView dequeueReusableCellWithIdentifier:identifierac forIndexPath:indexPath];
    cell.attendancelistitem =self.listOfMoviesDetail[indexPath.row];//取出数据元素
    return cell;
}
@end
