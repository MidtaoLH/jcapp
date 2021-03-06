//
//  LeaveDetailCell.h
//  jcapp
//
//  Created by zclmac on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/LeaveDeatil.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeaveDetailCell : UITableViewCell
{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    NSString *userID;
    NSString *iosid;
}
@property (nonatomic,strong) LeaveDeatil * leavedetail;

@end

NS_ASSUME_NONNULL_END
