//
//  AttendanceSummaryViewController.m
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AttendanceSummaryViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "MCDatePickerView.h"
#import "../Model/AttendanceCalendarMonth.h"
#import "../Model/AttendanceCalendarMonthDetail.h"
@interface AttendanceSummaryViewController ()<MCDatePickerViewDelegate>

- (IBAction)startDateButtonOnClicked:(id)sender;
@end

@implementation AttendanceSummaryViewController
@synthesize listOfMovies;
@synthesize listOfMoviesDetail;
- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self loadinfo];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if(myDelegate.acsavedatetime.length==0)
    {
        NSDate *newDate = [NSDate date];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy年MM月"];
        self.startDate = [format stringFromDate:newDate];
    }
    else
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy年MM月"];
        self.startDate = [format stringFromDate:myDelegate.acsavedatetime];
    }
    [self.btndate setTitle:self.startDate forState:UIControlStateNormal];
    
    [self loadacinfo:self.startDate];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
-(void)loadacinfo:(NSString *)acdate
{
    //设置需要访问的ws和传入参数
    NSString *dateStr=acdate;
  
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"月" withString:@""];
    
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetAttendanceMonth?empid=%@&actime=%@",empID,dateStr];
    
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
    //设置需要访问的ws和传入参数
    NSString *dateStr=acdate;
    
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"月" withString:@""];
    
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetAttendanceeMonthDetail?empid=%@&actime=%@",empID,dateStr];
    
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
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

//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    @try {
        
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // 字符串截取
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
        NSRange endRagne = [xmlString rangeOfString:@"</string>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        
        if([xmlString containsString:@"acweek"])
        {
            listOfMoviesDetail = [AttendanceCalendarMonthDetail mj_objectArrayWithKeyValuesArray:resultDic];
        }
        else{
            listOfMovies = [AttendanceCalendarMonth mj_objectArrayWithKeyValuesArray:resultDic];
            if(listOfMovies.count>0)
            {
                [self loadacdinfo:self.startDate];
            }
            else
            {
                listOfMoviesDetail= [AttendanceCalendarMonthDetail mj_objectArrayWithKeyValuesArray:resultDic];
            }
            [self.foldingTableView reloadData];
            [self.foldingTableView layoutIfNeeded];
        }
        //[self.listOfMovies addObjectsFromArray:self.listMovies];
        // 创建tableView
        [self setupFoldingTableView];    }
    @catch (NSException *exception) {
        NSArray *arr = [exception callStackSymbols];
        NSString *reason = [exception reason];
        NSString *name = [exception name];
        NSLog(@"err:\n%@\n%@\n%@",arr,reason,name);
    }
    
    
}
- (IBAction)startDateButtonOnClicked:(id)sender {
    MCDatePickerView *monthView = [[MCDatePickerView alloc] initWithFrame:CGRectZero type:XMGStyleTypeYearAndMonth];
    self.yearShow = NO;
    monthView.delegate = self;
    [monthView show];
}

-(void)didSelectDateResult:(NSString *)resultDate{
    [self.btndate setTitle:resultDate forState:UIControlStateNormal];
    self.startDate = resultDate;
    [self loadacinfo:self.startDate];
}
// 创建tableView
- (void)setupFoldingTableView
{
    CGFloat tabBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height+20;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat topHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
    YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize*2, kScreenWidth,kScreenHeight-(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize*2))];
    _foldingTableView = foldingTableView;
    
    [self.view addSubview:foldingTableView];
    foldingTableView.foldingDelegate = self;
    
    if (self.arrowPosition) {
        foldingTableView.foldingState = YUFoldingSectionStateShow;
    }
    if (self.index == 2) {
        foldingTableView.sectionStateArray = @[@"1", @"0", @"0"];
    }
}

#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
//分组几个
- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    return listOfMovies.count;
}
//这个分组内面有多个条
- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
{
    AttendanceCalendarMonth *msg = self.listOfMovies[(long)section];
    NSInteger count=0;
    for (AttendanceCalendarMonthDetail *perName in listOfMoviesDetail) {
        if ([[perName DocumentID] isEqualToString:msg.DocumentID]) {
            count++;
        }
    }
    return count;
}
//这个分组的分组头的高度
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section
{
    return 50;
}
//这个分组的内面每一条的行高
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [yuTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    AttendanceCalendarMonth *msg = self.listOfMovies[(long)indexPath.section];
    NSInteger count=0;
    for (AttendanceCalendarMonthDetail *perName in listOfMoviesDetail) {
        if ([[perName DocumentID] isEqualToString:msg.DocumentID]) {
            if(count==indexPath.row)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ --- %@",perName.AttendanceCalendarTime,perName.PlanSumNum];
            }
            count++;
        }
    }
    
    
    
    return cell;
}
#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
{
    AttendanceCalendarMonth *msg = self.listOfMovies[(long)section];
    return msg.DocumentName;
}
- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld",indexPath.section);
}

// 返回箭头的位置
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    // 没有赋值，默认箭头在左
    return self.arrowPosition ? :YUFoldingSectionHeaderArrowPositionLeft;
}

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section
{
    AttendanceCalendarMonth *msg = self.listOfMovies[(long)section];
    return [NSString stringWithFormat:@"%@",msg.PlanSumNum];
}

@end
