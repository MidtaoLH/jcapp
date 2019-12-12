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
#import "ITDatePickerController.h"

@interface AttendanceSummaryViewController ()<ITDatePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblname;
@property (weak, nonatomic) IBOutlet UILabel *lbldept;
@property (weak, nonatomic) IBOutlet UIImageView *myHeadPortrait;
@property (weak, nonatomic) IBOutlet UIButton *btndate;
@property (strong, nonatomic) NSDate *startDate;
@property (nonatomic, weak) YUFoldingTableView *foldingTableView;
- (IBAction)startDateButtonOnClicked:(id)sender;
@end

@implementation AttendanceSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat tabBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height+20;
    CGFloat headimageW = self.view.frame.size.width * 0.25;
    CGFloat headimageH = headimageW;
    self.myHeadPortrait.frame = CGRectMake(20, tabBarHeight*0.9, headimageW, headimageH);
    //这句必须写
    self.myHeadPortrait.layer.masksToBounds = YES;
    self.myHeadPortrait.layer.cornerRadius = headimageW * 0.5;
    self.myHeadPortrait.image = [UIImage imageNamed:@"1"];
    self.myHeadPortrait.backgroundColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
    
    headimageW = self.view.frame.size.width * 0.25;
    headimageH =  headimageW;
    self.lblname.frame=CGRectMake(self.myHeadPortrait.width+40, tabBarHeight-self.myHeadPortrait.height/6, headimageW, headimageH);
    self.lbldept.frame=CGRectMake(self.myHeadPortrait.width+40, tabBarHeight+self.myHeadPortrait.height/5, headimageW, headimageH);
    [self loadinfo];
   
    
    headimageH =  headimageW;
    headimageW = self.view.frame.size.width * 0.35;
    self.btndate.frame=CGRectMake(self.myHeadPortrait.width+ self.lblname.width+20, tabBarHeight, headimageW, headimageH);
    
    NSDate *newDate = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月"];
    NSString *dateString = [format stringFromDate:newDate];
    [self.btndate setTitle:dateString forState:UIControlStateNormal];
    
    
    // 创建tableView
    [self setupFoldingTableView];
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
- (IBAction)startDateButtonOnClicked:(id)sender {
    
    ITDatePickerController *datePickerController = [[ITDatePickerController alloc] init];
    datePickerController.tag = 100;                     // Tag, which may be used in delegate methods
    datePickerController.delegate = self;               // Set the callback object
    datePickerController.showToday = NO;                // Whether to show "today", default is yes
    datePickerController.defaultDate = self.startDate;  // Default date
 
    [self presentViewController:datePickerController animated:YES completion:nil];
}
- (void)datePickerController:(ITDatePickerController *)datePickerController didSelectedDate:(NSDate *)date dateString:(NSString *)dateString {
    
    NSInteger tag = datePickerController.tag;
    UIButton *button = [self.view viewWithTag:tag];
    [self.btndate setTitle:dateString forState:UIControlStateNormal];
    if (datePickerController.tag == 100) {
        self.startDate = date;
    }
}

// 创建tableView
- (void)setupFoldingTableView
{
    CGFloat tabBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height+20;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat topHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
    YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, topHeight+self.myHeadPortrait.height+20, self.view.bounds.size.width, self.view.bounds.size.height - topHeight)];
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
    return 6;
}
//这个分组内面有多个条
- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
{
    return 3;
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
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld -- section %ld", (long)indexPath.row, (long)indexPath.section];
    
    return cell;
}
#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"gg %ld",(long)section];
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
    return @"detailText";
}

@end
