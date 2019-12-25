//
//  AgentInfo.m
//  jcapp
//
//  Created by lh on 2019/12/24.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AgentInfo.h"
#import "MJExtension.h"
@implementation AgentInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
              @"AgentSetID":@"AgentSetID",
              @"EmpName":@"EmpName",
              @"DeptName":@"DeptName",
              @"AgentStatus":@"AgentStatus",
              @"AgentDate":@"AgentDate",
              @"CreateDate":@"CreateDate",
              @"AppDate":@"AppDate",
             };
    
}
@end
