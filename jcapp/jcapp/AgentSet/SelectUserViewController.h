//
//  SelectUserViewController.h
//  jcapp
//
//  Created by lh on 2019/12/24.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectUserViewController : UIViewController{
    NSString *xmlString;
    NSString *stringflag;
    
    NSMutableDictionary *info;
    IBOutlet UILabel    *lbgroupname;
    IBOutlet UILabel    *lbempname;
    IBOutlet UILabel    *lbgroupid;
    IBOutlet UILabel    *lbempid;
}
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *agentID;
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

NS_ASSUME_NONNULL_END
