//
//  AttendanceCalendarMonthDetai.h
//  jcapp
//
//  Created by lh on 2019/12/10.
//  Copyright © 2019 midtao. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttendanceCalendarMonthDetail : NSObject
@property (nonatomic,copy) NSString * UserID;
@property (nonatomic,copy) NSString * DocumentID;
@property (nonatomic,copy) NSString * DocumentName;
@property (nonatomic,copy) NSString * AttendanceCalendarTime;
@property (nonatomic,copy) NSString * PlanSumNum;
@property (nonatomic,copy) NSString * acweek;
@end

NS_ASSUME_NONNULL_END
