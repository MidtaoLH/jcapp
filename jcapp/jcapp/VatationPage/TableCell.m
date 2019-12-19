//
//  TableViewCell.m
//  jcapp
//
//  Created by zhaodan on 2019/12/4.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "TableCell.h"
#import "AddButton.h"
#import "MJExtension.h"
#import "AddWayView.h"
#import "AppDelegate.h"
#import "DelButton.h"
#import "WayViewController.h"

#define kMargin 10


@interface TableCell ()

@property (nonatomic, strong) UILabel *leaveDateLable;
@property (nonatomic, strong) UILabel *beignDateLable;
@property (nonatomic, strong) UILabel *endDateLable;
@property (nonatomic, strong) UILabel *leaveTypeLable;
@property (nonatomic, strong) UILabel *leaveStatusLable;

@property (nonatomic, strong) AddButton *btnAdd;
@property (nonatomic, strong) DelButton *btndel;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation TableCell

- (AddButton *)btnAdd {
    
    if (!_btnAdd) {
        _btnAdd = [[AddButton alloc] init];
        [_btnAdd setTitle:@"+" forState:UIControlStateNormal];
        _btnAdd.backgroundColor = [UIColor orangeColor];
        // 一行代码给按钮添加事件
        //[_btnAdd addTarget:self action:@selector(btnclick:)   forControlEvents:UIControlEventTouchUpInside];
        [_btnAdd addTarget:self action:@selector(action:)   forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAdd;
}

- (DelButton *)btndel {
    
    if (!_btndel) {
        _btndel = [[DelButton alloc] init];
        [_btndel setTitle:@"删除" forState:UIControlStateNormal];
        _btndel.backgroundColor = [UIColor orangeColor];
        // 一行代码给按钮添加事件
        //[_btnAdd addTarget:self action:@selector(btnclick:)   forControlEvents:UIControlEventTouchUpInside];
        [_btndel addTarget:self action:@selector(actiondel:)   forControlEvents:UIControlEventTouchUpInside];
    }
    return _btndel;
}
- (UILabel *)leaveStatusLable {
    
    if (!_leaveStatusLable) {
        _leaveStatusLable = [[UILabel alloc] init];
        _leaveStatusLable.font = [UIFont systemFontOfSize:15];
        _leaveStatusLable.textColor = [UIColor grayColor];
    }
    return _leaveStatusLable;
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

        [self.contentView  addSubview:self.btnAdd];
        [self.contentView  addSubview:self.btndel];
    }
    return self;
}



//获取控制器
- (UIViewController *)viewController{
        for (UIView* next = [self superview]; next; next = next.superview) {
                UIResponder *nextResponder = [next nextResponder];
                if ([nextResponder isKindOfClass:[UIViewController class]]) {
                        return (UIViewController *)nextResponder;
                    }
            }
        return nil;
}

//点击事件

- (void)action:(id)sender
{
    
    AddButton* multiParamButton = (AddButton* )sender;
   

    NSLog(@"Vvvverify : %@", multiParamButton.multiParamDic);
    
    NSString * obj1 = [multiParamButton.multiParamDic objectForKey:@"levelname"];
     NSString * obj2 = [multiParamButton.multiParamDicindex objectForKey:@"index"];

    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.way_post_level =obj1;
    myDelegate.way_post_index = obj2;
    
    AddWayView *nextVc = [[AddWayView alloc]init];//初始化下一个界面
    [[self viewController] presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
    
    
}

- (void)actiondel:(id)sender
{
    
    DelButton* multiParamButton = (DelButton* )sender;
    
    
    //NSLog(@"Vvvverify : %@", multiParamButton.multiParamDic);
    
    NSString * obj1 = [multiParamButton.multiParamDic objectForKey:@"levelname"];
    NSString * obj2 = [multiParamButton.multiParamDicindex objectForKey:@"index"];
    
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.way_post_level =obj1;
    myDelegate.way_post_index_delete = obj2;
    myDelegate.way_post_delete = @"true";
    [[self viewController] viewDidLoad];
    
    NSLog(@"%@",@"action1");
}


-(void)setIndex:(NSString *)index{
    
    NSLog(@"%@",@"setindex");
    NSDictionary* paramDic = @{@"index":index};
    self.btnAdd.multiParamDicindex= paramDic;
    self.btndel.multiParamDicindex= paramDic;
    
    
}

-(void)setWaylist:(Way *)Waylist
{
     NSLog(@"%@",@"setway");
    
    if([ Waylist.name isEqualToString:@"button"])
    {
       self.btnAdd.hidden = NO;
        self.btndel.hidden = YES;
        self.textLabel.hidden = YES;
        self.leaveStatusLable.hidden = YES;
        self.leaveDateLable.hidden = YES;
        
        
        NSDictionary* paramDic = @{@"levelname":Waylist.levelname};
        self.btnAdd.multiParamDic= paramDic;
        self.btndel.multiParamDic= paramDic;
        
    }
    else
    {
       NSLog(@"%@",@"setwayelse");
        self.btnAdd.hidden = YES;
        self.btndel.hidden = NO;
        self.textLabel.hidden = NO;
        self.leaveStatusLable.hidden = NO;
        self.leaveDateLable.hidden = NO;
        NSLog(@"%@",@"setwayelsebutton");
        NSDictionary* paramDic = @{@"levelname":Waylist.levelname};
        self.btnAdd.multiParamDic= paramDic;
        self.btndel.multiParamDic= paramDic;
        
        self.textLabel.text = Waylist.name;
        self.leaveStatusLable.text = Waylist.levelname;;
        self.leaveDateLable.text = Waylist.groupname;;
        
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
    //self.leaveadd.frame=CGRectMake(kMargin,(height - 2*kMargin-imageWH)/2, imageWH, imageWH );
    
    
    self.btnAdd.frame = CGRectMake(width-leaveDateWidth-kMargin,4*kMargin, leaveDateWidth, txtH);
    
    self.btndel.frame = CGRectMake(width-leaveDateWidth-kMargin,4*kMargin, leaveDateWidth, txtH);
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
