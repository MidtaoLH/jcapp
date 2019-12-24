//
//  TaskViewInfo.m
//  jcapp
//
//  Created by lh on 2019/12/17.
//  Copyright © 2019 midtao. All rights reserved.
//
#import "ViewBackInfo.h"
#import "MJExtension.h"
@implementation ViewBackInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ProcessInstanceID":@"ProcessInstanceID",
             @"ApplyMan":@"ApplyMan",
             @"ApplyManName":@"ApplyManName",
             @"ApplyGroupName":@"ApplyGroupName",
             @"ApplyDate":@"ApplyDate",
             @"ApplyAmount":@"ApplyAmount",
             @"strattime":@"strattime",
             @"endtime":@"endtime",
             @"HistoryType":@"HistoryType",
             @"ProcDescribe":@"ProcDescribe",
             @"ProcStatus":@"ProcStatus",
             @"DocumentName":@"DocumentName",
             @"TaskViewBackID":@"TaskViewBackID",
             };
    
}
@end

