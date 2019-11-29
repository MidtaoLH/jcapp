//
//  VatcationMainViewController.h
//  jcapp
//
//  Created by zhaodan on 2019/11/26.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VatcationMainViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate>{
    
    IBOutlet UITableView *tableviewtype;
    IBOutlet UITableView *tableviewstart;
    IBOutlet UITableView *tableviewend;
    IBOutlet UITableView *tableviewtime;
    IBOutlet UITextView *textviewreason;
    IBOutlet UIDatePicker *datepick;
    IBOutlet UITextField    *txttime;
    IBOutlet UIImageView *imageview;
    UIDatePicker*datePicker;
    NSLocale*datelocale;
    
}

@property (nonatomic, retain)IBOutlet UITableView *textviewreason;

@property (nonatomic, retain)IBOutlet UITextField *txttime;

@property (nonatomic, retain)IBOutlet UIImageView *imageview;

-(IBAction)onClickButtonnext:(id)sender;

-(IBAction)textFieldDoneEditing:(id)sender;

-(IBAction)backgroundTap:(id)sender;


@end

NS_ASSUME_NONNULL_END
