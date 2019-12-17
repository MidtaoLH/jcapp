//
//  BusinessTripEditViewController.m
//  jcapp
//
//  Created by youkare on 2019/12/12.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "BusinessTripEditViewController.h"
#import "SWForm.h"
#import "SWFormHandler.h"
#import "../VatationPage/CalendaViewController.h"

static NSInteger rowHeight=50;
@interface BusinessTripEditViewController ()<UIActionSheetDelegate>
@property (nonatomic, strong) NSArray *genders;
@property (nonatomic, strong) SWFormItem *businessTripStart;
@property (nonatomic, strong) SWFormItem *businessTripEnd;
@property (nonatomic, strong) SWFormItem *businessNum;
@property (nonatomic, strong) SWFormItem *gender;
@property (nonatomic, strong) SWFormItem *reason;
@property (nonatomic, strong) SWFormItem *image;
@end

@implementation BusinessTripEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    datePicker = [[UIDatePicker alloc] init]; datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    
    //totalcount=1;
    totalHeight=150;
    //tableViewPlace.backgroundColor=UIColor.blueColor;
    tableViewPlace.frame = CGRectMake(0,-40, self.view.frame.size.width, totalHeight);
    tableViewPlace.rowHeight=rowHeight;
    myData = [[NSMutableArray alloc]initWithObjects:@"",nil];
    //[myData insertObject:@"f" atIndex:0];

    self.genders = @[@"男",@"女"];
    [self datas];
    self.formTableView.frame=CGRectMake(0,totalHeight-30, self.view.frame.size.width, 500);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, self.view.height-44.0, self.view.width, 44.0)];
    
    [self.view addSubview:toolBar];
    
    UIBarButtonItem *addBtn=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(addAction)];
    addBtn.width=self.view.width/2;
    
    UIBarButtonItem *submitBtn=[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(submitAction)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:addBtn,submitBtn, nil];
    submitBtn.width=self.view.width/2;
    
    [toolBar setItems:toolbarItems animated:NO];
    
}
/**
 数据源处理
 */
- (void)datas {
    SWWeakSelf
    NSMutableArray *items = [NSMutableArray array];
    
    self.businessTripStart = SWFormItem_Add(@"出发日期", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
    //self.name.showLength = YES;
    self.businessTripStart.maxInputLength = 30;
    self.businessTripStart.itemSelectCompletion = ^(SWFormItem *item) {
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil];

        [actionSheet showInView:self.view];
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.tag = 101;
        datePicker.datePickerMode = 1;
        [actionSheet addSubview:datePicker];
        
        [actionSheet showInView:weakSelf.view];
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//
//        [defaults setObject:@"tableviewstart" forKey:@"type"];
//        [defaults synchronize];//保存到磁盘
//        CalendaViewController *nextVc = [[CalendaViewController alloc]init];//初始化下一个界面
//        [self presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
    };
    [items addObject:_businessTripStart];
    
    self.businessTripEnd = SWFormItem_Add(@"返回日期", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
    self.businessTripEnd.maxInputLength = 30;
    //self.age.info=@"2019-12-15";
    self.businessTripEnd.itemSelectCompletion = ^(SWFormItem *item) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil 　　preferredStyle:UIAlertControllerStyleActionSheet];
        [alert.view addSubview:datePicker];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            //实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
            NSString *dateString = [dateFormat stringFromDate:datePicker.date];
            //求出当天的时间字符串
            NSLog(@"%@",dateString);
            self.businessTripEnd.info=dateString;
            [self.formTableView reloadData];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            　 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{ }];
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//
//        [defaults setObject:@"tableviewsend" forKey:@"type"];
//        [defaults synchronize];//保存到磁盘
//        CalendaViewController *nextVc = [[CalendaViewController alloc]init];//初始化下一个界面
//        [self presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
    };
    [items addObject:_businessTripEnd];
    
    self.businessNum = SWFormItem_Add(@"出差天数", nil, SWFormItemTypeInput, YES, YES, UIKeyboardTypeNumberPad);
    self.businessNum.maxInputLength = 5;
    self.businessNum.itemUnitType = SWFormItemUnitTypeNone;
    [items addObject:_businessNum];
    
    self.gender = SWFormItem_Add(@"性别", nil, SWFormItemTypeSelect, NO, YES, UIKeyboardTypeDefault);
    self.gender.itemSelectCompletion = ^(SWFormItem *item) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"请选择%@",item.title] delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        for (int i = 0; i < weakSelf.genders.count; i++) {
            [actionSheet addButtonWithTitle:weakSelf.genders[i]];
        }
        actionSheet.tag = 10;
        [actionSheet showInView:weakSelf.view];
    };
    //[items addObject:_gender];
    
    self.reason = SWFormItem_Add(@"出差事由", @"请输入出差事由", SWFormItemTypeTextViewInput, YES, YES, UIKeyboardTypeDefault);
    self.reason.showLength = YES;
    [items addObject:_reason];
    
    self.image = SWFormItem_Add(@"图片", nil, SWFormItemTypeImage, YES, NO, UIKeyboardTypeDefault);
    self.image.images = @[@"http://imgsrc.baidu.com/image/c0%3Dpixel_huitu%2C0%2C0%2C294%2C40/sign=f04093d6da00baa1ae214ffb2e68dc7e/34fae6cd7b899e5160ce642e49a7d933c8950d43.jpg", @"http://imgsrc.baidu.com/image/c0%3Dpixel_huitu%2C0%2C0%2C294%2C40/sign=b360ab28790e0cf3b4fa46bb633e9773/e850352ac65c10387071c8f8b9119313b07e89f8.jpg"];
    [items addObject:_image];
    
    SWFormSectionItem *sectionItem = SWSectionItem(items);
    //    sectionItem.headerHeight = 10;
    //    sectionItem.footerView = [self footerView];
    //    sectionItem.footerHeight = 80;
    [self.mutableItems addObject:sectionItem];
    
    self.formTableView.tableFooterView = [self footerView];
}

/**
 创建footer
 */
- (UIView *)footerView {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.bounds = CGRectMake(0, 0, 100, 40);
    submitBtn.bottom = footer.bottom;
    submitBtn.backgroundColor = [UIColor orangeColor];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    //[footer addSubview:submitBtn];
    
    return footer;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *timesp = [formatter stringFromDate:datePicker.date];
    self.businessTripStart.info =timesp;
    [self.formTableView reloadData];
    //[actionSheet release];
    
//    if (actionSheet.tag == 10) {
//        if (buttonIndex != 0) {
//            //self.gender.info = self.genders[buttonIndex-1];
//            [self.formTableView reloadData];
//        }
//    }
}
- (void)addAction {
    [SWFormHandler sw_checkFormNullDataWithWithDatas:self.mutableItems success:^{
        
        NSDictionary *params3 = [NSDictionary dictionaryWithObjectsAndKeys:                                      myData, @"json",nil];
        //convert object to data
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:params3                                                              options:NSJSONWritingPrettyPrinted error:nil];
        //print out the data contents
        NSString* text =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json字典里面的内容为--》%@", text );
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        
        NSString *outputStr = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)text,NULL,(CFStringRef)@"!*'();:@&=+ $,/?%#[]",kCFStringEncodingUTF8));
        NSLog(@"outputStr字典里面的内容为--》%@", outputStr );
        //        NSLog(@"selectImages === %@", self.image.selectImages);
//        //NSLog(@"images === %@", image.images);
//        NSLog(@"businessTripEnd === %@", self.businessTripEnd.info);
//        NSLog(@"businessTripStart === %@", self.businessTripStart.info);
        
    } failure:^(NSString *error) {
        NSLog(@"error====%@",error);
    }];
}
- (void)submitAction {
    [SWFormHandler sw_checkFormNullDataWithWithDatas:self.mutableItems success:^{
        
        NSLog(@"selectImages === %@", self.image.selectImages);
        //NSLog(@"images === %@", image.images);
        NSLog(@"businessTripEnd === %@", self.businessTripEnd.info);
        NSLog(@"businessTripStart === %@", self.businessTripStart.info);
        
    } failure:^(NSString *error) {
        NSLog(@"error====%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadTableLocation
{
    tableViewPlace.height=totalHeight;
    [tableViewPlace reloadData];
    self.formTableView.frame=CGRectMake(0,totalHeight-20, self.view.frame.size.width, 500);
}
- (void)textFieldWithText:(UITextField *)textField
{
    [myData replaceObjectAtIndex:textField.tag withObject:textField.text];
}
- (void)cellAddBtnClicked:(id)sender event:(id)event
{
    
    NSSet *touches =[event allTouches];
    
    UITouch *touch =[touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:tableViewPlace];
    
    NSIndexPath *indexPath= [tableViewPlace indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath!= nil) {
        
        // do something
        //totalcount++;
        [myData addObject:@""];
        totalHeight=totalHeight+rowHeight;
        [self LoadTableLocation];
        //NSLog(@"indexPath.row:%@;mydata:%@",indexPath.row,myData.count);
        
    }
    
}
- (void)cellBtnClicked:(id)sender event:(id)event
{
    
    NSSet *touches =[event allTouches];
    
    UITouch *touch =[touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:tableViewPlace];
    
    NSIndexPath *indexPath= [tableViewPlace indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath!= nil) {
        
        // do something
        //totalcount--;
        [myData removeObjectAtIndex:indexPath.row];
        totalHeight=totalHeight-rowHeight;
        [self LoadTableLocation];
        //NSLog(@"indexPath.row:%@;mydata:%@",indexPath.row,myData.count);
    }
    
}
//如果不设置section 默认就1组
//每组多少行
//- (NSInteger)tableView:(UITableView *)name numberOfRowsInSection:(NSInteger)section
//{
//    if(name==tableViewPlace){
//        return totalcount;
//    }
//    return 1;
//}

//- (UITableViewCell *)tableView:(UITableView *)name cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(name==tableViewPlace){
//        static NSString *ID=@"cellID";
//        UITableViewCell *cell=[tableViewPlace dequeueReusableCellWithIdentifier:ID];
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
//        cell.textLabel.text=[NSString stringWithFormat:@"*"];
//        cell.textLabel.textColor=UIColor.redColor;
//        //cell.backgroundColor=UIColor.redColor;
//
//        UILabel *cell0=[[UILabel alloc]init];
//        cell0.text=[NSString stringWithFormat:@"出差地点"];
//        cell0.textColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
//        //cell0.left=40;
//        cell0.frame = CGRectMake(30,0, 80, rowHeight);
//        //cell0.backgroundColor=UIColor.greenColor;
//        [cell.contentView addSubview:cell0];
//
//            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnAdd.frame = CGRectMake(cell.frame.size.width-50,cell.top, 50.0f, rowHeight);
//
//        [btnAdd setTitle:@"➕" forState:UIControlStateNormal];
//
//        [btnAdd addTarget:self action:@selector(cellAddBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
//        //btnAdd.backgroundColor=UIColor.blueColor;
//        [cell.contentView addSubview:btnAdd];
//
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        btn.frame = CGRectMake(cell.frame.size.width-20,cell.top, 50.0f, rowHeight);
//
//        [btn setTitle:@"✖️" forState:UIControlStateNormal];
//
//        //btn.backgroundColor =[UIColor redColor];
//
//        [btn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
//
//        //[btn3 addTarget:self action:@selector(onClick3:) forControlEvents:UIControlEventTouchUpInside];
//
//        //btn3.tag=indexPath.row;
//        //btn.backgroundColor=UIColor.greenColor;
//        [cell.contentView addSubview:btn];
//
//        return cell;
//    }
//    return nil;
//}
//-(IBAction)delRows:(id)sender{
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//    [datas removeObjectAtIndex:0];
//    [indexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [self.tableView beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
//}


//-(void)onClick3:(UIButton *) sender{

//    NSLog(@"%ld",sender.tag);

//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
//    // 获取cell 对象
//    UILabel *name = (UILabel *)[cell.contentView viewWithTag:111];
//    // 获取昵称
//    //_inputView.inputText.text = [NSString stringWithFormat:@"回复 %@ :", name.text];
//    // 加上对应的回复昵称
//}
@end
