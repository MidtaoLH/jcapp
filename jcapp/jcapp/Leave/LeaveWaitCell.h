//
//  LeaveWaitCell.h
//  jcapp
//
//  Created by zclmac on 2019/12/2.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/LeaveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeaveWaitCell : UITableViewCell

    @property (nonatomic,strong) LeaveListModel * leavelistitem;

@end

NS_ASSUME_NONNULL_END
