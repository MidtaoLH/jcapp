//
//  NoticeDetailController.h
//  jcapp
//
//  Created by zclmac on 2019/12/10.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/NoticeNews.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblthem;

@property (weak, nonatomic) IBOutlet UILabel *lblgroup;

@property (weak, nonatomic) IBOutlet UILabel *lblnoticedate;

@property (weak, nonatomic) IBOutlet UILabel *lbltoncent;

// 添加数据源
@property (nonatomic,strong) NoticeNews * noticeitem;

@end

NS_ASSUME_NONNULL_END
