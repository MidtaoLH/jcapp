//
//  AttendanceCalendarViewController.m
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AttendanceCalendarViewController.h"
#import "../LTSCalendar/LTSCalendarManager.h"
@interface AttendanceCalendarViewController ()<LTSCalendarEventSource>{
    NSMutableDictionary *eventsByDate;
}

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,strong)LTSCalendarManager *manager;

@end

@implementation AttendanceCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lts_InitUI];
}

- (void)lts_InitUI{
    self.manager = [LTSCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[LTSCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 30)];
    [self.view addSubview:self.manager.weekDayView];
    
    CGFloat headimageW = self.view.frame.size.width;
    CGFloat headimageH =  self.view.frame.size.height;
    self.manager.calenderScrollView = [[LTSCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame),headimageW,headimageH)];
    [self.view addSubview:self.manager.calenderScrollView];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    [LTSCalendarAppearance share].firstWeekday = 2;
    [self.manager reloadAppearanceAndData];
}

// 该日期是否有事件
- (BOOL)calendarHaveEventWithDate:(NSDate *)date {
    NSString *key = [[self dateFormatter] stringFromDate:date];
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}
//当前 选中的日期  执行的方法
- (void)calendarDidSelectedDate:(NSDate *)date {
    NSString *key = [[self dateFormatter] stringFromDate:date];
    self.label.text =  key;
    NSArray *events = eventsByDate[key];
     
    NSLog(@"%@",date);
    if (events.count>0) {
        //该日期有事件    tableView 加载数据
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    return dateFormatter;
}
@end
