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
UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    IBOutlet UITableView *tableviewtype;
    IBOutlet UITableView *tableviewstart;
    IBOutlet UITableView *tableviewend;
    IBOutlet UITableView *tableviewtime;
    IBOutlet UITextView *textviewreason1;
    IBOutlet UIDatePicker *datepick;
    IBOutlet UITextField    *txttime;
    IBOutlet UIImageView *imageview;
    UIDatePicker*datePicker;
    NSLocale*datelocale;
    NSString *flagstring;
    NSString *xmlString;
    NSString *edittype;
     NSMutableDictionary *info;
    
}

@property (nonatomic, retain)IBOutlet UITableView *textviewreason;

@property (nonatomic, retain)IBOutlet UITextField *txttime;

@property (nonatomic, retain)IBOutlet UITextView *textviewreason1;

@property (nonatomic, retain)IBOutlet UIImageView *imageview;

@property (nonatomic, retain)IBOutlet UIButton *waybutton;

// 添加数据源
@property (strong,nonatomic) NSMutableArray *listOfLeave;

-(IBAction)onClickButtonnext:(id)sender;

-(IBAction)textFieldDoneEditing:(id)sender;

-(IBAction)onClickButtonupload:(id)sender;

-(IBAction)backgroundTap:(id)sender;

-(IBAction)onClickButtonapply:(id)sender;

-(IBAction)onClickButtonway:(id)sender;
@end

NS_ASSUME_NONNULL_END
