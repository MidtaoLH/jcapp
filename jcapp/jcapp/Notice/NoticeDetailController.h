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


// 添加数据源
@property (nonatomic,strong) NoticeNews * noticeitem;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, assign)  CGSize  labelSize; 
@end

NS_ASSUME_NONNULL_END
