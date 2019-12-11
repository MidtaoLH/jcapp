//
//  NoticeCell.m
//  jcapp
//
//  Created by zclmac on 2019/12/10.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "NoticeCell.h"

#define kMargin 10

@interface NoticeCell()

@property (nonatomic, strong) UILabel *lbltitle;
@property (nonatomic, strong) UILabel *lblcontent;
@property (nonatomic, strong) UILabel *lblnoticedate;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation NoticeCell


- (UILabel *)lbltitle {
    
    if (!_lbltitle) {
        _lbltitle = [[UILabel alloc] init];
        _lbltitle.font = [UIFont systemFontOfSize:15];
        _lbltitle.textColor = [UIColor greenColor];
    }
    return _lbltitle;
}

- (UILabel *)lblcontent {
    
    if (!_lblcontent) {
        _lblcontent = [[UILabel alloc] init];
        _lblcontent.font = [UIFont systemFontOfSize:15];
        _lblcontent.textColor = [UIColor grayColor];
    }
    return _lblcontent;
}
- (UILabel *)lblnoticedate {
    
    if (!_lblnoticedate) {
        _lblnoticedate = [[UILabel alloc] init];
        _lblnoticedate.font = [UIFont systemFontOfSize:15];
        _lblnoticedate.textColor = [UIColor grayColor];
    }
    return _lblnoticedate;
}
 
//自定义cell 需要重写的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView  addSubview:self.lblnoticedate];
        [self.contentView  addSubview:self.lblcontent];
        [self.contentView  addSubview:self.lbltitle];
    }
    return self;
}

-(void)setNoticelist:(NoticeNews *)noticelist
{
    _noticelist =noticelist;
    
    self.textLabel.text = _noticelist.NewsTheme;
    
    self.lblcontent.text = _noticelist.NewsContent;
 
    NSString * strbegindate =[[NSString alloc]initWithFormat:@"%@%@",@"发布时间：",_noticelist.NewsDate];
 
    self.lblnoticedate.text = strbegindate;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
 
    //每行的文本的高度
    CGFloat txtH = (height - 4*kMargin)/3;
    
    self.textLabel.frame =CGRectMake(kMargin, kMargin, width  , txtH);
    
    self.lblnoticedate.frame = CGRectMake(kMargin, txtH+2*kMargin, width, txtH);
    
    self.lblcontent.frame = CGRectMake(kMargin,2*txtH+3*kMargin, width, txtH);
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
