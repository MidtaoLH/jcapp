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

@interface ExamineEditCell : UITableViewCell
{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
}
@property (nonatomic,strong) LeaveDeatil * leavedetail;

@end

NS_ASSUME_NONNULL_END
