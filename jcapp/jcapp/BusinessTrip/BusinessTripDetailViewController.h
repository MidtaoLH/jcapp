//
//  BusinessTripDetailViewController.h
//  jcapp
//
//  Created by zhaodan on 2019/12/24.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessTripDetailViewController : UIViewController{
    
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
     NSString *userID;
    NSString *iosid;
}
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *processInstanceID;

@property (nonatomic,copy) NSString *awardID_FK;

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

@property (weak, nonatomic) IBOutlet UILabel *lblleaveddr;

@property (strong,nonatomic) NSMutableArray *listdetail;
@property (strong,nonatomic) NSMutableArray *listhead;
@property (strong,nonatomic) NSMutableArray *listtask;

@property (weak, nonatomic) IBOutlet UIButton *btncancle;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@property (strong,nonatomic) NSMutableArray *listAnnex;

@end

NS_ASSUME_NONNULL_END
