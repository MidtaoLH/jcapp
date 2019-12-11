//
//  BusinessTripEditViewController.h
//  jcapp
//
//  Created by youkare on 2019/12/11.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessTripEditViewController : UIViewController
{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *userID;
    NSString *empID;
    NSString *currentTagName;
}
@end

NS_ASSUME_NONNULL_END
