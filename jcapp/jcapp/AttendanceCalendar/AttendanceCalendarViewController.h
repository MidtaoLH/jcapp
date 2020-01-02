//
//  AttendanceCalendarViewController.h
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Calendar/WHUCalendarView.h"
NS_ASSUME_NONNULL_BEGIN

@interface AttendanceCalendarViewController : UIViewController
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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet WHUCalendarView *calview;
@property (weak, nonatomic) IBOutlet UILabel *lblname;
@property (weak, nonatomic) IBOutlet UILabel *lbldept;
@property (weak, nonatomic) IBOutlet UIImageView *myHeadPortrait;
@end
NS_ASSUME_NONNULL_END
