//
//  UserInfo.m
//  jcapp
//
//  Created by lh on 2019/11/26.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "UserInfo.h"
#import "MJExtension.h"
@implementation UserInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"code":@"code",
             @"name":@"name",
             @"dept":@"dept",
             };
    
}
@end
