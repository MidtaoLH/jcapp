//
//  LeaveHead.h
//  jcapp
//
//  Created by zclmac on 2019/12/4.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeaveHead : NSObject

@property (copy, nonatomic) NSString *EmpName;

@property (copy, nonatomic) NSString *G_CName;

@property (copy, nonatomic) NSString *ApplyDate;

@property (copy, nonatomic) NSString *ProcessStutasTxt;
@property (copy, nonatomic) NSString *PlanStartTime;
@property (copy, nonatomic) NSString *PlanEndTime;
@property (copy, nonatomic) NSString *TimePlanNum;
@property (copy, nonatomic) NSString *CaseDescribe;

@property (copy, nonatomic) NSString *LeaveTypeTxt;
@property (copy, nonatomic) NSString *ProcessApplyCode;

@end

NS_ASSUME_NONNULL_END
