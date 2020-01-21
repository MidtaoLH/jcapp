//
//  LeaveDetailController.h
//  jcapp
//
//  Created by zclmac on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeaveDetailController : UIViewController
{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    NSString *userID;
        NSString *iosid;
}
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *awardID_FK;
@property (nonatomic,copy) NSString *processInstanceID;
@property (nonatomic,copy) NSString *ProcessApplyCode;

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

@property (strong,nonatomic) NSMutableArray *listdetail;
@property (strong,nonatomic) NSMutableArray *listhead;
@property (strong,nonatomic) NSMutableArray *listtask;
@property (strong,nonatomic) NSMutableArray *listAnnex;
@property (weak, nonatomic) IBOutlet UIButton *btncancle;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@end

NS_ASSUME_NONNULL_END
