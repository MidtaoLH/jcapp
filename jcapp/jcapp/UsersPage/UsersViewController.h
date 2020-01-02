//
//  UsersViewController.h
//  jcapp
//
//  Created by lh on 2019/11/20.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UsersViewController : UIViewController
{
    NSString *infoString;
    NSMutableDictionary *userinfo;
    NSString *infocurrentTagName;
    NSString *infocurrentValue;
    NSString *inforesultString;
    NSString *allString;
    NSString *groupname;
    NSString *empname;
    NSString *empID;
    NSString *userID;
    NSString *code;
    NSString *username;
}
@property (weak, nonatomic) IBOutlet UILabel *lblname;
@property (weak, nonatomic) IBOutlet UILabel *lblcode;
@property (weak, nonatomic) IBOutlet UILabel *lbldept;
@property (weak, nonatomic) IBOutlet UITableView *userslist;
@property (weak, nonatomic) IBOutlet UIImageView *myHeadPortrait;
@property (weak, nonatomic) IBOutlet UIButton *btnloginout;
@property (nonatomic, strong) NSMutableData *mResponseData;
@end

NS_ASSUME_NONNULL_END
