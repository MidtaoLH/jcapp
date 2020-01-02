//
//  LeavePending.h
//  jcapp
//
//  Created by lh on 2019/12/2.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Pending : NSObject
@property (nonatomic,copy) NSString * CaseName;
@property (nonatomic,copy) NSString * CaseTypeTxt;
@property (nonatomic,copy) NSString * BeignDate;
@property (nonatomic,copy) NSString * EndDate;
@property (nonatomic,copy) NSString * CaseStatusTxt;
@property (nonatomic,copy) NSString * CaseDate;
@property (nonatomic,copy) NSString * CaseApplyCode;
@property (nonatomic,copy) NSString * CaseApplyMan;
@property (nonatomic,copy) NSString * CaseVersion;
@property (nonatomic,copy) NSString * ApplyManPhoto;
@property (nonatomic,copy) NSString * PicID;
@property (nonatomic,copy) NSString * AidFK;
@property (nonatomic,copy) NSString * DocumentID_FK;
@property (nonatomic,copy) NSString * DocumentName;
@property (nonatomic,copy) NSString * TaskViewBackID;
@property (nonatomic,copy) NSString * TaskNodeOperateType;
@property (nonatomic,copy) NSString * TaskInstanceID;
@end

NS_ASSUME_NONNULL_END
