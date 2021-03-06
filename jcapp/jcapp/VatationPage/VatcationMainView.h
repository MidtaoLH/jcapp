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

@interface VatcationMainView : SWFormBaseController{
    
    
    UIDatePicker*datePicker;
    NSString *xmlString;
    //NSMutableArray *myData;
    //    NSInteger totalcount;
    //    NSInteger totalHeight;
    
    NSString *groupid;
    NSString *empname;
    NSString *empID;
    NSString *userID;
    NSString *UserHour;
    NSString *iosid;
    NSString *alert;
    NSString *edittype;
    NSString *vatcationid;
    NSString *processid;
    NSString *urltype;
    NSString *ApplyCode;
    NSString *operateType;
    
    UIDatePicker*datePickers;
    UIDatePicker*datePickere;
    
    NSUInteger imgcount;   //图片总数
    NSUInteger isUploadImg;//是否正在上传图片 1:是 0:不是
    NSUInteger errImgCount;//上传失败的图片个数
    NSUInteger rightImgCount;//上传失败的图片个数
}


// 添加数据源
@property (strong,nonatomic) NSMutableArray *listOfKeepLeave;
@property (strong,nonatomic) NSMutableArray *listOfLeave;

@property (nonatomic,copy) NSString *processInstanceID;
@property (nonatomic,copy) NSString *vatcationid;
@property (nonatomic,copy) NSString *ProcessApplyCode;
@property (nonatomic,copy) NSString *edittype;  //0 追加
@property (nonatomic,copy) NSString *urltype;
@property (nonatomic,copy) NSString *proCelReson;

@property (nonatomic,copy) NSString *selectindex;

@property (weak, nonatomic) IBOutlet UIButton *btnProcess;

@end

NS_ASSUME_NONNULL_END
