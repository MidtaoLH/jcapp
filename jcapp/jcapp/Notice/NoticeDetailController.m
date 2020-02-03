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
#import "NotiInfoCell.h"
#define kLeftMargin 14
@interface NoticeDetailController ()

@end

@implementation NoticeDetailController

@synthesize noticeitem;



- (void)viewDidLoad {
    [super viewDidLoad];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
     self.navigationItem.title=@"公告查看";
    //self.lblnoticedate.text =  [@"发布时间：" stringByAppendingString: noticeitem.NewsDate];
    
    //self.lblthem.text = noticeitem.NewsTheme;
    
    //self.lbltoncent.text = noticeitem.NewsContent;
    
    //elf.lblgroup.text = noticeitem.G_CName;
    //设置换行
    [self loadstyle];
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
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(0);
        // 添加上
        make.top.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,kScreenHeight));
    }];

}
-(IBAction)onClickButtonreturn:(id)sender {
 
    NSLog(@"%@", @"return");
    [self dismissViewControllerAnimated:YES completion:nil];//返回上一页面
    //[tableview reloadData];
    
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"agentInfoCell";
    NotiInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NotiInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *arr= self.titleArr[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text= self.noticeitem.NewsTheme;
            cell.deptLabel.text= self. noticeitem.G_CName;
            cell.dateLabel.text= [@"发布时间：" stringByAppendingString: self. noticeitem.NewsDate];
            cell.pageindex=0;
        }
            break;
        case 1:
        {
             cell.contextLabel.text= self. noticeitem.NewsContent;
             NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]};
             _labelSize = [cell.contextLabel.text boundingRectWithSize:CGSizeMake(200, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
             cell.contextLabel.frame = CGRectMake(kLeftMargin, 0, kScreenWidth-kLeftMargin*2, _labelSize.height);
            [cell.contextLabel sizeToFit];
            cell.pageindex=1;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0)
        return 100.0f;
    else if(indexPath.row==1 )
         return _labelSize.height;
    else
         return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    [self handlerTextFieldSelect:textField];
    return NO; // 当前 textField 不可编辑，可以响应点击事件
}
#pragma mark - 处理点击事件
- (void)handlerTextFieldSelect:(UITextField *)textField {
    
}
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"", @""];
        return _titleArr;
    }
    return _titleArr;
}

//解决tableview线不对的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
//解决tableview线不对的问题
- (void)viewDidLayoutSubviews
{
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableview setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
