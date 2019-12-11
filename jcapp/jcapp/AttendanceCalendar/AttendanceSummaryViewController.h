//
//  AttendanceSummaryViewController.h
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttendanceSummaryViewController : UIViewController
{
    NSString *infoString;
    NSMutableDictionary *userinfo;
    NSString *infocurrentTagName;
    NSString *infocurrentValue;
    NSString *inforesultString;
    NSString *allString;
}
@end

NS_ASSUME_NONNULL_END
