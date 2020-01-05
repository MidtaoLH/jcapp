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

@property (copy, nonatomic) NSString *ApplyFileName;

@property (nonatomic,copy) NSString * CaseName;
@property (nonatomic,copy) NSString * LeaveTypeName;

@property (nonatomic,copy) NSString * BeginDate;
@property (nonatomic,copy) NSString * EndDate;

@property (copy, nonatomic) NSString *ProcessStutasName;
@property (copy, nonatomic) NSString *ProcessInstanceID;
@property (nonatomic,copy) NSString * ApplyDate;
@property (copy, nonatomic) NSString *AwardID_FK;
@property (nonatomic,copy) NSString * LeaveApplyCode;
@property (nonatomic,copy) NSString * LeaveVersion;
@property (copy, nonatomic) NSString *U_LoginName;

@property (copy, nonatomic) NSString *ProcessApplyCode;
 
@end

NS_ASSUME_NONNULL_END
