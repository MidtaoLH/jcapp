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
    UIDatePicker*datePicker;
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
    NSString *businessTripid;
    NSString *processid;
    NSString *pageType;
    NSString *operateType;
    NSString *applyCode;
}
@end
NS_ASSUME_NONNULL_END
