//
//  UserLogin.h
//  jcapp
//
//  Created by zhaodan on 2019/12/2.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserLogin : NSObject


/** dengluflag */
@property (copy, nonatomic) NSString *flag;

/** id */
@property (copy, nonatomic) NSString *id;

/** yonghuming */
@property (copy, nonatomic) NSString *code;

/** mingcheng */
@property (copy, nonatomic) NSString *name;

/** mingcheng */
@property (copy, nonatomic) NSString *EmpID;
@end

NS_ASSUME_NONNULL_END
