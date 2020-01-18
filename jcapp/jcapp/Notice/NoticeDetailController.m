//
//  NoticeDetailController.m
//  jcapp
//
//  Created by zclmac on 2019/12/10.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "NoticeDetailController.h"
#import "../MJRefresh/MJRefresh.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "Masonry.h"

@interface NoticeDetailController ()

@end

@implementation NoticeDetailController

@synthesize noticeitem;



- (void)viewDidLoad {
    [super viewDidLoad];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
     self.navigationItem.title=@"公告查看";
    //设置换行
    self.lbltoncent.lineBreakMode = UILineBreakModeWordWrap;
    self.lbltoncent.numberOfLines = 0;
    
    self.lblnoticedate.text =  [@"发布时间：" stringByAppendingString: noticeitem.NewsDate];
    
    self.lblthem.text = noticeitem.NewsTheme;
    
    self.lbltoncent.text = noticeitem.NewsContent;
    
    self.lblgroup.text = noticeitem.G_CName;
    
    self.lblgroup.font = [UIFont systemFontOfSize:15];
    self.lblgroup.textColor = [UIColor grayColor];
    
    self.lblnoticedate.font = [UIFont systemFontOfSize:15];
    self.lblnoticedate.textColor = [UIColor grayColor];
    
    [self.lbltoncent sizeToFit];
    [self loadstyle];
     NSLog(@"%@",@"viewDidLoad-detail-bgn");
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
//    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
//    [self presentViewController:navigationController animated:YES completion:nil];
}
-(void)loadstyle{
//    _lblthem.textColor = [UIColor grayColor];
//    _lblthem.font=kFont_Lable_14;
 
//    _lblthem.backgroundColor = kColor_Cyan;
    //注册自定义 cell
  
    
    [_lblthem mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_ColSize);
        // 添加大小约束
        //make.size.mas_equalTo(CGSizeMake(Common_UserImageSize,Common_UserImageSize));
    }];
    [_lblgroup mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_ColSize+Common_RowSize-5);
    }];
    [_lblnoticedate mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_ColSize+Common_RowSize*2-10);
    }];
    _lbltoncent.preferredMaxLayoutWidth = kScreenWidth-Common_ColSize*2;//宽度设置
    [_lbltoncent setContentHuggingPriority:UILayoutPriorityRequired     forAxis:UILayoutConstraintAxisVertical];
    _lbltoncent.numberOfLines = 0;
    [_lbltoncent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_ColSize*2+Common_RowSize*3-15);    }];

}
-(IBAction)onClickButtonreturn:(id)sender {
 
    NSLog(@"%@", @"return");
    [self dismissViewControllerAnimated:YES completion:nil];//返回上一页面
    //[tableview reloadData];
    
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
