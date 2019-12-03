//
//  LeaveList.h
//  jcapp
//
//  Created by zclmac on 2019/12/1.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeaveListModel : NSObject

@property (nonatomic,copy) NSString * CaseName;
@property (nonatomic,copy) NSString * LeaveTypeTxt;

@property (nonatomic,copy) NSString * BeignDate;
@property (nonatomic,copy) NSString * EndDate;

@property (nonatomic,copy) NSString * LeaveStatusTxt;

@property (nonatomic,copy) NSString * LeaveDate;

@property (nonatomic,copy) NSString * LeaveApplyCode;
@property (nonatomic,copy) NSString * LeaveVersion;
 
@end

NS_ASSUME_NONNULL_END
