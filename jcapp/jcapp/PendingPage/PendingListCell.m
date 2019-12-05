//
//  PendingListCell.m
//  jcapp
//
//  Created by lh on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "PendingListCell.h"

#define kMargin 10

@interface PendingListCell()
@property (nonatomic, strong) UILabel *pendingCaseName;
@property (nonatomic, strong) UILabel *pendingDateLable;
@property (nonatomic, strong) UILabel *beignDateLable;
@property (nonatomic, strong) UILabel *endDateLable;
@property (nonatomic, strong) UILabel *pendingTypeLable;
@property (nonatomic, strong) UILabel *pendingStatusLable;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation PendingListCell

- (UILabel *)pendingStatusLable {
    
    if (!_pendingStatusLable) {
        _pendingStatusLable = [[UILabel alloc] init];
        _pendingStatusLable.font = [UIFont systemFontOfSize:14];
        _pendingStatusLable.textColor = Color_ProcessStutasColor;
    }
    return _pendingStatusLable;
}

- (UILabel *)pendingDateLable {
    
    if (!_pendingDateLable) {
        _pendingDateLable = [[UILabel alloc] init];
        _pendingDateLable.font = [UIFont systemFontOfSize:12];
        _pendingDateLable.textColor = [UIColor grayColor];
    }
    return _pendingDateLable;
}
- (UILabel *)beignDateLable {
    
    if (!_beignDateLable) {
        _beignDateLable = [[UILabel alloc] init];
        _beignDateLable.font = [UIFont systemFontOfSize:13];
        _beignDateLable.textColor = [UIColor grayColor];
    }
    return _beignDateLable;
}

- (UILabel *)endDateLable {
    
    if (!_endDateLable) {
        _endDateLable = [[UILabel alloc] init];
        _endDateLable.font = [UIFont systemFontOfSize:13];
        _endDateLable.textColor = [UIColor grayColor];
    }
    return _endDateLable;
}
- (UILabel *)pendingTypeLable {
    
    if (!_pendingTypeLable) {
        _pendingTypeLable = [[UILabel alloc] init];
        _pendingTypeLable.font = [UIFont systemFontOfSize:13];
        _pendingTypeLable.textColor = [UIColor grayColor];
    }
    return _pendingTypeLable;
}


//自定义cell 需要重写的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.endDateLable];
        [self.contentView  addSubview:self.pendingTypeLable];
        [self.contentView  addSubview:self.beignDateLable];
        [self.contentView  addSubview:self.pendingStatusLable];
        [self.contentView  addSubview:self.pendingDateLable];
    }
    return self;
}

-(void)setPendinglistitem:(Pending *)pendinglistitem
{
    _pendinglistitem =pendinglistitem;
    
    self.textLabel.text = _pendinglistitem.CaseName;
    
    self.pendingStatusLable.text = _pendinglistitem.CaseStatusTxt;
    
    self.pendingDateLable.text = _pendinglistitem.CaseDate;
    
    self.imageView.image =[UIImage imageNamed:@"01.jpg"];
    
    self.beignDateLable.text = _pendinglistitem.BeignDate;
    
    self.endDateLable.text = _pendinglistitem.EndDate;
    
    if(_pendinglistitem.CaseTypeTxt!=NULL)
    {
        self.pendingTypeLable.text = [NSString stringWithFormat:@"请假类型:%@",_pendinglistitem.CaseTypeTxt];
    }   
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat imageWH= height - 2*kMargin;
    CGFloat leaveDateWidth = 80;
    //每行的文本的高度
    CGFloat txtH = (height - 6*kMargin)/5;
    self.imageView.frame = CGRectMake(kMargin,kMargin, imageWH, imageWH);
    self.pendingDateLable.frame = CGRectMake(width-leaveDateWidth-kMargin,kMargin, leaveDateWidth, txtH);
    self.pendingTypeLable.frame = CGRectMake(2*kMargin+imageWH, txtH+2*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.beignDateLable.frame = CGRectMake(2*kMargin+imageWH, 2*txtH+3*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.endDateLable.frame = CGRectMake(2*kMargin+imageWH, 3*txtH+4*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.pendingStatusLable.frame = CGRectMake(2*kMargin+imageWH, 4*txtH+5*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.textLabel.frame = CGRectMake(2*kMargin+imageWH,kMargin, imageWH, txtH);
    

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
