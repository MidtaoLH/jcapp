//
//  AttendanceListCell.m
//  jcapp
//
//  Created by lh on 2019/12/12.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AttendanceListCell.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#define kMargin 10

@interface AttendanceListCell()
@property (nonatomic, strong) UILabel *attendanceCaseNameLable;
@property (nonatomic, strong) UILabel *attendanceDateLable;
@property (nonatomic, strong) UILabel *attendanceDurationLable;
@property (nonatomic, strong) UILabel *attendanceDescribeLable;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation AttendanceListCell

- (UILabel *)attendanceCaseNameLable {
    
    if (!_attendanceCaseNameLable) {
        _attendanceCaseNameLable = [[UILabel alloc] init];
        _attendanceCaseNameLable.font = kFont_Lable_14;
        _attendanceCaseNameLable.textColor = kColor_Blue;
    }
    return _attendanceCaseNameLable;
}
- (UILabel *)attendanceDateLable {
    
    if (!_attendanceDateLable) {
        _attendanceDateLable= [[UILabel alloc] init];
        _attendanceDateLable.font = kFont_Lable_13;
        _attendanceDateLable.textColor = kColor_Gray;
    }
    return _attendanceDateLable;
}
- (UILabel *)attendanceDurationLable {
    
    if (!_attendanceDurationLable) {
        _attendanceDurationLable = [[UILabel alloc] init];
        _attendanceDurationLable.font = kFont_Lable_13;
        _attendanceDurationLable.textColor = kColor_Gray;
    }
    return _attendanceDurationLable;
}
- (UILabel *)attendanceDescribeLable {
    
    if (!_attendanceDescribeLable) {
        _attendanceDescribeLable = [[UILabel alloc] init];
        _attendanceDescribeLable.font = kFont_Lable_13;
        _attendanceDescribeLable.textColor =kColor_Gray;
    }
    return _attendanceDescribeLable;
}
//自定义cell 需要重写的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.attendanceCaseNameLable];
        [self.contentView addSubview:self.attendanceDateLable];
        [self.contentView addSubview:self.attendanceDurationLable];
        [self.contentView addSubview:self.attendanceDescribeLable];
    }
    return self;
}

-(void)setAttendancelistitem:(AttendanceCalendarDetail *)attendancelistitem
{
    _attendancelistitem =attendancelistitem;
    self.attendanceCaseNameLable.text = _attendancelistitem.PlanType;
    self.attendanceDateLable.text = [NSString stringWithFormat:@"请假时间：%@  ~  %@",_attendancelistitem.PlanStartTime,_attendancelistitem.PlanEndTime];
    self.attendanceDurationLable.text =[NSString stringWithFormat:@"请假时长（h）:%@",_attendancelistitem.PlanNum];
    self.attendanceDescribeLable.text = [NSString stringWithFormat:@"请假事由：%@",_attendancelistitem.Describe];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat leaveDateWidth = 80;
    //每行的文本的高度
    CGFloat txtH = (height - 4*kMargin)/4;
    self.attendanceCaseNameLable.frame = CGRectMake(2*kMargin,kMargin,width, txtH);
    self.attendanceDateLable.frame = CGRectMake(2*kMargin,1*txtH+2*kMargin,width, txtH);
    self.attendanceDurationLable.frame = CGRectMake(2*kMargin,2*txtH+2*kMargin,width, txtH);
    self.attendanceDescribeLable.frame = CGRectMake(2*kMargin,3*txtH+2*kMargin,width, txtH);
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
