//
//  LeaveListCell.m
//  jcapp
//
//  Created by zclmac on 2019/12/2.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "ApplyListCell.h"

#define kMargin 10

@interface ApplyListCell()

@property (nonatomic, strong) UILabel *leaveDateLable;
@property (nonatomic, strong) UILabel *beignDateLable;
@property (nonatomic, strong) UILabel *endDateLable;
@property (nonatomic, strong) UILabel *leaveTypeLable;
@property (nonatomic, strong) UILabel *leaveStatusLable;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation ApplyListCell


 - (UILabel *)leaveStatusLable {
 
 if (!_leaveStatusLable) {
 _leaveStatusLable = [[UILabel alloc] init];
 _leaveStatusLable.font = [UIFont systemFontOfSize:15];
 _leaveStatusLable.textColor = [UIColor grayColor];
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
    
    self.textLabel.text = @"李四提交的请假";
    
    self.leaveStatusLable.text = @"承认中";
    
    self.leaveDateLable.text = @"2019.12.12";
    
    self.imageView.image =[UIImage imageNamed:@"01.jpg"];
    
    self.beignDateLable.text = @"开始时间:2019.12.12";
    
    self.endDateLable.text = @"结束时间:2019.12.12";
    
    self.leaveTypeLable.text = @"请假类型:事假";
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat 	width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat imageWH= height - 2*kMargin;
   
    CGFloat leaveDateWidth = 80;
    
    //每行的文本的高度
    CGFloat txtH = (height - 6*kMargin)/5;
    
    self.imageView.frame = CGRectMake(kMargin,kMargin, imageWH, imageWH);
    
    self.leaveDateLable.frame = CGRectMake(width-leaveDateWidth-kMargin,kMargin, leaveDateWidth, txtH);
    
    self.textLabel.frame =CGRectMake(2 * kMargin + imageWH, kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    
    self.leaveTypeLable.frame = CGRectMake(2*kMargin+imageWH, txtH+2*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    
    self.beignDateLable.frame = CGRectMake(2*kMargin+imageWH, 2*txtH+3*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    
    self.endDateLable.frame = CGRectMake(2*kMargin+imageWH, 3*txtH+4*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    
    self.leaveStatusLable.frame = CGRectMake(2*kMargin+imageWH, 4*txtH+5*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
 
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
