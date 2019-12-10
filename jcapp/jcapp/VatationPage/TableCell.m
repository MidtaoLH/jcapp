//
//  TableViewCell.m
//  jcapp
//
//  Created by zhaodan on 2019/12/4.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "TableCell.h"


#define kMargin 10


@interface TableCell ()

@property (nonatomic, strong) UILabel *leaveDateLable;
@property (nonatomic, strong) UILabel *beignDateLable;
@property (nonatomic, strong) UILabel *endDateLable;
@property (nonatomic, strong) UILabel *leaveTypeLable;
@property (nonatomic, strong) UILabel *leaveStatusLable;

@property (nonatomic, strong) UIButton *leaveadd;


// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation TableCell


- (UILabel *)leaveStatusLable {
    
    if (!_leaveStatusLable) {
        _leaveStatusLable = [[UILabel alloc] init];
        _leaveStatusLable.font = [UIFont systemFontOfSize:15];
        _leaveStatusLable.textColor = [UIColor grayColor];
    }
    return _leaveStatusLable;
}

- (UIButton *)leaveadd {
    
    if (!_leaveadd) {
        _leaveadd = [[UIButton alloc] init];
        //_leaveadd.font = [UIFont systemFontOfSize:15];
        _leaveadd.backgroundColor = [UIColor blueColor];

        //_leaveadd.textColor = [UIColor grayColor];
    }
    return _leaveadd;
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
    NSLog(@"%@",@"tablecell");
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.endDateLable];
        [self.contentView  addSubview:self.leaveTypeLable];
        [self.contentView  addSubview:self.beignDateLable];
        [self.contentView  addSubview:self.leaveStatusLable];
        [self.contentView  addSubview:self.leaveDateLable];
        
        
     
    
        [self.leaveadd setTitle:@"title"forState:UIControlStateNormal];
        
        [self.leaveadd addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView  addSubview:self.leaveadd];
    }
    return self;
}

- (void)btnclick:(UIButton *)sender
{
    
    NSLog(@"%@",@"dianjishijian");
    

}






-(void)setWaylist:(Way *)Waylist
{
    
    _Waylist =Waylist;
    
    if([ _Waylist.name isEqualToString:@"button"])
    {
       self.leaveadd.hidden = NO;
        self.textLabel.hidden = YES;
        self.leaveStatusLable.hidden = YES;
        self.leaveDateLable.hidden = YES;
    }
    else
    {
        self.leaveadd.hidden = YES;
        self.textLabel.hidden = NO;
        self.leaveStatusLable.hidden = NO;
        self.leaveDateLable.hidden = NO;

        
        
        self.textLabel.text = _Waylist.name;
        self.leaveStatusLable.text = _Waylist.levelname;;
        self.leaveDateLable.text = _Waylist.groupname;;
        
    }
    
    
    
    //self.leaveadd.titleLabel.text=@"123";
    //self.textLabel.hidden = YES;
    //self.leaveadd.hidden = YES;
    /*UIImageView *imageView = [[UIImageView alloc] init];
    NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,_pendinglistitem.ApplyManPhoto];
    [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString]];
    self.imageView.image=imageView.image;*/
    
    
    
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat imageWH=  width/5;
    CGFloat leaveDateWidth = 80;
    //每行的文本的高度
    CGFloat txtH = (height - 6*kMargin)/5;
    self.imageView.frame = CGRectMake(kMargin,(height - 2*kMargin-imageWH)/2, imageWH, imageWH );
    self.leaveStatusLable.frame = CGRectMake(width-leaveDateWidth-kMargin,kMargin, leaveDateWidth, txtH);
    self.leaveDateLable.frame = CGRectMake(2*kMargin+imageWH, txtH+2*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.beignDateLable.frame = CGRectMake(2*kMargin+imageWH, 2*txtH+3*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.endDateLable.frame = CGRectMake(2*kMargin+imageWH, 3*txtH+4*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.leaveTypeLable.frame = CGRectMake(2*kMargin+imageWH, 4*txtH+5*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    self.textLabel.frame = CGRectMake(2*kMargin+imageWH,kMargin, imageWH*2, txtH);
    self.leaveadd.frame=CGRectMake(kMargin,(height - 2*kMargin-imageWH)/2, imageWH, imageWH );
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
