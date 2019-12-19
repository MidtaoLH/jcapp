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
    
    IBOutlet UITableView *tableViewPlace;
    UIDatePicker*datePicker;
    NSString *xmlString;
    //NSMutableArray *myData;
    //    NSInteger totalcount;
    //    NSInteger totalHeight;
    
    NSString *groupid;
    NSString *empname;
    NSString *empID;
    NSString *userID; 
}

@end

NS_ASSUME_NONNULL_END
