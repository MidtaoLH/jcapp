//
//  ViewController.h
//  弹框二级选择
//
//  Created by 小菊花 on 17/1/11.
//  Copyright © 2017年 com.qiji.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddWayView : UIViewController{
    
    NSString *xmlString;
    NSString *stringflag;
    NSMutableDictionary *info;
    
    IBOutlet UILabel    *lbgroupname;
    IBOutlet UILabel    *lbempname;
    
    IBOutlet UILabel    *lbgroupid;
    IBOutlet UILabel    *lbempid;
    
}

@property (nonatomic, retain)IBOutlet UIButton *chosebutton;
@property (nonatomic, retain)IBOutlet UIButton *savebutton;

@property (strong,nonatomic) NSMutableArray *listOfGroup;
@property (strong,nonatomic) NSMutableArray *listOfEmp;

@property (nonatomic, retain)IBOutlet UILabel *lbgroupname;
@property (nonatomic, retain)IBOutlet UILabel *lbempname;

@property (nonatomic, retain)IBOutlet UILabel *lbgroupid;
@property (nonatomic, retain)IBOutlet UILabel *lbempid;

-(IBAction)onClickButtonchose:(id)sender;
-(IBAction)onClickButtonsave:(id)sender;
@end

