//
//  LeaveDetailCell.m
//  jcapp
//
//  Created by zclmac on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "LeaveDetailCell.h"
#import "MultiParamButton.h"

#define kMargin 10

@interface LeaveDetailCell()

@property (nonatomic, strong) UILabel *lblleaveDate;
@property (nonatomic, strong) UILabel *lblempname;
@property (nonatomic, strong) UILabel *lblgroupname;
@property (nonatomic, strong) UILabel *lbllevelname;
@property (nonatomic, strong) UILabel *lblremark;

@property (nonatomic, strong) MultiParamButton *btnemail;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation LeaveDetailCell

- (MultiParamButton *)btnemail {
    
    if (!_btnemail) {
        _btnemail = [[MultiParamButton alloc] init];
       [_btnemail setTitle:@"提醒他" forState:UIControlStateNormal];
        _btnemail.backgroundColor = [UIColor orangeColor];
        // 一行代码给按钮添加事件
       [_btnemail addTarget:self action:@selector(action:)   forControlEvents:UIControlEventTouchUpInside];
 
    }
    return _btnemail;
}
-(void)action:(id)sender{
    MultiParamButton* multiParamButton = (MultiParamButton* )sender;
    
    NSLog(@"Vvvverify : %@", multiParamButton.multiParamDic);
 
}
- (UILabel *)lblleaveDate {
    
    if (!_lblleaveDate) {
        _lblleaveDate = [[UILabel alloc] init];
        _lblleaveDate.font = [UIFont systemFontOfSize:15];
        _lblleaveDate.textColor = [UIColor grayColor];
    }
    return _lblleaveDate;
}

- (UILabel *)lblgroupname {
    
    if (!_lblgroupname) {
        _lblgroupname = [[UILabel alloc] init];
        _lblgroupname.font = [UIFont systemFontOfSize:15];
        _lblgroupname.textColor = [UIColor grayColor];
    }
    return _lblgroupname;
}
- (UILabel *)lbllevelname {
    
    if (!_lbllevelname) {
        _lbllevelname = [[UILabel alloc] init];
        _lbllevelname.font = [UIFont systemFontOfSize:15];
        _lbllevelname.textColor = [UIColor grayColor];
    }
    return _lbllevelname;
}

- (UILabel *)lblremark {
    
    if (!_lblremark) {
        _lblremark = [[UILabel alloc] init];
        _lblremark.font = [UIFont systemFontOfSize:15];
        _lblremark.textColor = [UIColor grayColor];
        _lblremark.height = 1;
        
        //设置换行
        _lblremark.lineBreakMode = UILineBreakModeWordWrap;
        _lblremark.numberOfLines = 0;
    }
    return _lblremark;
}
- (UILabel *)lblempname {
    
    if (!_lblempname) {
        _lblempname = [[UILabel alloc] init];
        _lblempname.font = [UIFont systemFontOfSize:15];
        _lblempname.textColor = [UIColor grayColor];
    }
    return _lblempname;
}


//自定义cell 需要重写的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.lblremark];
        [self.contentView  addSubview:self.lblempname];
        [self.contentView  addSubview:self.lblleaveDate];
        [self.contentView  addSubview:self.lblgroupname];
        [self.contentView  addSubview:self.lbllevelname];
        [self.contentView  addSubview:self.btnemail];
    }
    return self;
}


-(void)setLeavedetail:(LeaveDeatil *)leavedetail
{
    _leavedetail =leavedetail;
    
    self.textLabel.text = _leavedetail.name;
    
    self.lbllevelname.text = _leavedetail.levelname;
 
    self.lblgroupname.text = _leavedetail.groupname;
    
    self.imageView.image =[UIImage imageNamed:@"01.jpg"];

    self.lblremark.text =  _leavedetail.Remark;
 
 
        /*
         NSString * strremark = [[NSString alloc]initWithFormat:@"%@\n%@",[_leavedetail.Remark  substringToIndex:5],[_leavedetail.Remark substringFromIndex:_leavedetail.Remark.length- 5]];
         
         self.lblremark.text =  strremark;
         
         CGSize size = [self sizeThatFits:CGSizeMake(self.lblremark.frame.size.height, MAXFLOAT)];
         CGRect frame = self.lblremark.frame;
         frame.size.height = size.height;
         [self.lblremark setFrame:frame];
         
         */

  
    
     self.lblleaveDate.text = _leavedetail.TaskDate;
    
    self.btnemail.hidden = YES;
    if([_leavedetail.TaskNodeOperateType isEqualToString: @"2"])
    {
        if([_leavedetail.TaskAuditeStatus isEqualToString: @"1"] || [_leavedetail.TaskAuditeStatus isEqualToString: @"2"] )
        {
            if([_leavedetail.ProcessStutas isEqualToString: @"2"] || [_leavedetail.ProcessStutas isEqualToString: @"3"]  || [_leavedetail.ProcessStutas isEqualToString: @"4"] )
            {
                self.btnemail.hidden = NO;
                NSDictionary* paramDic = @{@"one":@"one",@"two":@2,@"third":@(3)};
                self.btnemail.multiParamDic= paramDic;
 
            }
        }
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat imageWH= height - 10* kMargin;
    
    CGFloat leaveDateWidth = 90;
    
    //每行的文本的高度
    CGFloat txtH = (height - 6*kMargin)/5;
    
    //先设置图片大小和位置
    self.imageView.frame = CGRectMake(kMargin,kMargin, imageWH, imageWH);
    
    //设置日期未知
    self.lblleaveDate.frame = CGRectMake(width-leaveDateWidth-kMargin,kMargin, leaveDateWidth, txtH);
    
    //设置名称
    self.textLabel.frame =CGRectMake(2 * kMargin + imageWH, kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    
    //s设置部门
    self.lblgroupname.frame = CGRectMake(2*kMargin+imageWH, txtH+2*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    
    //级别名称和 员工名
    self.lbllevelname.frame = CGRectMake(2*kMargin+imageWH + 80,  kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    
    self.lblremark.frame = CGRectMake(2*kMargin+imageWH  + 80 ,  txtH+kMargin, width - leaveDateWidth - kMargin - imageWH, 3*txtH);
    
    self.btnemail.frame = CGRectMake(width-leaveDateWidth-kMargin,4*kMargin, leaveDateWidth, txtH);
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
