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
    
     IBOutlet UITableView *tableview;
     NSMutableArray *wayArray;
     NSMutableDictionary *info;
     NSString *xmlString;
    
}
@property (weak, nonatomic) IBOutlet UITableView *NewTableView;

// 添加数据源
@property (strong,nonatomic) NSMutableArray *listOfWay;


@end

NS_ASSUME_NONNULL_END
