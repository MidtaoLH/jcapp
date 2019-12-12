//
//  AttendanceSummaryViewController.h
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YUFoldingTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface AttendanceSummaryViewController :  UIViewController  <YUFoldingTableViewDelegate>
{
    NSString *infoString;
    NSMutableDictionary *userinfo;
    NSString *infocurrentTagName;
    NSString *infocurrentValue;
    NSString *inforesultString;
    NSString *allString;
    
    NSString *groupname;
    NSString *empname;
    NSString *empID;
    NSString *userID;
}
@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;

@property (nonatomic, assign) NSInteger index;
@end
NS_ASSUME_NONNULL_END
