//
//  NewViewController.h
//  jcapp
//
//  Created by zclmac on 2019/11/25.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
 
    NSInteger currentPageCount;
    
    NSString *groupid;
    NSString *empname;
    NSString *empID;
    NSString *userID;
    NSString *UserHour;
}
@property (weak, nonatomic) IBOutlet UITableView *NewTableView;

// 添加数据源
@property (strong,nonatomic) NSMutableArray *listOfMovies;

@end

NS_ASSUME_NONNULL_END
