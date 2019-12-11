//
//  AttendanceCalendar.h
//  jcapp
//
//  Created by lh on 2019/12/11.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttendanceCalendar : NSObject
@property (nonatomic,copy) NSString * UserID;
@property (nonatomic,copy) NSString * DocumentID;
@property (nonatomic,copy) NSString * DocumentName;
@property (nonatomic,copy) NSString * AttendanceCalendarTime;
@end
NS_ASSUME_NONNULL_END
