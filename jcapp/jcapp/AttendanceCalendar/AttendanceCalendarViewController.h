//
//  AttendanceCalendarViewController.h
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../BSLCalendar/BSLCalendar.h"
NS_ASSUME_NONNULL_BEGIN

@interface AttendanceCalendarViewController : UIViewController
{
    NSString *infoString;
    NSMutableDictionary *userinfo;
    NSString *infocurrentTagName;
    NSString *infocurrentValue;
    NSString *inforesultString;
    NSString *allString;
}
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
