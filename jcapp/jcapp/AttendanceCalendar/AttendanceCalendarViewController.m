//
//  AttendanceCalendarViewController.m
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AttendanceCalendarViewController.h"
@interface AttendanceCalendarViewController () 


@end

@implementation AttendanceCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BSLCalendar *calendar = [[BSLCalendar alloc]initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.bounds)-40, 300)];
    [self.view addSubview:calendar];
    
    calendar.showChineseCalendar = YES;
    [calendar selectDateOfMonth:^(NSInteger year, NSInteger month, NSInteger day) {
        NSLog(@"%ld年/%ld月/%ld日",(long)year,(long)month,(long)day);
    }];
   
}

@end
