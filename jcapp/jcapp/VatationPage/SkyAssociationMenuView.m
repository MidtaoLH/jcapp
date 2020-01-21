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
        for(int i=0; i!=2; ++i) {
            sels[i] = -1;
        }
        self.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, kScreenWidth,kScreenHeight);
        self.userInteractionEnabled = YES;
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = self.frame;
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        // 初始化菜单
        tables = @[[[UITableView alloc] init], [[UITableView alloc] init]];
        [tables enumerateObjectsUsingBlock:^(UITableView *table, NSUInteger idx, BOOL *stop) {
            [table registerClass:[UITableViewCell class] forCellReuseIdentifier:IDENTIFIER ];
            table.dataSource = self;
            table.delegate = self;
            table.frame = CGRectMake(0, 0, 0, 0);
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = YES;
            table.estimatedRowHeight = 0;
            table.estimatedSectionHeaderHeight = 0;
            table.estimatedSectionFooterHeight = 0.1;
        }];
        bgView = [[UIView alloc] init];
        bgView.userInteractionEnabled = YES;
       
        [bgView addSubview:[tables objectAtIndex:0] ];
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
        rect.size.height = kScreenHeight - StatusBarAndNavigationBarHeight;
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
- (void)setSelectIndexForClass1:(NSInteger)idx_1 class2:(NSInteger)idx_2 {
    sels[0] = idx_1;
    sels[1] = idx_2;
}

- (void)showAsDrawDownView:(UIView *)view {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect showFrame = view.frame;
    showFrame = [view.superview convertRect:showFrame toView:window];
    CGFloat x = 0.f;
    CGFloat y = 0;
    CGFloat w = kScreenWidth;
    CGFloat h = kScreenHeight;
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
        if (tIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = kColor_White;
    cell.selectedBackgroundView = selectionColor;
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
        tIndex = -1;
        fIndex = indexPath.row;
        if([self.delegate respondsToSelector:@selector(assciationMenuView:idxChooseInClass1:)]) {
            isNexClass = [_delegate assciationMenuView:self idxChooseInClass1:indexPath.row];
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [[tables objectAtIndex:0] reloadData];
            }];
            [[tables objectAtIndex:0] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [CATransaction commit];
        }
        if(isNexClass) {
            if(!t1.superview) {
                [bgView addSubview:t1];
            }
            [self adjustTableViews];
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [t1 reloadData];
                [t1 layoutIfNeeded];
            }];
            
            [t1 reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [CATransaction commit];
        }
    }else if(tableView == t1) {
        isNexClass = [_delegate assciationMenuView:self idxChooseInClass1:fIndex class2:indexPath.row];
        tIndex = indexPath.row;
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [t1 reloadData];
        }];
        [t1 reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [CATransaction commit];
        if([self.delegate respondsToSelector:@selector(selectFindex:Tindex:)]) {
            [_delegate selectFindex:fIndex Tindex:tIndex];
        }
        [self saveSels];
    }
}

@end
