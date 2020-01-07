//
//  LeaveViewController.h
//  jcapp
//
//  Created by zclmac on 2019/11/29.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaitingApplyViewController : UIViewController
{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    NSString *userID;
    NSString *empID; 
    NSMutableArray *array;
    NSMutableArray *array2;
    NSInteger _page;
    NSInteger _pageSize;
    NSString *deletetype;
}

@property (weak, nonatomic) IBOutlet UITableView *NewTableView;

// 添加数据源
@property (strong,nonatomic) NSMutableArray *listOfMovies;

@end


NS_ASSUME_NONNULL_END
