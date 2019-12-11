//
//  LeaveImageCell.m
//  jcapp
//
//  Created by zclmac on 2019/12/10.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "LeaveImageCell.h"

@implementation LeaveImageCell

//自定义cell 需要重写的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
       
        
    }
    return self;
}

-(void)setStr:(NSString *)str
{
    _str = str;
    
    //    图片的宽
    CGFloat imageW = 85;
    //    CGFloat imageW = 300;
    //    图片高
    CGFloat imageH = 85;
    
    //    图片的Y
    CGFloat imageY = 0;
    
    //根据个数生成图片imageview
    NSArray *array = [_str componentsSeparatedByString:@"【"];
    
    int i = 0;
    
    for (NSString * imgItem in array) {
        
        // 图片X
        CGFloat imageX = i * imageW + i * 10;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        NSString *name = [NSString stringWithFormat:@"0%d.jpg", i + 1];
        imageView.image = [UIImage imageNamed:name];
        
         [self.contentView addSubview:imageView];
        
        i++;
    }
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
