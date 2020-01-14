//
//  TaskBackInfoViewController.h
//  jcapp
//
//  Created by lh on 2019/12/15.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskBackInfoViewController : UIViewController
{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    NSString *userid;
}
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *taskcode;
@property (nonatomic,copy) NSString *pagetype;
@property (nonatomic,copy) NSString *titletype;
@property (nonatomic,copy) NSString *title;
@property (weak, nonatomic) IBOutlet UITableView *NewTableView;

@property (weak, nonatomic) IBOutlet UITableView *ImageTableView;

@property (weak, nonatomic) IBOutlet UILabel *emplbl;

@property (weak, nonatomic) IBOutlet UILabel *lblempgroup;

@property (weak, nonatomic) IBOutlet UILabel *lblapplydate;

@property (weak, nonatomic) IBOutlet UIImageView *imgvemp;

@property (weak, nonatomic) IBOutlet UILabel *lblproctype;

@property (weak, nonatomic) IBOutlet UILabel *lblprocdate;

@property (weak, nonatomic) IBOutlet UILabel *lblproccounts;

@property (weak, nonatomic) IBOutlet UILabel *lblprocremark;

@property (weak, nonatomic) IBOutlet UIImageView *imgvprocstatus;

@property (weak, nonatomic) IBOutlet UILabel *lblprocstatus;

@property (weak, nonatomic) IBOutlet UILabel *lblcr;

@property (weak, nonatomic) IBOutlet UILabel *lblccdr;

@property (strong,nonatomic) NSMutableArray *listdetail;
@property (strong,nonatomic) NSMutableArray *listtask;
@end

NS_ASSUME_NONNULL_END
