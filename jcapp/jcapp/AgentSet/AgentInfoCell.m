
#import "AgentInfoCell.h"
#import "BRPickerViewMacro.h"
#import "Masonry.h"
#define kLeftMargin 14
#define kRowHeight 50

@interface AgentInfoCell ()
@property (nonatomic, strong) UIImageView *nextImageView;

@end

@implementation AgentInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.statusDateLabel];
        [self.contentView addSubview:self.image];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
   
    if (self.isTitle) {
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            // 添加左
            make.left.mas_equalTo(Common_ColSize);
            // 添加上
            make.top.mas_equalTo(0);
            // 添加大小约束
            make.size.mas_equalTo(CGSizeMake(Common_TxTWidth, Common_TxTHeight));
        }];
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            // 添加左
            make.left.mas_equalTo(Common_ColSize);
            // 添加上
            make.top.mas_equalTo(Common_TxTHeight);
            // 添加大小约束
            make.size.mas_equalTo(CGSizeMake(Common_TxTWidth, Common_TxTHeight));
        }];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            // 添加左
            make.left.mas_equalTo(Common_ColSize);
            // 添加上
            make.top.mas_equalTo(Common_TxTHeight*2);
            // 添加大小约束
            make.size.mas_equalTo(CGSizeMake(Common_TxTWidth*2, Common_TxTHeight));
        }];
        
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            // 添加左
            make.left.mas_equalTo(kScreenWidth*0.75);
            // 添加上
            make.top.mas_equalTo(0);
            // 添加大小约束
            make.size.mas_equalTo(CGSizeMake(Common_StatusImageSize, Common_StatusImageSize));
        }];
        _image.layer.cornerRadius = _image.width * 0.5;
        _image.alpha =0.5;
        [_statusDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            // 添加左
            make.left.mas_equalTo(kScreenWidth*0.75);
            // 添加上
            make.top.mas_equalTo(0);
            // 添加大小约束
            make.size.mas_equalTo(CGSizeMake(Common_StatusImageSize, Common_StatusImageSize));
        }];
    }
    else{
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            // 添加左
            make.left.mas_equalTo(Common_ColSize);
            // 添加上
            make.top.mas_equalTo(0);
            // 添加大小约束
            make.size.mas_equalTo(CGSizeMake(Common_TxTWidth*2, Common_TxTHeight));
        }];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            // 添加左
            make.left.mas_equalTo(Common_ColSize);
            // 添加上
            make.top.mas_equalTo(Common_TxTHeight);
            // 添加大小约束
            make.size.mas_equalTo(CGSizeMake(Common_TxTWidth*2, Common_TxTHeight));
        }];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [_statusDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }
    
    
   
}
- (UILabel *)statusDateLabel {
    if (!_statusDateLabel) {
        _statusDateLabel = [[UILabel alloc]init];
        _statusDateLabel.backgroundColor = [UIColor clearColor];
        if (@available(iOS 13.0, *)) {
            //_titleLabel.textColor = [UIColor labelColor];
        } else {
            _statusDateLabel.textColor =[UIColor blackColor];
        }
        _statusDateLabel.font = kFont_LableBold_18;
        _statusDateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusDateLabel;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        if (@available(iOS 13.0, *)) {
            //_titleLabel.textColor = [UIColor labelColor];
        } else {
            _titleLabel.textColor = [UIColor blackColor];
        }
        _titleLabel.font = kFont_LableBold_18;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        if (@available(iOS 13.0, *)) {
            //_titleLabel.textColor = [UIColor labelColor];
        } else {
            _infoLabel.textColor = [UIColor blackColor];
        }
        _infoLabel.font = kFont_Lable_15;
        _infoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _infoLabel;
}
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.backgroundColor = [UIColor clearColor];
        if (@available(iOS 13.0, *)) {
            //_titleLabel.textColor = [UIColor labelColor];
        } else {
            _dateLabel.textColor = [UIColor blackColor];
        }
        _dateLabel.font = kFont_Lable_15;
        _dateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLabel;
}

- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc]init];
        _image.backgroundColor =kColor_Cyan;
    }
    return _image;
}

@end
