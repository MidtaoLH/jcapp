
#import "NotiInfoCell.h"
#import "BRPickerViewMacro.h"

#define kLeftMargin 14
#define kRowHeight 50

@interface NotiInfoCell()
@property (nonatomic, strong) UIImageView *nextImageView;

@end

@implementation NotiInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.deptLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.contextLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 调整cell分割线的边距：top, left, bottom, right
    //self.separatorInset = UIEdgeInsetsMake(0, kLeftMargin, 0, kLeftMargin);
     if (self.pageindex==0) {
         self.titleLabel.frame = CGRectMake(kLeftMargin, 0, kScreenWidth-kLeftMargin*2, kRowHeight);
         self.deptLabel.frame = CGRectMake(kLeftMargin, kRowHeight/3+kLeftMargin, kScreenWidth-kLeftMargin, kRowHeight);
          self.dateLabel.frame = CGRectMake(kLeftMargin,  kRowHeight/2+kLeftMargin*2, kScreenWidth-kLeftMargin, kRowHeight);
         self.contextLabel.hidden=YES;
         self.titleLabel.hidden=NO;
         self.deptLabel.hidden=NO;
         self.dateLabel.hidden=NO;
     }
     else if (self.pageindex==1)
     {
         self.titleLabel.hidden=YES;
         self.deptLabel.hidden=YES;
         self.dateLabel.hidden=YES;
         self.contextLabel.hidden=NO;
     }
     else
     {
         self.titleLabel.hidden=YES;
         self.deptLabel.hidden=YES;
         self.dateLabel.hidden=YES;
         self.contextLabel.hidden=YES;
     }
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
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_titleLabel setNumberOfLines:0];
    }
    return _titleLabel;
}
- (UILabel *)deptLabel {
    if (!_deptLabel) {
        _deptLabel = [[UILabel alloc]init];
        _deptLabel.backgroundColor = [UIColor clearColor];
        if (@available(iOS 13.0, *)) {
            //_titleLabel.textColor = [UIColor labelColor];
        } else {
            _deptLabel.textColor = [UIColor grayColor];
        }
        _deptLabel.font = [UIFont systemFontOfSize:15.0f];
        _deptLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _deptLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.backgroundColor = [UIColor clearColor];
        if (@available(iOS 13.0, *)) {
            //_titleLabel.textColor = [UIColor labelColor];
        } else {
            _dateLabel.textColor = [UIColor grayColor];
        }
        _dateLabel.font = [UIFont systemFontOfSize:15.0f];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _dateLabel;
} 
- (UILabel *)contextLabel {
    if (!_contextLabel) {
        _contextLabel = [[UILabel alloc]init];
        _contextLabel.backgroundColor = [UIColor clearColor];
        if (@available(iOS 13.0, *)) {
            //_titleLabel.textColor = [UIColor labelColor];
        } else {
            _contextLabel.textColor = [UIColor blackColor];
        }
      
        _contextLabel.font = [UIFont systemFontOfSize:16.0f];
        _contextLabel.textAlignment = NSTextAlignmentLeft;
        _contextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contextLabel.numberOfLines = 0;
    }
    return _contextLabel;
}

@end
