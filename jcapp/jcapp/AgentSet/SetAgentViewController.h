//
//  SetAgentViewController.h
//  jcapp
//
//  Created by lh on 2019/12/23.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../SWForm/SWFormBaseController.h"
#import "BRInfoCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface SetAgentViewController : SWFormBaseController
{
    UIDatePicker*datePickers;
    UIDatePicker*datePickere;
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
     NSString *iosid;
}
@property (nonatomic,copy) NSString *agentID;

@end

NS_ASSUME_NONNULL_END
