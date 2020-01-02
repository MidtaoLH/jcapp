//
//  BusinessTripDetailImagecell.m
//  jcapp
//
//  Created by zhaodan on 2019/12/24.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "BusinessTripDetailImagecell.h"
#import "ImageViewParam.h"
#import "LeaveDetailCell.h"
#import "LookImageController.h"
#define kMargin 10

@interface BusinessTripDetailImagecell ()<UIScrollViewDelegate>{
    CGRect oldframe ;
    
}
@end

@implementation BusinessTripDetailImagecell

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
        
        ImageViewParam *imageView = [[ImageViewParam alloc] init];
        
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        NSString *name = [NSString stringWithFormat:@"0%d.jpg", i + 1];
        imageView.image = [UIImage imageNamed:name];
        
        NSDictionary* paramDic = @{@"taskid": @"3" };
        imageView.multiParamDic= paramDic;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseImage:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:imageView];
        
        i++;
    }
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

//触发点击事件
-(void)choseImage:(UITapGestureRecognizer *)sender{
    ImageViewParam *imageviewitem = (ImageViewParam *)sender.view;
    
    NSLog(@"Vvvverify : %@", imageviewitem.multiParamDic);
    
    
    //LookImageController *nextVc = [[LookImageController alloc]init];//初始化下一个界面
   // [self presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
    
    
    //LookImageController *nextVc = [[LookImageController alloc]init];//初始化下一个界面
    //[[self viewController] presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
    
    LookImageController * valueView = [[LookImageController alloc] initWithNibName:@"LookImageController"bundle:[NSBundle mainBundle]];
    //从底部划入
   [valueView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    

    
}

-(UIViewController *)receiveEventFirstResponser:(id)responser{
    /**
     1.responser:当前响应事件的对象:如按钮,view等常用的控件,甚至当我们点击cell时可传入tableView
     2.任何可响应事件的对象都继承自UIResponder
     */
    UIResponder *currentResponder = (UIResponder *)responser;
    UIViewController *responderVC = nil;
    if(currentResponder && [currentResponder isKindOfClass:[UIViewController class]]){
        responderVC = (UIViewController *)currentResponder;
        return responderVC;
    }
    UIResponder *nextResponder = currentResponder.nextResponder;
    if(nextResponder && [nextResponder isKindOfClass:[UIViewController class]]){
        responderVC = (UIViewController *)nextResponder;
        return responderVC;
    }
    /**
     条件值:用来控制循环的结束
     */
    NSInteger condition = 1;
    responderVC = nil;
    while (condition) {
        if(nextResponder && [nextResponder  isKindOfClass:[UIViewController class]]){
            responderVC = (UIViewController *)nextResponder;
            condition = 0;
        }else{
            nextResponder = nextResponder.nextResponder;
        }
    }
    return responderVC;
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
