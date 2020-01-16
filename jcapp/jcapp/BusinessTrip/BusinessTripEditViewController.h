//
//  BusinessTripEditViewController.h
//  jcapp
//
//  Created by youkare on 2019/12/12.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../SWForm/SWFormBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessTripEditViewController  : SWFormBaseController
{
    
    IBOutlet UITableView *tableViewPlace;
    UIDatePicker*datePickers;
    UIDatePicker*datePickere;
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    //NSMutableArray *myData;
//    NSInteger totalcount;
//    NSInteger totalHeight;
    
    NSString *groupid;
    NSString *empname;
    NSString *empID;
    NSString *userID;
    NSString *applyCode;
    NSString *alert;
    NSString *isLoad;
    NSUInteger imgcount;
    NSUInteger errImgCount;//上传失败的图片个数
    NSUInteger rightImgCount;//上传失败的图片个数
}
@property (weak, nonatomic) IBOutlet UIButton *btnProcess;
@property (nonatomic,copy) NSString *processid;
@property (nonatomic,copy) NSString *businessTripid;
@property (nonatomic,copy) NSString *pageType;
@property (nonatomic,copy) NSString *operateType;
@end
NS_ASSUME_NONNULL_END
