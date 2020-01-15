//
//  Way.h
//  jcapp
//
//  Created by zhaodan on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Way : NSObject

/** dengluflag */
@property (copy, nonatomic) NSString *levelname;

/** mingcheng */
@property (copy, nonatomic) NSString *name;
/** id */
@property (copy, nonatomic) NSString *nameid;

/** nameg */
@property (copy, nonatomic) NSString *groupname;
/** id */
@property (copy, nonatomic) NSString *groupid;

@property (copy, nonatomic) NSString *englishname;

/** yonghuming */
@property (copy, nonatomic) NSString *level;

@property (copy, nonatomic) NSString *editflag;

@property (copy, nonatomic) NSString *Condition;

@end

NS_ASSUME_NONNULL_END
