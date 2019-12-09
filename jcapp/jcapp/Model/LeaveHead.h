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

@property (nonatomic,copy) NSString * EmpCName;
@property (nonatomic,copy) NSString * groupname;

@property (nonatomic,copy) NSString * BeignDate;
@property (nonatomic,copy) NSString * EndDate;

@property (nonatomic,copy) NSString * LeaveStatusTxt;

@property (nonatomic,copy) NSString * LeaveDate;

@property (nonatomic,copy) NSString * LeavePlanNum;
@property (nonatomic,copy) NSString * LeaveTypeTxt;
@property (nonatomic,copy) NSString * LeaveDescribe;

@end

NS_ASSUME_NONNULL_END
