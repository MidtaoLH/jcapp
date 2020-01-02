//
//  AgentInfoCell.h
//  jcapp
//
//  Created by lh on 2019/12/24.
//  Copyright © 2019 midtao. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface AgentInfoCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *statusDateLabel;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, assign) BOOL isTitle;

@end
