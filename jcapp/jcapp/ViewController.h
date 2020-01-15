//
//  ViewController.h
//  jcapp
//
//  Created by lh on 2019/11/15.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    //h文件先定义参数
    IBOutlet UITextField    *txtuser;
    IBOutlet UITextField    *txtpassword;
    IBOutlet UITextField    *txttest;
    
    
    NSString *xmlString;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    NSMutableDictionary *info;
    
    
    
}
//h文件先设置相应属性
@property (nonatomic, retain)IBOutlet UITextField *txtuser;
@property (nonatomic, retain)IBOutlet UITextField *txtpassword;

@property (nonatomic, retain)IBOutlet UITextField *txttest;

@property (weak, nonatomic) IBOutlet UIImageView *myHeadPortrait;
@property (weak, nonatomic) IBOutlet UITableView *usernamelist;

// 添加数据源
@property (strong,nonatomic) NSMutableArray *listOfUser;


//先在h文件写入相应方法
-(IBAction)onClickButton:(id)sender;

-(IBAction)onClickButtontest:(id)sender;

-(IBAction)onClickButtonChose:(id)sender;

-(IBAction)onClickButtonLeave:(id)sender;

-(IBAction)textFieldDoneEditing:(id)sender;

-(IBAction)backgroundTap:(id)sender;

@end

