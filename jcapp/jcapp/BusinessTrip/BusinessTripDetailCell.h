//
//  BusinessTripDetailCell.h
//  jcapp
//
//  Created by zhaodan on 2019/12/24.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "../Model/MdlEvectionDetail.h"


NS_ASSUME_NONNULL_BEGIN

@interface BusinessTripDetailCell : UITableViewCell{
    
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    NSString *userID;
    NSString *iosid;
}

@property (nonatomic,strong) MdlEvectionDetail * leavedetail;

@end

NS_ASSUME_NONNULL_END
