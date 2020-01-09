//
//  SetAgentViewController.h
//  jcapp
//
//  Created by lh on 2019/12/23.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/BRInfoModel.h"
#import "BRPickerView.h"
#import "BRInfoCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface SetAgentViewController : UIViewController
{
    UIDatePicker*datePickers;
    UIDatePicker*datePickere;
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
}
@property (nonatomic, strong) BRDatePickerView *datePickerView;
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong) BRInfoModel *infoModel;
@property (nonatomic, assign) NSInteger nameSelectIndex;
@property (nonatomic, strong) NSDate *startdaySelectDate;
@property (nonatomic, strong) NSDate *enddaySelectDate;
@property (weak, nonatomic) IBOutlet UIButton *savebtn;
@property (weak, nonatomic) IBOutlet UIButton *applicationbtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

NS_ASSUME_NONNULL_END
