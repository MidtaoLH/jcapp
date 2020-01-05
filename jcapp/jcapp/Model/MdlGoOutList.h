//
//  MdlGoOutList.h
//  jcapp
//
//  Created by zclmac on 2019/12/17.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MdlGoOutList : NSObject

@property (nonatomic,copy) NSString * ApplyDate;

@property (copy, nonatomic) NSString *ApplyFileName;

@property (copy, nonatomic) NSString *EvectionPlanTime;

@property (copy, nonatomic) NSString *ProcessStutasName;

@property (copy, nonatomic) NSString *AwardID_FK;

@property (copy, nonatomic) NSString *ProcessInstanceID;

@property (copy, nonatomic) NSString *ProcessApplyCode;

@property (copy, nonatomic) NSString *BeginDate;

@property (copy, nonatomic) NSString *EndDate;

@property (copy, nonatomic) NSString *U_LoginName;

@end

NS_ASSUME_NONNULL_END

