//
//  KeepLeave.h
//  jcapp
//
//  Created by zhaodan on 2019/12/19.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeepLeave : NSObject

//请假主键id
@property (copy, nonatomic) NSString *vatcationid;

//请假类型id
@property (copy, nonatomic) NSString *vatcationtrpeid;

//请假类型名称
@property (copy, nonatomic) NSString *vatcationtrpe;

//请假开始时间
@property (copy, nonatomic) NSString *timestart;

//请假结束时间
@property (copy, nonatomic) NSString *timesend;

//请假时长
@property (copy, nonatomic) NSString *timesum;

//请假缘由
@property (copy, nonatomic) NSString *vatcationreason;

//请假图片
@property (copy, nonatomic) NSString *imagepath;


@end

NS_ASSUME_NONNULL_END
