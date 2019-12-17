//
//  LeaveImageCell.h
//  jcapp
//
//  Created by zclmac on 2019/12/10.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamineEditImageCell : UITableViewCell
   @property (nonatomic, copy) NSString *str;

   @property (nonatomic, weak) SDPhotoGroup *photosGroup;
@end

NS_ASSUME_NONNULL_END
