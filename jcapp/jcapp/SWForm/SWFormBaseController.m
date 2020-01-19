//
//  SWFormBaseController.m
//  SWFormDemo
//
//  Created by zijin on 2018/5/28.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWFormBaseController.h"
#import "SWForm.h"
#import "SWFormInputCell.h"
#import "SWFormTextViewInputCell.h"
#import "SWFormSelectCell.h"
#import "SWFormImageCell.h"
#import "AppDelegate.h"

static NSInteger rowHeight=50;
@interface SWFormBaseController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, readonly) UITableViewStyle style;
@end

@implementation SWFormBaseController

- (NSMutableArray *)mutableItems {
    if (!_mutableItems) {
        _mutableItems = [[NSMutableArray alloc]init];
    }
    return _mutableItems;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        _style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:_style];
    [self addChildViewController:tableViewController];
    [tableViewController.view setFrame:self.view.bounds];
    
    // 获取tableViewController的tableView实现表单自动上移
    _formTableView = tableViewController.tableView;
    _formTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _formTableView.dataSource = self;
    _formTableView.delegate = self;
    //_formTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _formTableView.showsVerticalScrollIndicator = NO;
    _formTableView.showsHorizontalScrollIndicator = NO;
    _formTableView.backgroundColor = [UIColor whiteColor];
    _formTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CGFLOAT_MIN)];
    _formTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CGFLOAT_MIN)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    //  加上这句不会影响你 tableview 上的 action (button,cell selected...)
    singleTap.cancelsTouchesInView = NO;
    [_formTableView addGestureRecognizer:singleTap];
    
    [self.view addSubview:_formTableView];
}

- (void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

#pragma mark -- TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mutableItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==self.formTableView){
    NSParameterAssert([self.mutableItems[section] isKindOfClass:[SWFormSectionItem class]]);
    SWFormSectionItem *sectionItem = self.mutableItems[section];
    return sectionItem.items.count;
    }
    else{
        return myData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==self.formTableView){
        SWFormSectionItem *sectionItem = self.mutableItems[indexPath.section];
        NSParameterAssert([sectionItem.items[indexPath.row] isKindOfClass:[SWFormItem class]]);
        SWFormItem *item = sectionItem.items[indexPath.row];
        
        SWWeakSelf
        // 表单条目类别判断
        if (item.itemType == SWFormItemTypeTextViewInput) {
            static NSString *textViewInput_cell_id = @"textViewInput_cell_id";
            SWFormTextViewInputCell *cell = [tableView textViewInputCellWithId:textViewInput_cell_id];
            cell.item = item;
            cell.textViewInputCompletion = ^(NSString *text) {
                [weakSelf updateTextViewInputWithText:text indexPath:indexPath];
            };
            return cell;
        }
        else if (item.itemType == SWFormItemTypeSelect) {
            static NSString *select_cell_id = @"select_cell_id";
            SWFormSelectCell *cell = [tableView selectCellWithId:select_cell_id];
            cell.item = item;
            return cell;
        }
        else if (item.itemType == SWFormItemTypeImage) {
            static NSString *image_cell_id = @"image_cell_id";
            SWFormImageCell *cell = [tableView imageCellWithId:image_cell_id];
            cell.item = item;
            cell.imageCompletion = ^(NSArray *images) {
                [weakSelf updateImageWithImages:images indexPath:indexPath];
            };
            return cell;
        }
        else {
            static NSString *input_cell_id = @"input_cell_id";
            SWFormInputCell *cell = [tableView inputCellWithId:input_cell_id];
            cell.item = item;
            cell.inputCompletion = ^(NSString *text) {
                [weakSelf updateInputWithText:text indexPath:indexPath];
            };
            return cell;
        }
    }
    else{
        

            static NSString *ID=@"cellID";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.userInteractionEnabled = NO;
            cell.centerX=0.0;
            cell.textLabel.text=[NSString stringWithFormat:@""];
            cell.textLabel.textColor=UIColor.redColor;
//            cell.layer.borderWidth= 1.0;
//            cell.layer.borderColor=[[UIColor blackColor]CGColor];
            //cell.backgroundColor=UIColor.redColor;
            
            UILabel *cell1=[[UILabel alloc]init];
            cell1.text=[NSString stringWithFormat:@"*"];
            cell1.textColor=UIColor.redColor;
            cell1.frame = CGRectMake(5.0,5, 15, rowHeight);
             cell1.font=kFont_Lable_16;
            [cell.contentView addSubview:cell1];
            
            UILabel *cell0=[[UILabel alloc]init];
            cell0.text=[NSString stringWithFormat:@"出差地点"];
            //cell0.textColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
            //cell0.left=40;
            cell0.frame = CGRectMake(11.0,0, 75, rowHeight);
            cell0.font=kFont_Lable_16;
            //cell0.backgroundColor=UIColor.greenColor;
            [cell.contentView addSubview:cell0];
            
            CGRect textFieldRect = CGRectMake(cell0.width+25.0,cell.top+10, 150, 30.0);
            UITextField *theTextField = [[UITextField alloc] initWithFrame:textFieldRect];
            theTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //theTextField.frame = CGRectMake(cell0.centerX+33,0, 150, rowHeight);
            //theTextField.returnKeyType = UIReturnKeyDefault;
            theTextField.borderStyle = UITextBorderStyleNone;
            theTextField.placeholder=@"请输入";
            //theTextField.layer.borderColor = [UIColor grayColor].CGColor;
            //theTextField.layer.borderWidth = 1.0f;
            
            theTextField.tag = [indexPath row];
            theTextField.delegate = self;
            theTextField.text=myData[indexPath.row];
            //此方法为关键方法
            [theTextField addTarget:self action:@selector(textFieldWithText:)forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:theTextField];
            //        UITextField *cell1=[[UITextField alloc]init];
            //        //cell0.textColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
            //        //cell0.left=40;
            //        cell1.text=myData[indexPath.row];
            //        cell1.frame = CGRectMake(cell0.centerX+33,0, 150, rowHeight);
            //        cell1.layer.borderColor = [[UIColor orangeColor]CGColor];
            //
            //        //cell0.backgroundColor=UIColor.greenColor;
            //        [cell.contentView addSubview:cell1];
            
            
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
            btnAdd.frame = CGRectMake(self.view.width-100,cell.top+10, 30, 30);
            [btnAdd setTitle:@"+" forState:UIControlStateNormal];
            [btnAdd setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
            //关键语句
            btnAdd.layer.cornerRadius = btnAdd.frame.size.width/2;
            btnAdd.clipsToBounds = YES;
            btnAdd.backgroundColor =Color_ProcessStutasColor;
            btnAdd.titleLabel.font = [UIFont systemFontOfSize: 38.0];
            btnAdd.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            [btnAdd addTarget:self action:@selector(cellAddBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
            //btnAdd.backgroundColor=UIColor.blueColor;
            [btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.contentView addSubview:btnAdd];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame = CGRectMake(self.view.width-60,cell.top+10, 30, 30);
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            //关键语句
            btn.layer.cornerRadius = btnAdd.frame.size.width/2;
            btn.clipsToBounds = YES;
            btn.backgroundColor =[UIColor redColor];
            [btn setTitle:@"×" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize: 38.0];
            //btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentFill;
            btn.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
            [btn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
            
            //[btn3 addTarget:self action:@selector(onClick3:) forControlEvents:UIControlEventTouchUpInside];
            
            //btn3.tag=indexPath.row;
            //btn.backgroundColor=UIColor.greenColor;
            [cell.contentView addSubview:btn];
            
            return cell;
        
       
    }
}

#pragma mark -- TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==self.formTableView){
        SWFormSectionItem *sectionItem = self.mutableItems[indexPath.section];
        SWFormItem *item = sectionItem.items[indexPath.row];
        if (item.itemType == SWFormItemTypeTextViewInput) {
            return [SWFormTextViewInputCell heightWithItem:item];
        }
        else if (item.itemType == SWFormItemTypeSelect) {
            return [SWFormSelectCell heightWithItem:item];
        }
        else if (item.itemType == SWFormItemTypeImage) {
            return [SWFormImageCell heightWithItem:item];
        }
        else {
            return [SWFormInputCell heightWithItem:item];
        }
    }
    return Common_CCRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==self.formTableView){
        SWFormSectionItem *sectionItem = self.mutableItems[indexPath.section];
        SWFormItem *item = sectionItem.items[indexPath.row];
        if (item.itemType == SWFormItemTypeSelect && item.itemSelectCompletion) {
            item.itemSelectCompletion(item);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SWFormSectionItem *sectionItem = self.mutableItems[section];
    return sectionItem.headerHeight > 0 ? sectionItem.headerHeight:0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    SWFormSectionItem *sectionItem = self.mutableItems[section];
    return sectionItem.footerHeight > 0 ? sectionItem.footerHeight:0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SWFormSectionItem *sectionItem = self.mutableItems[section];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, sectionItem.headerHeight)];
    return sectionItem.headerView ? sectionItem.headerView:header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SWFormSectionItem *sectionItem = self.mutableItems[section];
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, sectionItem.footerHeight)];
    return sectionItem.footerView ? sectionItem.footerView:footer;
}

#pragma mark -- 表单条目响应block处理
- (void)updateInputWithText:(NSString *)text indexPath:(NSIndexPath *)indexPath {
    SWFormSectionItem *sectionItem = self.mutableItems[indexPath.section];
    SWFormItem *item = sectionItem.items[indexPath.row];
    item.info = text;
}

- (void)updateTextViewInputWithText:(NSString *)text indexPath:(NSIndexPath *)indexPath {
    SWFormSectionItem *sectionItem = self.mutableItems[indexPath.section];
    SWFormItem *item = sectionItem.items[indexPath.row];
    item.info = text;
}

- (void)updateImageWithImages:(NSArray *)images indexPath:(NSIndexPath *)indexPath {
    SWFormSectionItem *sectionItem = self.mutableItems[indexPath.section];
    SWFormItem *item = sectionItem.items[indexPath.row];
    item.images = images;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
