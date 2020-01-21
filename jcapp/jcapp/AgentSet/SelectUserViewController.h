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
     NSString *iosid;
    NSString *userid;
}
@property (nonatomic, retain)IBOutlet UIButton *chosebutton;
@property (strong,nonatomic) NSMutableArray *listOfGroup;
@property (strong,nonatomic) NSMutableArray *listOfEmp;
@property (nonatomic, retain)IBOutlet NSString *lbgroupname;
@property (nonatomic, retain)IBOutlet NSString *lbempname;
@property (nonatomic, retain)IBOutlet NSString *lbgroupid;
@property (nonatomic, retain)IBOutlet NSString *lbempid;

@end

NS_ASSUME_NONNULL_END
