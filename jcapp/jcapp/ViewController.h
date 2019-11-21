//
//  ViewController.h
//  jcapp
//
//  Created by lh on 2019/11/15.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    //h文件先定义参数
    IBOutlet UITextField    *txtuser;
    IBOutlet UITextField    *txtpassword;
    
    NSString *xmlString;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    NSMutableDictionary *info;
    
    
    
}
//h文件先设置相应属性
@property (nonatomic, retain)IBOutlet UITextField *txtuser;
@property (nonatomic, retain)IBOutlet UITextField *txtpassword;

//先在h文件写入相应方法
-(IBAction)onClickButton:(id)sender;

-(IBAction)textFieldDoneEditing:(id)sender;

-(IBAction)backgroundTap:(id)sender;

@end

