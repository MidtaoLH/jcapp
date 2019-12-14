//
//  PendingListCell.m
//  jcapp
//
//  Created by lh on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "BusinessTripPlaceCell.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#define kMargin 10

@interface BusinessTripPlaceCell()
@property (nonatomic, strong) UILabel *requiredSign;
@property (nonatomic, strong) UILabel *placeLable;
@property (nonatomic, strong) UITextField *placeEdit;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation BusinessTripPlaceCell

- (UILabel *)requiredSign {
    
    if (!_requiredSign) {
        _requiredSign = [[UILabel alloc] init];
        _requiredSign.font = kFont_Lable_12;
        _requiredSign.textColor = kColor_Gray;
    }
    return _requiredSign;
}
- (UILabel *)placeLable {
    
    if (!_placeLable) {
        _placeLable = [[UILabel alloc] init];
        _placeLable.font = kFont_Lable_13;
        _placeLable.textColor = kColor_Gray;
    }
    return _placeLable;
}
- (UITextField *)placeEdit {
    
    if (!_placeEdit) {
        _placeEdit = [[UITextField alloc] init];
        _placeEdit.font = kFont_Lable_13;
        _placeEdit.textColor =kColor_Gray;
    }
    return _placeEdit;
}
- (UIButton *)addBtn {
    
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
    }
    return _addBtn;
}

- (UIButton *)deleteBtn {
    
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
    }
    return _addBtn;
}
//自定义cell 需要重写的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.requiredSign];
//        [self.contentView  addSubview:self.placeLable];
//        [self.contentView  addSubview:self.placeEdit];
//        [self.contentView  addSubview:self.addBtn];
//        [self.contentView  addSubview:self.deleteBtn];
    }
    return self;
}

-(void)setPlacelistitem:(Pending *)placelistitem
{
    self.requiredSign.text = @"必";
    
//    self.placeLable.text = @"出差地点";
//    self.placeEdit.text = @"ru";
//    [self.addBtn setTitle:@"+" forState:0];
//    [self.deleteBtn setTitle:@"-" forState:0];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat imageWH=  width/5;
    CGFloat leaveDateWidth = 80;
    //每行的文本的高度
    self.requiredSign.frame = CGRectMake(kMargin,kMargin, 10, 50);
    self.placeLable.frame = CGRectMake(2*kMargin+10, kMargin, 40, 50);
    self.placeEdit.frame = CGRectMake(3*kMargin+50, kMargin, 40, 50);
    self.addBtn.frame = CGRectMake(4*kMargin+90, kMargin, 40, 50);
    self.deleteBtn.frame = CGRectMake(5*kMargin+110, kMargin, 40, 50);
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
