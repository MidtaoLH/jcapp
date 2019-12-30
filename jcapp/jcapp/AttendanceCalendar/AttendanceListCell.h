//
//  Attendance.h
//  jcapp
//
//  Created by lh on 2019/12/12.
//  Copyright © 2019 midtao. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface AttendanceListCell : UITableViewCell
@property (nonatomic, strong) UILabel *attendanceCaseNameLable;
@property (nonatomic, strong) UILabel *attendanceDateLable;
@property (nonatomic, strong) UILabel *attendanceDurationLable;
@property (nonatomic, strong) UILabel *attendanceDescribeLable;

@end
