//
//  ApprovedViewController.h
//  jcapp
//
//  Created by youkare on 2019/12/2.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BWaitApplyViewController : UIViewController
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
        NSString *iosid;
}

@property (weak, nonatomic) IBOutlet UITableView *NewTableView;
@property (strong, nonatomic) UIAlertAction *okAction;
@property (strong, nonatomic) UIAlertAction *cancelAction;
// 添加数据源
@property (strong,nonatomic) NSMutableArray *listOfMovies;

@end

NS_ASSUME_NONNULL_END
