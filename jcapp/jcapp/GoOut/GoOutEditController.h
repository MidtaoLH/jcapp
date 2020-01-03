//
//  VatcationMainView.h
//  jcapp
//
//  Created by zhaodan on 2019/12/17.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../SWForm/SWFormBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoOutEditController : SWFormBaseController{
    
    UIDatePicker*datePicker;
    NSString *xmlString;
    NSString *groupid;
    NSString *empname;
    NSString *empID;
    NSString *userID;
    NSString *UserHour;
     
    NSString *vatcationid;
    NSString *processid; 
    NSString *ApplyCode;
    UIDatePicker*datePickers;
    UIDatePicker*datePickere;
} 
@property (nonatomic,copy) NSString *processInstanceID;
@property (nonatomic,copy) NSString *evectionID;
@property (nonatomic,copy) NSString *ProcessApplyCode;
@property (nonatomic,copy) NSString *edittype;  //0 追加
@property (nonatomic,copy) NSString *urltype;



// 添加数据源
@property (strong,nonatomic) NSMutableArray *listOfKeepLeave;
@property (strong,nonatomic) NSMutableArray *listOfLeave;

@property (strong,nonatomic) NSMutableArray *listdetail;
@property (strong,nonatomic) NSMutableArray *listhead;
@property (strong,nonatomic) NSMutableArray *listtask;

@property (strong,nonatomic) NSMutableArray *listAnnex;

@end

NS_ASSUME_NONNULL_END
