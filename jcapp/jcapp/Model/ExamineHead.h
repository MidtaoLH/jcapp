//
//  ExamineHead.h
//  jcapp
//
//  Created by zclmac on 2020/1/2.
//  Copyright © 2020 midtao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExamineHead : NSObject

@property (nonatomic,copy) NSString * EmpCName;
@property (nonatomic,copy) NSString * groupname;

@property (nonatomic,copy) NSString * BeignDate;
@property (nonatomic,copy) NSString * EndDate;

@property (nonatomic,copy) NSString * StatusTxt;

@property (nonatomic,copy) NSString * ExamineDate;

@property (nonatomic,copy) NSString * LeavePlanNum;
@property (nonatomic,copy) NSString * TypeTxt;
@property (nonatomic,copy) NSString * Describe;

@property (nonatomic,copy) NSString * BusinessTripPlace;
@property (nonatomic,copy) NSString * numcount;

@property (nonatomic,copy) NSString * U_LoginName;
@property (nonatomic,copy) NSString * CCAddress;
@end

NS_ASSUME_NONNULL_END
