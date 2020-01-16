//
//  SkyAssociationMenuView.m
//
//  Created by skytoup on 14-10-24.
//  Copyright (c) 2014年 skytoup. All rights reserved.
//

#import "SkyAssociationMenuView.h"


NSString *const IDENTIFIER = @"CELL";

@interface SkyAssociationMenuView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    NSArray *tables;
    UIView *bgView;
    NSInteger fIndex;
    NSInteger tIndex;
}
@end

@implementation SkyAssociationMenuView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(false, @"cann't not use - initWithCoder:, please user - init");
    return nil;
}

- (instancetype)init
{

    self = [super init];
    if (self) {
        // 初始化选择项
        for(int i=0; i!=3; ++i) {
            sels[i] = -1;
        }
        self.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, kScreenWidth,kScreenHeight);
        self.userInteractionEnabled = YES;
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = self.frame;
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        // 初始化菜单
        tables = @[[[UITableView alloc] init], [[UITableView alloc] init], [[UITableView alloc] init] ];
        [tables enumerateObjectsUsingBlock:^(UITableView *table, NSUInteger idx, BOOL *stop) {
            [table registerClass:[UITableViewCell class] forCellReuseIdentifier:IDENTIFIER ];
            table.dataSource = self;
            table.delegate = self;
            table.frame = CGRectMake(0, 0, 0, 0);
            table.backgroundColor = [UIColor clearColor];
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = YES;
        }];
        bgView = [[UIView alloc] init];
        
        bgView.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.3f];
        bgView.userInteractionEnabled = YES;
        [bgView addSubview:[tables objectAtIndex:0] ];
        
        /*
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45 * kScale)];
        titleLab.text = @"分类";
        titleLab.textAlignment = NSTextAlignmentCenter;
        [self addBottomSubLayer:titleLab];
        [bgView addSubview:titleLab];
        
        self.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.6f];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.userInteractionEnabled = YES;
        [bgView addSubview:[tables objectAtIndex:0]];*/
    }
    return self;
}

#pragma mark private
/**
 *  调整表视图的位置、大小
 */
- (void)adjustTableViews{
    int w = kScreenWidth;
    int __block showTableCount = 0;
    [tables enumerateObjectsUsingBlock:^(UITableView *t, NSUInteger idx, BOOL *stop) {
        CGRect rect = t.frame;
        rect.size.height = kScreenHeight - bgView.frame.origin.y;
        t.frame = rect;

        if(t.superview)
            ++showTableCount;
    }];
    
    for(int i=0; i!=showTableCount; ++i){
        UITableView *t = [tables objectAtIndex:i];
        CGRect f = t.frame;
        f.size.width = w / showTableCount;
        f.origin.x = f.size.width * i;
        t.frame = f;
    }
    
    /*
    for(int i=0; i!=showTableCount; ++i){
        if (showTableCount == 2) {
            if (i == 0) {
                UITableView *t = [tables objectAtIndex:i];
                CGRect f = t.frame;
                f.size.width = 125 * kScale;
                f.origin.x = 0;
                t.frame = f;
            }else {
                UITableView *t = [tables objectAtIndex:i];
                CGRect f = t.frame;
                f.size.width = w - 125 * kScale - 1;
                f.origin.x = 125 * kScale + 1;
                t.frame = f;
            }
        }else if(showTableCount == 1) {
            UITableView *t = [tables objectAtIndex:i];
            CGRect f = t.frame;
            f.size.width = w / showTableCount;
            f.origin.x = f.size.width * i;
            t.frame = f;
        }
     
    }*/
}
/**
 *  取消选择
 */
- (void)cancel{
    [self dismiss];
    if([self.delegate respondsToSelector:@selector(assciationMenuViewCancel)]) {
        [self.delegate assciationMenuViewCancel];
    }
}

/**
 *  保存table选中项
 */
- (void)saveSels{
    [tables enumerateObjectsUsingBlock:^(UITableView *t, NSUInteger idx, BOOL *stop) {
        sels[idx] = t.superview ? t.indexPathForSelectedRow.row : -1;
    }];
}

/**
 *  加载保存的选中项
 */
- (void)loadSels{
    [tables enumerateObjectsUsingBlock:^(UITableView *t, NSUInteger i, BOOL *stop) {
        [t selectRowAtIndexPath:[NSIndexPath indexPathForRow:sels[i] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        if((sels[i] != -1 && !t.superview) || !i) {
            [bgView addSubview:t];
        }
    }];
}

#pragma mark public
- (void)setSelectIndexForClass1:(NSInteger)idx_1 class2:(NSInteger)idx_2 class3:(NSInteger)idx_3 {
    sels[0] = idx_1;
    sels[1] = idx_2;
    sels[2] = idx_3;
}

- (void)showAsDrawDownView:(UIView *)view {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect showFrame = view.frame;
    showFrame = [view.superview convertRect:showFrame toView:window];
    CGFloat x = 0.f;
    CGFloat y = showFrame.origin.y+showFrame.size.height;
    CGFloat w = kScreenWidth;
    CGFloat h = kScreenHeight-y;
    bgView.frame = CGRectMake(x, y, w, h);
    if(!bgView.superview) {
        [self addSubview:bgView];
    }
    [self loadSels];
    [self adjustTableViews];
    if(!self.superview) {
        [window addSubview:self];
        self.alpha = .0f;
        [UIView animateWithDuration:.25f animations:^{
            self.alpha = 1.0f;
        }];
    }
    [window bringSubviewToFront:self];
}
- (void)showAsFrame:(CGRect) frame {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    bgView.frame = frame;
    if(!bgView.superview) {
        [self addSubview:bgView];
    }
    [self loadSels];
    [self adjustTableViews];
    if(!self.superview) {
        [window addSubview:self];
        self.alpha = .0f;
        [UIView animateWithDuration:.25f animations:^{
            self.alpha = 1.0f;
        }];
    }
    //[bgView addSubview:titleLab];
    //if (showCount) {
    
    //}
    [window bringSubviewToFront:self];
}

- (void)dismiss{
    if(self.superview) {
        [UIView animateWithDuration:.25f animations:^{
            self.alpha = .0f;
        } completion:^(BOOL finished) {
            [bgView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                [obj removeFromSuperview];
            }];
            [self removeFromSuperview];
        }];
    }
}

#pragma mark UITableViewDateSourceDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if(tableView == [tables objectAtIndex:0]){
        cell.textLabel.text = [_delegate assciationMenuView:self titleForClass_1:indexPath.row];
    }else if(tableView == [tables objectAtIndex:1]){
        cell.textLabel.text = [_delegate assciationMenuView:self titleForClass_1:((UITableView*)tables[0]).indexPathForSelectedRow.row class_2:indexPath.row];
    }
    //[self addBottomSubLayer:cell.contentView];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 50;
}
// View加下边框


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger __block count;
    [tables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(obj == tableView) {
            count = [_delegate assciationMenuView:self countForClass:idx section:fIndex];
            *stop = YES;
        }
    }];
    
    return count;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableView *t0 = [tables objectAtIndex:0];
    UITableView *t1 = [tables objectAtIndex:1];
    BOOL isNexClass = true;
   
    //showCount = YES;
    if(tableView == t0){
        if([self.delegate respondsToSelector:@selector(assciationMenuView:idxChooseInClass1:)]) {
            isNexClass = [_delegate assciationMenuView:self idxChooseInClass1:indexPath.row];
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [[tables objectAtIndex:0] reloadData];
                [[tables objectAtIndex:0] layoutIfNeeded];
            }];
            [[tables objectAtIndex:0] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [CATransaction commit];
        }
        fIndex = indexPath.row;
        if(isNexClass) {
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [t1 reloadData];
                [t1 layoutIfNeeded];
            }];
            [t1 reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [CATransaction commit];
            if(!t1.superview) {
                [bgView addSubview:t1];
            }
            [self adjustTableViews];
        }else{
            if(t1.superview) {
                [t1 removeFromSuperview];
            }
            [self saveSels];
            [self dismiss];
        }
    }else if(tableView == t1) {
        if([self.delegate respondsToSelector:@selector(assciationMenuView:idxChooseInClass1:class2:)]) {
            isNexClass = [_delegate assciationMenuView:self idxChooseInClass1:t0.indexPathForSelectedRow.row class2:indexPath.row];
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [[tables objectAtIndex:0] reloadData];
                [[tables objectAtIndex:0] layoutIfNeeded];
            }];
            [[tables objectAtIndex:0] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [CATransaction commit];
        }
        tIndex = indexPath.row;
        if(isNexClass){
           
            [self adjustTableViews];
        }else{
            if([self.delegate respondsToSelector:@selector(selectFindex:Tindex:)]) {
                [_delegate selectFindex:fIndex Tindex:tIndex];
            }
            [self saveSels];
            
            //[CATransaction begin];
            //[CATransaction setCompletionBlock:^{
            //    [t2 reloadData];
           // }];
            //[t2 reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            //[CATransaction commit];
        }
    }
}

@end
