//
//  NoticeDetailController.m
//  jcapp
//
//  Created by zclmac on 2019/12/10.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "NoticeDetailController.h"

@interface NoticeDetailController ()

@end

@implementation NoticeDetailController

@synthesize noticeitem;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置换行
    self.lbltoncent.lineBreakMode = UILineBreakModeWordWrap;
    self.lbltoncent.numberOfLines = 0;
    
    self.lblnoticedate.text = noticeitem.NewsDate;
    
    self.lblthem.text = noticeitem.NewsTheme;
    
    self.lbltoncent.text = noticeitem.NewsContent;
    
    self.lblgroup.text = noticeitem.G_CName;
    
    self.lblgroup.font = [UIFont systemFontOfSize:15];
    self.lblgroup.textColor = [UIColor grayColor];
    
    self.lblnoticedate.font = [UIFont systemFontOfSize:15];
    self.lblnoticedate.textColor = [UIColor grayColor];
    
    [self.lbltoncent sizeToFit];
    
     NSLog(@"%@",@"viewDidLoad-detail-bgn");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
