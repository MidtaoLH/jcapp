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
}

@property (nonatomic, retain)IBOutlet UIButton *chosebutton;
@property (strong,nonatomic) NSMutableArray *listOfGroup;
@property (strong,nonatomic) NSMutableArray *listOfEmp;
@property (nonatomic, retain)IBOutlet NSString *lbgroupname;
@property (nonatomic, retain)IBOutlet NSString *lbempname;
@property (nonatomic, retain)IBOutlet NSString *lbgroupid;
@property (nonatomic, retain)IBOutlet NSString *lbempid;
@property (nonatomic, retain)IBOutlet NSString *lbempenglistname;
@end

