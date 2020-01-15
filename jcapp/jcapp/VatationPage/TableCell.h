//
//  TableViewCell.h
//  jcapp
//
//  Created by zhaodan on 2019/12/4.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Model/Way.h"


NS_ASSUME_NONNULL_BEGIN

@interface TableCell : UITableViewCell


@property (nonatomic,strong) Way * Waylist;

@property (copy,nonatomic) NSString *index;

@property (strong,nonatomic) NSMutableArray *listOfWay;

@property (nonatomic, copy) NSString *processid;
@property (nonatomic, copy) NSString *vatcationid;
@property (strong, nonatomic) UIAlertAction *okAction;
@property (strong, nonatomic) UIAlertAction *cancelAction;

@end

NS_ASSUME_NONNULL_END
