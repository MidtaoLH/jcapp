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
    //NSMutableArray *myData;
//    NSInteger totalcount;
//    NSInteger totalHeight;
}
@end
NS_ASSUME_NONNULL_END
