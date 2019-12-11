//
//  NoticeCell.h
//  jcapp
//
//  Created by zclmac on 2019/12/10.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/NoticeNews.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCell : UITableViewCell
    @property (nonatomic,strong) NoticeNews * noticelist;
@end

NS_ASSUME_NONNULL_END
