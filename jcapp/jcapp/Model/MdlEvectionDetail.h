//
//  MdlEvectionDetail.h
//  jcapp
//
//  Created by zclmac on 2019/12/18.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MdlEvectionDetail : NSObject

@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * groupname;

@property (nonatomic,copy) NSString * Level;
@property (nonatomic,copy) NSString * levelname;

@property (nonatomic,copy) NSString * TaskDate;

@property (nonatomic,copy) NSString * Remark;

@property (nonatomic,copy) NSString * TaskNodeOperateType;
@property (nonatomic,copy) NSString * TaskAuditeStatus;
@property (nonatomic,copy) NSString * ProcessStutas;
@property (copy, nonatomic) NSString *U_LoginName;
@property (nonatomic,copy) NSString * TaskInstanceID;

@end

NS_ASSUME_NONNULL_END
