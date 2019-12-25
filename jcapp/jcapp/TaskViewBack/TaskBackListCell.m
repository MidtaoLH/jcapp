//
//  PendingListCell.m
//  jcapp
//
//  Created by lh on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "TaskBackListCell.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#define kMargin 10

@interface TaskBackListCell()
@property (nonatomic, strong) UILabel *taskBackEmpNameLable;
@property (nonatomic, strong) UILabel *taskBackGroupNameLable;
@property (nonatomic, strong) UILabel *taskBackTypeLable;
@property (nonatomic, strong) UILabel *taskBackDateLable;
@property (nonatomic, strong) UILabel *taskBackRemarkLable;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation TaskBackListCell

- (UILabel *)taskBackEmpNameLable {
    
    if (!_taskBackEmpNameLable) {
        _taskBackEmpNameLable = [[UILabel alloc] init];
        _taskBackEmpNameLable.font = kFont_Lable_14;
        _taskBackEmpNameLable.textColor = kColor_Blue;
    }
    return _taskBackEmpNameLable;
}
- (UILabel *)taskBackGroupNameLable{
    
    if (!_taskBackGroupNameLable) {
        _taskBackGroupNameLable = [[UILabel alloc] init];
        _taskBackGroupNameLable.font = kFont_Lable_12;
        _taskBackGroupNameLable.textColor = kColor_Gray;
    }
    return _taskBackGroupNameLable;
}
- (UILabel *)taskBackTypeLable {
    if (!_taskBackTypeLable)
    {
        _taskBackTypeLable = [[UILabel alloc] init];
        _taskBackTypeLable.font = kFont_Lable_12;
        _taskBackTypeLable.textColor = kColor_Gray;
    }
    return _taskBackTypeLable;
}
- (UILabel *)taskBackDateLable {
    if (!_taskBackDateLable) {
        _taskBackDateLable = [[UILabel alloc] init];
        _taskBackDateLable.font = kFont_Lable_12;
        _taskBackDateLable.textColor =kColor_Gray;
    }
    return _taskBackDateLable;
}
- (UILabel *)taskBackRemarkLable {
    if (!_taskBackRemarkLable) {
        _taskBackRemarkLable = [[UILabel alloc] init];
        _taskBackRemarkLable.font = kFont_Lable_12;
        _taskBackRemarkLable.textColor = kColor_Gray;
    }
    return _taskBackRemarkLable;
}
//自定义cell 需要重写的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.taskBackEmpNameLable];
        [self.contentView addSubview:self.taskBackGroupNameLable];
        [self.contentView addSubview:self.taskBackTypeLable];
        [self.contentView addSubview:self.taskBackDateLable];
        [self.contentView addSubview:self.taskBackRemarkLable];
    }
    return self;
}

-(void)setTaskBacklistitem:(ViewBackTask *)taskBacklistitem
{
    _taskBacklistitem =taskBacklistitem;
    self.taskBackEmpNameLable.text = _taskBacklistitem.TaskEmpCName;
    self.taskBackGroupNameLable.text = _taskBacklistitem.TaskEmpGroupName;
    self.taskBackTypeLable.text = _taskBacklistitem.TaskNodeLevelNM;
    self.taskBackDateLable.text = _taskBacklistitem.TaskAuditeDate;
    self.taskBackRemarkLable.text = _taskBacklistitem.Remark;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,_taskBacklistitem.UserCode];
    [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString]];
    self.imageView.image=imageView.image;
   
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat imageWH=  width/6;
    CGFloat leaveDateWidth = 80;
    //每行的文本的高度
    CGFloat txtH = (height - 3*kMargin)/4;
    self.taskBackEmpNameLable.frame = CGRectMake(2*kMargin+imageWH, kMargin, leaveDateWidth, txtH);
    self.taskBackTypeLable.frame = CGRectMake(3*kMargin+imageWH+self.taskBackEmpNameLable.width, kMargin, leaveDateWidth, txtH);
    self.taskBackDateLable.frame =CGRectMake(4*kMargin+imageWH+self.taskBackEmpNameLable.width+self.taskBackTypeLable.width, kMargin, leaveDateWidth, txtH);
    self.taskBackGroupNameLable.frame = CGRectMake(2*kMargin+imageWH, txtH+2*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.taskBackRemarkLable.frame = CGRectMake(2*kMargin+imageWH, 2*txtH+3*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.imageView.frame = CGRectMake(kMargin,(height -kMargin-imageWH)/2, imageWH, imageWH );
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = imageWH * 0.5;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
