//
//  CalendaViewController.h
//  jcapp
//
//  Created by zhaodan on 2019/11/27.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CalendaViewController : UIViewController{
     IBOutlet UIDatePicker *picker;
    NSString *dateStr;
}
-(IBAction)datechanged:(id)sender;
-(IBAction)onClickButton:(id)sender;

@property (nonatomic, retain)IBOutlet UIDatePicker *picker;

@end

NS_ASSUME_NONNULL_END
