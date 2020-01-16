//
//  AttendanceListCell.m
//  jcapp
//
//  Created by lh on 2019/12/12.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AttendanceListCell.h"
#import "Masonry.h"
#define kMargin 10

@interface AttendanceListCell()


// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation AttendanceListCell

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


-(void)layoutSubviews
{
    [super layoutSubviews];
    [_attendanceCaseNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth*2, Common_AttendanceTxTHeight));
    }];
    [_attendanceDateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(Common_AttendanceTxTHeight);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth*2, Common_AttendanceTxTHeight));
    }];
    [_attendanceDurationLable mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(Common_AttendanceTxTHeight*2);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth*2, Common_AttendanceTxTHeight));
    }];
    [_attendanceDescribeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(Common_AttendanceTxTHeight*3);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth*2, Common_AttendanceTxTHeight));
    }];
}
- (UILabel *)attendanceCaseNameLable {
    
    if (!_attendanceCaseNameLable) {
        _attendanceCaseNameLable = [[UILabel alloc] init];
        _attendanceCaseNameLable.backgroundColor = [UIColor clearColor];        
        _attendanceCaseNameLable.font = kFont_Lable_14;
        _attendanceCaseNameLable.textColor = kColor_Blue;
    }
    return _attendanceCaseNameLable;
}
- (UILabel *)attendanceDateLable {
    
    if (!_attendanceDateLable) {
        _attendanceDateLable= [[UILabel alloc] init];
        _attendanceDateLable.backgroundColor = [UIColor clearColor];
        _attendanceDateLable.font = kFont_Lable_13;
        _attendanceDateLable.textColor = kColor_Gray;
    }
    return _attendanceDateLable;
}
- (UILabel *)attendanceDurationLable {
    
    if (!_attendanceDurationLable) {
        _attendanceDurationLable = [[UILabel alloc] init];
        _attendanceDurationLable.backgroundColor = [UIColor clearColor];
        _attendanceDurationLable.font = kFont_Lable_13;
        _attendanceDurationLable.textColor = kColor_Gray;
    }
    return _attendanceDurationLable;
}
- (UILabel *)attendanceDescribeLable {
    
    if (!_attendanceDescribeLable) {
        _attendanceDescribeLable = [[UILabel alloc] init];
        _attendanceDescribeLable.backgroundColor = [UIColor clearColor];
        _attendanceDescribeLable.font = kFont_Lable_13;
        _attendanceDescribeLable.textColor =kColor_Gray;
    }
    return _attendanceDescribeLable;
}
@end
