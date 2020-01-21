//
//  GoOutDetailCell.h
//  jcapp
//
//  Created by zclmac on 2019/12/18.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Model/MdlEvectionDetail.h"


NS_ASSUME_NONNULL_BEGIN

@interface GoOutDetailCell : UITableViewCell
{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    NSString *iosid;
    NSString *userID;
}
@property (nonatomic,strong) MdlEvectionDetail * leavedetail;

@end

NS_ASSUME_NONNULL_END
