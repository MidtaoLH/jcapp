//
//  pwdInfo.h
//  jcapp
//
//  Created by lh on 2019/12/27.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface pwdInfo : NSObject
/** 编号 */
@property (nonatomic, copy) NSString *userid;
/** 旧密码 */
@property (nonatomic, copy) NSString *oldpwd;
/** 新密码 */
@property (nonatomic, copy) NSString *newpwd;
/** 确认密码 */
@property (nonatomic, copy) NSString *enterpwd;
@end
