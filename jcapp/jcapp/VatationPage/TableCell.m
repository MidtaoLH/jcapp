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
#import "../SDWebImage/UIImageView+WebCache.h"

#define kMargin 10


@interface TableCell ()

@property (nonatomic, strong) UILabel *leaveDateLable;

@property (nonatomic, strong) UILabel *leaveTypeLable;
@property (nonatomic, strong) UILabel *leaveStatusLable;
@property (nonatomic, strong) UILabel *leaveCondition;
@property (nonatomic, strong) AddButton *btnAdd;
@property (nonatomic, strong) DelButton *btndel;
@property (nonatomic, strong) UIButton *btnline;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation TableCell

- (AddButton *)btnAdd {
    
    if (!_btnAdd) {
        _btnAdd = [[AddButton alloc] init];
        _btnAdd.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:192/255.0 blue:203/255.0 alpha:1];
        [_btnAdd setTitle:@"➕" forState:UIControlStateNormal];
        //设置边框的颜色
        [_btnAdd.layer setBorderColor:[UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1].CGColor];
        //设置边框的粗细
        [_btnAdd.layer setBorderWidth:0.5];
        
        [_btnAdd setTitleColor:[UIColor greenColor]forState:UIControlStateNormal];
        [_btnAdd addTarget:self action:@selector(action:)   forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAdd;
}
- (UIButton *)btnline {
    
    if (!_btnline) {
        _btnline = [[AddButton alloc] init];
        _btnline.backgroundColor = kColor_Gray;
        _btnline.hidden = YES;
    }
    return _btnline;
}
- (DelButton *)btndel {
    
    if (!_btndel) {
        _btndel = [[DelButton alloc] init];
        [_btndel setTitle:@"删除" forState:UIControlStateNormal];
        _btndel.backgroundColor = [UIColor whiteColor];
        _btndel.titleLabel.font=kFont_Lable_12;
        //设置圆角的半径
        [_btndel.layer setCornerRadius:5];
        //切割超出圆角范围的子视图
        _btndel.layer.masksToBounds = YES;
        //设置边框的颜色
        [_btndel.layer setBorderColor:[UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1].CGColor];
        //设置边框的粗细
        [_btndel.layer setBorderWidth:1.0];
        [_btndel setTitleColor:[UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1] forState:(UIControlStateNormal)];
        // 一行代码给按钮添加事件
        [_btndel addTarget:self action:@selector(actiondel:)   forControlEvents:UIControlEventTouchUpInside];
    }
    return _btndel;
}
- (UILabel *)leaveStatusLable {
    
    if (!_leaveStatusLable) {
        _leaveStatusLable = [[UILabel alloc] init];
        _leaveStatusLable.font = kFont_Lable_12;
        _leaveStatusLable.textColor = kColor_Gray;
    }
    return _leaveStatusLable;
}
- (UILabel *)leaveCondition {
    
    if (!_leaveCondition) {
        _leaveCondition = [[UILabel alloc] init];
        _leaveCondition.font = kFont_Lable_12;
        _leaveCondition.textColor = kColor_Gray;
    }
    return _leaveCondition;
}

- (UILabel *)leaveDateLable {
    
    if (!_leaveDateLable) {
        _leaveDateLable = [[UILabel alloc] init];
        _leaveDateLable.font = kFont_Lable_12;
        _leaveDateLable.textColor = kColor_Gray;
    }
    return _leaveDateLable;
}
- (UILabel *)leaveTypeLable {
    
    if (!_leaveTypeLable) {
        _leaveTypeLable = [[UILabel alloc] init];
        _leaveTypeLable.font = kFont_Lable_12;
        _leaveTypeLable.textColor = kColor_Gray;
    }
    return _leaveTypeLable;
}


//自定义cell 需要重写的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"%@",@"tablecell");
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        [self.contentView  addSubview:self.leaveStatusLable];
        [self.contentView  addSubview:self.leaveDateLable];
        [self.contentView  addSubview:self.leaveCondition];
        [self.contentView  addSubview:self.btnAdd];
        [self.contentView  addSubview:self.btndel];
       [self.contentView  addSubview:self.btnline];
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
    NSString * obj1 = [multiParamButton.multiParamDic objectForKey:@"levelname"];
     NSString * obj2 = [multiParamButton.multiParamDicindex objectForKey:@"index"];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.way_post_level =obj1;
    myDelegate.way_post_index = obj2;
    AddWayView *nextVc = [[AddWayView alloc]init];//初始化下一个界面
    if([obj1 isEqualToString:@"回览人"])
    {
       nextVc.userflag = @"0";
    }
    else
    {
        nextVc.userflag = @"1";
    }
    
    
    [[self viewController].navigationController pushViewController:nextVc animated:YES];
}
- (void)actiondel:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除？" preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    _okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        DelButton* multiParamButton = (DelButton* )sender;
        NSString * obj1 = [multiParamButton.multiParamDic objectForKey:@"levelname"];
        NSString * obj2 = [multiParamButton.multiParamDicindex objectForKey:@"index"];
        
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        myDelegate.way_post_level =obj1;
        myDelegate.way_post_index_delete = obj2;
        myDelegate.way_post_delete = @"true";
        [[self viewController] viewDidLoad];
    }];
    _cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:_okAction];
    [alert addAction:_cancelAction];
    // 弹出对话框
    [[self viewController] presentViewController:alert animated:true completion:nil];
   
}


-(void)setIndex:(NSString *)index{
    
    NSLog(@"%@",@"setindex");
    NSDictionary* paramDic = @{@"index":index};
    self.btnAdd.multiParamDicindex= paramDic;
    self.btndel.multiParamDicindex= paramDic;
    
    
}

-(void)setWaylist:(Way *)Waylist
{
    self.textLabel.textColor  = kColor_Blue;
    self.textLabel.font  =  kFont_Lable_14;
    
    if([ Waylist.name isEqualToString:@"button"])
    {
        CGFloat height = SetAddTableRowSize;
        CGFloat imageWH=  height*0.8;
        self.btnline.frame = CGRectMake(kMargin+imageWH/2-2.5, 0, 5,SetAddButtonRowSize);
        
       self.btnAdd.hidden = NO;
        self.btndel.hidden = YES;
        self.textLabel.hidden = YES;
        self.leaveStatusLable.hidden = YES;
        self.leaveDateLable.hidden = YES;
        self.leaveCondition.hidden = YES;
        self.imageView.hidden =YES;
        NSDictionary* paramDic = @{@"levelname":Waylist.levelname};
        self.btnAdd.multiParamDic= paramDic;
        self.btndel.multiParamDic= paramDic;
        self.backgroundColor =  [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];;
        if([Waylist.levelname isEqualToString:@"回览人"])
        {
            self.btnline.hidden = YES;
        }
        else
        {
            self.btnline.hidden = NO;
        }
        
        //qu diao xian
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        if([myDelegate.way_button_show_flag isEqualToString:@"false"])
        {
            self.btnline.hidden = YES;
        }
        else
        {
            //self.btnline.hidden = NO;
        }
    }
    else
    {
        self.backgroundColor = kColor_White;
        if(![Waylist.level isEqualToString:@"99"])
        {
            CGFloat height = SetAddTableRowSize;
            CGFloat imageWH=  height*0.8;
            if(self.index==0&&[Waylist.level isEqualToString:@"1"])
            {
                self.btnline.frame = CGRectMake(kMargin+imageWH/2-2.5, height*0.1, 5,SetAddTableRowSize);
            }
            else
            {
                self.btnline.frame = CGRectMake(kMargin+imageWH/2-2.5, 0, 5,SetAddTableRowSize);
            }
            //self.btnline.hidden = NO;
            //qu diao xian
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            if([myDelegate.way_button_show_flag isEqualToString:@"false"])
            {
                self.btnline.hidden = YES;
            }
            else
            {
                self.btnline.hidden = NO;
            }
        }else
        {
            self.btnline.hidden = YES;
        }
        if([Waylist.editflag isEqualToString:@"0"])
        {
            self.btnAdd.hidden = YES;
            self.btndel.hidden = YES;
            self.textLabel.hidden = NO;
            self.leaveCondition.hidden = NO;
            self.leaveStatusLable.hidden = NO;
            self.leaveDateLable.hidden = NO;
            NSDictionary* paramDic = @{@"levelname":Waylist.levelname};
            self.btnAdd.multiParamDic= paramDic;
            self.btndel.multiParamDic= paramDic;
            self.textLabel.text = Waylist.name;
            self.leaveStatusLable.text = Waylist.levelname;;
            self.leaveDateLable.text = Waylist.groupname;;
            self.leaveCondition.text=Waylist.Condition;
            UIImageView *imageView = [[UIImageView alloc] init];
            NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,Waylist.englishname];
            [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString]];
            

            self.imageView.image=imageView.image;
            self.imageView.hidden = false;
        }
        else
        {
            self.btnAdd.hidden = YES;
            self.btndel.hidden = NO;
            self.textLabel.hidden = NO;
            self.leaveStatusLable.hidden = NO;
            self.leaveDateLable.hidden = NO;
             self.leaveCondition.hidden = NO;
            NSDictionary* paramDic = @{@"levelname":Waylist.levelname};
            self.btnAdd.multiParamDic= paramDic;
            self.btndel.multiParamDic= paramDic;
            
            self.textLabel.text = Waylist.name;
            self.leaveStatusLable.text = Waylist.levelname;;
            self.leaveDateLable.text = Waylist.groupname;;
             self.leaveCondition.text=Waylist.Condition;
            if([Waylist.englishname isEqualToString:@"button"])
            {
                UIImageView *imageView = [[UIImageView alloc] init];
                self.imageView.image=nil;
            }
            else
            {
                UIImageView *imageView = [[UIImageView alloc] init];
                NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,Waylist.englishname];
                [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString]];

                
                self.imageView.image=imageView.image;
                
                self.imageView.hidden = false;
            }
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = kScreenWidth;
    CGFloat height = SetAddTableRowSize;
    CGFloat imageWH=  height*0.8;
    CGFloat leaveDateWidth = 80;
    //每行的文本的高度
    CGFloat txtH = (height - 2*kMargin)/3;
    self.textLabel.frame = CGRectMake(2*kMargin+imageWH, kMargin, leaveDateWidth, txtH);
    self.leaveStatusLable.frame = CGRectMake(3*kMargin+imageWH+self.textLabel.width, kMargin, leaveDateWidth, txtH);
    //self.taskBackDateLable.frame =CGRectMake(4*kMargin+imageWH+self.taskBackEmpNameLable.width+self.taskBackTypeLable.width, kMargin, leaveDateWidth, txtH);
    self.leaveDateLable.frame = CGRectMake(2*kMargin+imageWH, txtH+2*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
   self.leaveCondition.frame=CGRectMake(3*kMargin+imageWH+self.textLabel.width, txtH+2*kMargin, width-(4*kMargin+imageWH+self.textLabel.width), txtH);
    
    self.imageView.frame = CGRectMake(kMargin,height*0.1, imageWH, imageWH );
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = imageWH * 0.5;
    
    self.btnAdd.frame = CGRectMake(width/2-SetButtonSize/2,SetAddButtonRowSize/2-SetButtonSize/2, SetButtonSize,SetButtonSize);
    self.btnAdd.layer.masksToBounds = YES;
    self.btnAdd.layer.cornerRadius = SetButtonSize * 0.5;
    
    self.btndel.frame = CGRectMake(width-SetDelButtonSize*2-kMargin, txtH+kMargin, SetDelButtonSize*2,SetDelButtonSize);
    
   
    
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
