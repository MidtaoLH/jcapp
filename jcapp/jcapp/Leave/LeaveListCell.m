//
//  LeaveListCell.m
//  jcapp
//
//  Created by zclmac on 2019/12/2.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "LeaveListCell.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#define kMargin 10

@interface LeaveListCell()

@property (nonatomic, strong) UILabel *leaveDateLable;
@property (nonatomic, strong) UILabel *beignDateLable;
@property (nonatomic, strong) UILabel *endDateLable;
@property (nonatomic, strong) UILabel *leaveTypeLable;
@property (nonatomic, strong) UILabel *leaveStatusLable;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation LeaveListCell


 - (UILabel *)leaveStatusLable {
 
 if (!_leaveStatusLable) {
 _leaveStatusLable = [[UILabel alloc] init];
 _leaveStatusLable.font = [UIFont systemFontOfSize:15];
     _leaveStatusLable.textColor = Color_ProcessStutasColor;
 }
 return _leaveStatusLable;
 }

- (UILabel *)leaveDateLable {
    
    if (!_leaveDateLable) {
        _leaveDateLable = [[UILabel alloc] init];
        _leaveDateLable.font = [UIFont systemFontOfSize:15];
        _leaveDateLable.textColor = [UIColor grayColor];
    }
    return _leaveDateLable;
}
- (UILabel *)beignDateLable {
    
    if (!_beignDateLable) {
        _beignDateLable = [[UILabel alloc] init];
        _beignDateLable.font = [UIFont systemFontOfSize:15];
        _beignDateLable.textColor = [UIColor grayColor];
    }
    return _beignDateLable;
}

- (UILabel *)endDateLable {
    
    if (!_endDateLable) {
        _endDateLable = [[UILabel alloc] init];
        _endDateLable.font = [UIFont systemFontOfSize:15];
        _endDateLable.textColor = [UIColor grayColor];
    }
    return _endDateLable;
}
- (UILabel *)leaveTypeLable {
    
    if (!_leaveTypeLable) {
        _leaveTypeLable = [[UILabel alloc] init];
        _leaveTypeLable.font = [UIFont systemFontOfSize:15];
        _leaveTypeLable.textColor = [UIColor grayColor];
    }
    return _leaveTypeLable;
}


//自定义cell 需要重写的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
        [self.contentView addSubview:self.endDateLable];
        [self.contentView  addSubview:self.leaveTypeLable];
        [self.contentView  addSubview:self.beignDateLable];
        [self.contentView  addSubview:self.leaveStatusLable];
        [self.contentView  addSubview:self.leaveDateLable];
    }
    return self;
}

-(void)setLeavelistitem:(LeaveListModel *)leavelistitem
{
    _leavelistitem =leavelistitem;
    self.textLabel.text = _leavelistitem.ApplyFileName;
    
    self.leaveDateLable.text = _leavelistitem.ApplyDate;
 
    self.leaveStatusLable.text = _leavelistitem.ProcessStutasName;
    if([_leavelistitem.ProcessStutasName  isEqualToString:  @"已驳回"])
    {
        _leaveStatusLable.textColor = [UIColor redColor];
    }
 
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,_leavelistitem.U_LoginName];
    [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString]];
    self.imageView.image=imageView.image;
    
    NSString * strbegindate =[[NSString alloc]initWithFormat:@"%@%@",@"开始时间：",_leavelistitem.BeginDate];
 
    self.beignDateLable.text = strbegindate;
    
    NSString * strendate =[[NSString alloc]initWithFormat:@"%@%@",@"结束时间：",_leavelistitem.EndDate];
    
    self.endDateLable.text = strendate;
    
     NSString * strLeaveTypeTxt =[[NSString alloc]initWithFormat:@"%@%@",@"请假类型：",_leavelistitem.LeaveTypeName];
    
    self.leaveTypeLable.text = strLeaveTypeTxt;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat imageWH=  width/4;
    CGFloat leaveDateWidth = 80;
    //每行的文本的高度
    CGFloat txtH = (height - 6*kMargin)/4;
    
    self.imageView.frame = CGRectMake(kMargin,(height - 2*kMargin-imageWH)/2, imageWH, imageWH );
    
    //申请日期
    self.leaveDateLable.frame = CGRectMake(width-leaveDateWidth-kMargin,kMargin, leaveDateWidth, txtH);
    
    self.textLabel.frame = CGRectMake(2*kMargin+imageWH,kMargin, imageWH*2, txtH);
    
    self.leaveTypeLable.frame = CGRectMake(2*kMargin+imageWH, txtH+1.1*kMargin , width - leaveDateWidth - kMargin - imageWH, txtH);
    
    self.beignDateLable.frame = CGRectMake(2*kMargin+imageWH, 2*txtH+2.1*kMargin , width - leaveDateWidth - kMargin - imageWH, txtH);
    
    self.endDateLable.frame = CGRectMake(2*kMargin+imageWH, 3*txtH+3.1*kMargin  , width - leaveDateWidth - kMargin - imageWH, txtH);
    
    self.leaveStatusLable.frame = CGRectMake(2*kMargin+imageWH, 4*txtH+4.1*kMargin , width - leaveDateWidth - kMargin - imageWH, txtH);
 
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
