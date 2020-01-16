//
//  LeaveStatusModel.h
//  jcapp
//
//  Created by zhaodan on 2019/12/8.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeaveStatusModel : NSObject

@property (nonatomic,copy) NSString * Status;
@property (nonatomic,copy) NSString * LeaveID;
@property (nonatomic,copy) NSString * ProcessID;
@property (nonatomic,copy) NSString * ApplyCode;
@property (nonatomic,copy) NSString * message;

@end

NS_ASSUME_NONNULL_END
