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


@property (strong,nonatomic) NSMutableArray *listdetail;
@property (strong,nonatomic) NSMutableArray *listhead;
@property (strong,nonatomic) NSMutableArray *listtask;

 @property (nonatomic, copy) NSString *strTaskid;

 @property (nonatomic, copy) NSString *taskType;

@end

NS_ASSUME_NONNULL_END
