//
//  Attendance.h
//  jcapp
//
//  Created by lh on 2019/12/12.
//  Copyright © 2019 midtao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "../Model/AttendanceCalendarDetail.h"


NS_ASSUME_NONNULL_BEGIN

@interface AttendanceListCell : UITableViewCell

@property (nonatomic,strong) AttendanceCalendarDetail * attendancelistitem;



@end

NS_ASSUME_NONNULL_END
