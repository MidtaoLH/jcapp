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
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    
    NSString *groupname;
    NSString *empname;
    NSString *empID;
    NSString *userID;
}
// 添加数据源
@property (strong,nonatomic) NSMutableArray *listOfMovies;
@property (strong,nonatomic) NSMutableArray *listOfMoviesDetail;
@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;

@property (nonatomic, assign) NSInteger index;
@end
NS_ASSUME_NONNULL_END
