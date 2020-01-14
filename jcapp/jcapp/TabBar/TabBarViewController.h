//
//  AttendanceSummaryTabBarViewController.h
//  jcapp
//
//  Created by lh on 2019/12/5.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../TLAnimationTabBar/TLAnimationTabBar.h"
NS_ASSUME_NONNULL_BEGIN

@interface TabBarViewController : UITabBarController{
    UIView *titleview;
}
/**/
@property (nonatomic,copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
