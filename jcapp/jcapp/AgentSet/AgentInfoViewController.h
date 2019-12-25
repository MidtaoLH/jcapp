//
//  AgentInfoViewController.h
//  jcapp
//
//  Created by lh on 2019/12/23.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/BRInfoModel.h"
#import "../Model/AgentInfo.h"
#import "BRPickerView.h"
#import "AgentInfoCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface AgentInfoViewController : UIViewController
{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
}
@property (nonatomic, strong) BRDatePickerView *datePickerView;
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong) BRInfoModel *infoModel;
@property (nonatomic, strong) AgentInfo *agentInfo;
@property (nonatomic, assign) NSInteger nameSelectIndex;
@property (nonatomic, strong) NSDate *startdaySelectDate;
@property (nonatomic, strong) NSDate *enddaySelectDate;
@property (weak, nonatomic) IBOutlet UIButton *stopbtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
