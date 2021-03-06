//
//  AttendanceCalendarViewController.m
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AttendanceCalendarViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "../Model/AttendanceCalendarDetail.h"
#import "../Model/AttendanceCalendar.h"
#import "AttendanceListCell.h"
#import "ViewController.h"

@interface AttendanceCalendarViewController ()
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@end

@implementation AttendanceCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    iosid = [defaults objectForKey:@"adId"];
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    self.calview.tagStringOfDate=^NSString*(NSArray* calm,NSArray* itemDateArray){
        NSString *datestr = [NSString stringWithFormat:@"%@-%@-%@",itemDateArray[0],itemDateArray[1],itemDateArray[2]];
        NSString *msg=nil;
        
        for (AttendanceCalendar *perName in myDelegate.aclistOfMovies) {
            if ([perName.AttendanceCalendarTime isEqualToString:datestr])
            {
                msg=perName.DocumentName;
            }
        }
        return msg;
    };
    self.calview.onDateSelectBlk=^(NSDate* date){
	
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [format stringFromDate:date];
        [self loadacdinfo:dateString];
        
    };
    [self loadstyle];
    [self loadinfo];
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
}
- (void)loadstyle {
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 默认有此行，请删除或注 释 #warning Incomplete method implementation.
    // 这里是返回节点的行数
    return _listOfMoviesDetail.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"acInfoCell";
    AttendanceListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[AttendanceListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    AttendanceCalendarDetail *detail =self.listOfMoviesDetail[indexPath.row];//取出数据元素
    
    cell.attendanceCaseNameLable.text=detail.PlanType;
    
    if(detail.PlanStartTime.length>0)
    {
        cell.attendanceDateLable.text=[NSString stringWithFormat:@"请假时间：%@  ~  %@",detail.PlanStartTime,detail.PlanEndTime];
    }else
    {
        cell.attendanceDateLable.text=@"请假时间:";
    }
    cell.attendanceDurationLable.text=[NSString stringWithFormat:@"请假时长（h）:%@",detail.PlanNum];
    cell.attendanceDescribeLable.text= [NSString stringWithFormat:@"请假事由：%@",detail.Describe];
    return cell;
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

-(void)loadacdinfo:(NSString *)acdate
{
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetAttendanceDetail?empid=%@&attime=%@&iosid=%@&userid=%@",empID,acdate ,iosid,userID];
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
}
//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    @try {
        
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if([xmlString containsString: Common_MoreDeviceLoginFlag])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"" message: Common_MoreDeviceLoginErrMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            ViewController * valueView = [[ViewController alloc] initWithNibName:@"ViewController"bundle:[NSBundle mainBundle]];
            //跳转
            [self presentModalViewController:valueView animated:YES];
        }
        else
        {
        // 字符串截取
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
        NSRange endRagne = [xmlString rangeOfString:@"</string>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        
        _listOfMoviesDetail = [AttendanceCalendarDetail mj_objectArrayWithKeyValuesArray:resultDic];
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        }
    }
    @catch (NSException *exception) {
        NSArray *arr = [exception callStackSymbols];
        NSString *reason = [exception reason];
        NSString *name = [exception name];
        NSLog(@"err:\n%@\n%@\n%@",arr,reason,name);
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Common_AttendanceTxTHeight*4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}
@end
