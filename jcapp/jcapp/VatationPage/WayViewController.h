//
//  WayViewController.h
//  jcapp
//
//  Created by zhaodan on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WayViewController : UIViewController <UITableViewDataSource,
UITableViewDelegate>{
    
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
    
}
@property (weak, nonatomic) IBOutlet UITableView *NewTableView;

// 添加数据源
@property (strong,nonatomic) NSMutableArray *listOfWay;

@property (nonatomic, retain)IBOutlet UIButton *savebutton;


-(IBAction)onClickButtonsave:(id)sender;
@end

NS_ASSUME_NONNULL_END
