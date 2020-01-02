//
//  AlterPWDController.h
//  jcapp
//
//  Created by lh on 2019/11/24.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/pwdInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface AlterPWDController : UIViewController
{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
}
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong) pwdInfo *infoModel;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
