//
//  AttendanceCalendarDetail.h
//  jcapp
//
//  Created by lh on 2019/12/11.
//  Copyright © 2019 midtao. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttendanceCalendarDetail : NSObject
@property (nonatomic,copy) NSString * UserID;
@property (nonatomic,copy) NSString * PlanStartTime;
@property (nonatomic,copy) NSString * PlanEndTime;
@property (nonatomic,copy) NSString * PlanNum;

@property (nonatomic,copy) NSString * Describe;
@property (nonatomic,copy) NSString * PlanType;
@end
NS_ASSUME_NONNULL_END
