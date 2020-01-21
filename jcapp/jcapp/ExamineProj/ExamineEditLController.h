//
//  LeaveDetailController.h
//  jcapp
//
//  Created by zclmac on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface ExamineEditLController : UIViewController
{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    NSString *userid;
    NSString *iosid;
}
@property (weak, nonatomic) IBOutlet UITableView *NewTableView;
@property (weak, nonatomic) IBOutlet UITableView *ImageTableView;
@property (weak, nonatomic) IBOutlet UILabel *emplbl;
@property (weak, nonatomic) IBOutlet UILabel *lblempgroup;
@property (weak, nonatomic) IBOutlet UILabel *lblapplydate;
@property (weak, nonatomic) IBOutlet UIImageView *imgvemp;
@property (weak, nonatomic) IBOutlet UILabel *lblleavetype;
@property (weak, nonatomic) IBOutlet UILabel *lblleavedate;
@property (weak, nonatomic) IBOutlet UILabel *lblleavecounts;
@property (weak, nonatomic) IBOutlet UILabel *lblleaveremark;
@property (weak, nonatomic) IBOutlet UIImageView *imgvleavestatus;
@property (weak, nonatomic) IBOutlet UILabel *lblleavestatus;
@property (weak, nonatomic) IBOutlet UITextView *txtvexamineremark;
@property (weak, nonatomic) IBOutlet UIButton *btntaskno;
@property (weak, nonatomic) IBOutlet UIButton *buttaskyes;
@property (weak, nonatomic) IBOutlet UILabel *lblcryj;
@property (weak, nonatomic) IBOutlet UILabel *lblccdr;
@property (strong,nonatomic) NSMutableArray *listdetail;
@property (strong,nonatomic) NSMutableArray *listhead;
@property (strong,nonatomic) NSMutableArray *listtask;

 @property (nonatomic, copy) NSString *strTaskid;

// 任务类型。0 请假 1 外出 2 出差
 @property (nonatomic, copy) NSString *taskType;

@property (strong,nonatomic) NSMutableArray *listAnnex;

@end

NS_ASSUME_NONNULL_END
