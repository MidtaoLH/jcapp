//
//  MdlBusinessTrip.h
//  jcapp
//
//  Created by zhaodan on 2019/12/24.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MdlBusinessTrip : NSObject

@property (copy, nonatomic) NSString *EmpName;

@property (copy, nonatomic) NSString *G_CName;

@property (copy, nonatomic) NSString *ApplyDate;

@property (copy, nonatomic) NSString *ApplyPlace;


@property (copy, nonatomic) NSString *ProcessStutasTxt;
@property (copy, nonatomic) NSString *StartTime;
@property (copy, nonatomic) NSString *EndTime;
@property (copy, nonatomic) NSString *TimeNum;
@property (copy, nonatomic) NSString *BusinessTripReason; //liyou

//@property (copy, nonatomic) NSString *EvectionTypeTxt;

@end

NS_ASSUME_NONNULL_END
