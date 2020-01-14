//
//  VatcationMainView.m
//  jcapp
//
//  Created by zhaodan on 2019/12/17.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "VatcationMainView.h"
#import "SWForm.h"
#import "SWFormHandler.h"
#import "../VatationPage/CalendaViewController.h"
#import "../MJRefresh/MJRefresh.h"
#import "../MJExtension/MJExtension.h"
#import "AppDelegate.h"
#import "VatationPageViewController.h"
#import "KeepLeave.h"
#import "LeaveStatusModel.h"
#import "TabBarViewController.h"
#import "WayViewController.h"
#import "Masonry.h"

static NSInteger rowHeight=50;


NSString * boolflag = @"flase";

@interface VatcationMainView ()<UIActionSheetDelegate,VcBDelegate>//遵循协议
@property (nonatomic, strong) NSArray *genders;
@property (nonatomic, strong) SWFormItem *VatcationType;
@property (nonatomic, strong) SWFormItem *businessTripStart;
@property (nonatomic, strong) SWFormItem *businessTripEnd;
@property (nonatomic, strong) SWFormItem *businessNum;
@property (nonatomic, strong) SWFormItem *gender;
@property (nonatomic, strong) SWFormItem *reason;
@property (nonatomic, strong) SWFormItem *image;

@property (nonatomic, strong) NSMutableData *mResponseData;
@end

@implementation VatcationMainView

@synthesize listOfKeepLeave;
@synthesize listOfLeave;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.title=@"请假申请";

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    empname = [defaults objectForKey:@"empname"];
    groupid = [defaults objectForKey:@"Groupid"];
    UserHour = [defaults objectForKey:@"UserHour"];

    // 任务id复植
    processid = self.processInstanceID;
    vatcationid =self.vatcationid;
    if(self.edittype.length > 0)
    {
        
    }
    else
    {
        self.edittype = @"1";
    }
    
    if([self.edittype isEqualToString:@"2"] || [self.edittype isEqualToString:@"3"])
    {
        //vatcationid = @"10673";
       // urltype = @"getdata";
        //processid = @"22783";
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/VatcationSearchByID?userID=%@&VatcationID=%@&processid=%@", userID,vatcationid,processid];
        
        NSString *urlStringUTF8 = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", strURL);
        NSURL *url = [NSURL URLWithString:urlStringUTF8];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
        
    }
    
    datePickers = [[UIDatePicker alloc] init]; datePickers.datePickerMode = UIDatePickerModeDate;
    [datePickers setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    datePickere = [[UIDatePicker alloc] init]; datePickere.datePickerMode = UIDatePickerModeDate;
    [datePickere setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];

    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    myDelegate.AppRoveType = @"qingjia";

    totalHeight=Common_CCRowHeight;

    [self datas];
    //self.formTableView.frame=CGRectMake(0,totalHeight-30, self.view.frame.size.width, 500);
    //self.formTableView.frame = CGRectMake(0,StatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-StatusBarAndNavigationBarHeight-TabbarHeight);
    [self.formTableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight);
        
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight-StatusBarAndNavigationBarHeight));
    }];
}

- (void)goBack {
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    [self.view addSubview:toolBar];
    [toolBar  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScreenHeight-TabbarHeight);
        
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, TabbarHeight));
    }];
    
    UIImage* itemImage= [UIImage imageNamed:@"save.png"];
    
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem * addBtn =[[UIBarButtonItem  alloc]initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(addAction)];
    
    //UIBarButtonItem *addBtn=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(addAction)];
    addBtn.width=kScreenWidth/2;
    
    itemImage= [UIImage imageNamed:@"submit.png"];
    
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem * submitBtn =[[UIBarButtonItem  alloc]initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(submitAction)];
    
    //UIBarButtonItem *submitBtn=[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(submitAction)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:addBtn,submitBtn, nil];
    submitBtn.width=kScreenWidth/2;
    
    [toolBar setItems:toolbarItems animated:NO];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    if(animated)
    {
       
        
       
    }
    else
    {
        //跳转的时候走的方法
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *vatcationname = [defaults objectForKey:@"vatcationname"];
        NSLog(@"%@",vatcationname);
        if(vatcationname.length > 0)
        {
            self.VatcationType.info = vatcationname;
            //赋值完毕后清空
            [defaults setObject:@"" forKey:@"vatcationname"];
            [self.formTableView reloadData];
            [self.formTableView layoutIfNeeded];
        }
       
    }
    
   
}

/**
 数据源处理
 */

//实现协议方法，把接收到的值展示
- (void)sendValue:(NSString *)value
{
    self.VatcationType.info = value;
    [self.formTableView beginUpdates];
    [self.formTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.formTableView endUpdates];
}

- (void)datas {
    SWWeakSelf
    NSMutableArray *items = [NSMutableArray array];

    self.VatcationType = SWFormItem_Add(@"请假类型", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
    //self.name.showLength = YES;
    self.VatcationType.maxInputLength = 30;
    self.VatcationType.itemSelectCompletion = ^(SWFormItem *item) {
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        
        [defaults setObject:@"tableviewtype" forKey:@"type"];
        
        
        [defaults synchronize];//保存到磁盘
        
        VatationPageViewController *nextVc = [[VatationPageViewController alloc]init];//初始化下一个界面
      
        nextVc.delegate = self;
        [self presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
 
    };
    [items addObject:_VatcationType];
    
    
    SWFormItem *timecount = SWFormItem_Info(@"年假余额", UserHour, SWFormItemTypeInput);
    timecount.keyboardType = UIReturnKeyDefault;
    [items addObject:timecount];

    self.businessTripStart = SWFormItem_Add(@"开始日期", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
    //self.name.showLength = YES;
    self.businessTripStart.maxInputLength = 30;
    self.businessTripStart.itemSelectCompletion = ^(SWFormItem *item) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil 　　preferredStyle:UIAlertControllerStyleActionSheet];
        [alert.view addSubview:datePickers];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            //实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
            NSString *dateString = [dateFormat stringFromDate:datePickers.date];
            //求出当天的时间字符串
            NSLog(@"%@",dateString);
            self.businessTripStart.info=dateString;
            [self.formTableView beginUpdates];
            [self.formTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            [self.formTableView endUpdates];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            　 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{ }];
    };
    [items addObject:_businessTripStart];
    
    self.businessTripEnd = SWFormItem_Add(@"结束时间", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
    self.businessTripEnd.maxInputLength = 30;
    //self.age.info=@"2019-12-15";
    self.businessTripEnd.itemSelectCompletion = ^(SWFormItem *item) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil 　　preferredStyle:UIAlertControllerStyleActionSheet];
        [alert.view addSubview:datePickere];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            //实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
            NSString *dateString = [dateFormat stringFromDate:datePickere.date];
            //求出当天的时间字符串
            NSLog(@"%@",dateString);
            self.businessTripEnd.info=dateString;
            [self.formTableView beginUpdates];
            [self.formTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            [self.formTableView endUpdates];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            　 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{ }];
    };
    [items addObject:_businessTripEnd];
    
    self.businessNum = SWFormItem_Add(@"请假时长", nil, SWFormItemTypeInput, YES, YES, UIKeyboardTypeNumberPad);
    self.businessNum.maxInputLength = 5;
    self.businessNum.itemUnitType = SWFormItemUnitTypeCustom;
    self.businessNum.unit=@"小时";
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
    
    self.reason = SWFormItem_Add(@"请假理由", @"", SWFormItemTypeTextViewInput, YES, YES, UIKeyboardTypeDefault);
    self.reason.placeholder=@"请输入请假事由";
    self.reason.showLength = YES;
    [items addObject:_reason];
    
    self.image = SWFormItem_Add(@"图片", nil, SWFormItemTypeImage, YES, NO, UIKeyboardTypeDefault);
    self.image.images = @[];
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
    
    if([self.edittype isEqualToString:@"1"]){
        return nil;
    }else{
        UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 60)];
        
//        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        submitBtn.bounds = CGRectMake(0, 0, self.view.bounds.size.width-50, 40);
//        submitBtn.center = footer.center;
//        submitBtn.backgroundColor = [UIColor orangeColor];
//        [submitBtn setTitle:@"查看审批路径" forState:UIControlStateNormal];
//        
        [_btnProcess addTarget:self action:@selector(processAction) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:_btnProcess];
        
        return footer;
        
    }
    
    
}

-(void)processAction{
    WayViewController *nextVc = [[WayViewController alloc]init];//初始化下一个界面
    nextVc.processid=processid;
    [self presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
    if([ boolflag isEqualToString:@"flase"])
    {
        NSLog(@"%@", @"wybuttonclick flag");
        return ;
    }
    else
    {
        NSLog(@"%@", @"wybuttonclick");
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *timesp = [formatter stringFromDate:datePicker.date];
    self.businessTripStart.info =timesp;
    [self.formTableView reloadData];
   
}
- (void)addAction {
    [SWFormHandler sw_checkFormNullDataWithWithDatas:self.mutableItems success:^{
        
     //n保存
      /////
        if(self.VatcationType.info.length > 0)
        {
            
        }
        else
        {
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"请假类型不能为空"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if(self.businessTripStart.info.length > 0)
        {
            
        }
        else
        {
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"开始时间不能为空"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if(self.businessTripEnd.info.length > 0)
        {
            
        }
        else
        {
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"结束时间不能为空"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if(self.businessNum.info.length > 0)
        {
            
        }
        else
        {
            
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"请假时长不能为空"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if(self.reason.info.length > 0)
        {
            
        }
        else
        {
            
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"请假事由不能为空"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        self.urltype = @"keepsave";
        
        //string edittype, string userid, string groupid, string empid, string vtype, string starttime, string endtime, string vatcationtime, string reason, string name, string leavleid, string processid, string imagecount, string applycode
        NSString *type = self.VatcationType.info;
        NSString *timestart = self.businessTripStart.info;
        NSString *timeend =	 self.businessTripEnd.info;
        NSString *vatcationtime = self.businessNum.info;
        NSString *reason = self.reason.info;
        NSString *imagecount = [NSString stringWithFormat:@"%d",self.image.images.count];
        
        if(![self isNumber:vatcationtime])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"请假时长必须为数字"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        // 字符串转float
        float floatString = [vatcationtime floatValue];
        if(floatString<=0)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"请假时长必须大于0"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if(floatString>9999)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"请假时长不能大于9999"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if(self.vatcationid.length >0)
        {
            
        }
        else
        {
            self.vatcationid = @"";
        }
        
        if(processid.length >0)
        {
            
        }
        else
        {
            processid = @"";
        }
        
        if(ApplyCode.length >0)
        {
            
        }
        else
        {
            ApplyCode = @"";
        }
        
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/btnsave_new?ProcessApplyCode=%@&edittype=%@&userid=%@&groupid=%@&empid=%@&vtype=%@&starttime=%@&endtime=%@&vatcationtime=%@&reason=%@&name=%@&leavleid=%@&processid=%@&imagecount=%@&applycode=%@&CelReson=%@",self.ProcessApplyCode, self.edittype,userID,groupid,empID,type,timestart,timeend,vatcationtime,reason,empname,self.vatcationid,processid,imagecount,ApplyCode,self.proCelReson];

        NSString *urlStringUTF8 = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", strURL);
        NSURL *url = [NSURL URLWithString:urlStringUTF8];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
        ////
        
        
        
    } failure:^(NSString *error) {
        //NSLog(@"error====%@",error);
        //返回不为1显示登陆失败
        NSString *message = [[NSString alloc] initWithFormat:@"%@", error];
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: message
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }];
}
- (void)submitAction {
    [SWFormHandler sw_checkFormNullDataWithWithDatas:self.mutableItems success:^{
        
        //提交
        if(self.VatcationType.info.length > 0)
        {
            
        }
        else
        {
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"请假类型不能为空"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if(self.businessTripStart.info.length > 0)
        {
            
        }
        else
        {
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"开始时间不能为空"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if(self.businessTripEnd.info.length > 0)
        {
            
        }
        else
        {
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"结束时间不能为空"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if(self.businessNum.info.length > 0)
        {
            
        }
        else
        {
            
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"请假时长不能为空"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if(self.reason.info.length > 0)
        {
            
        }
        else
        {
           
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"请假事由不能为空"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        self.urltype = @"keepsave";

        //string edittype, string userid, string groupid, string empid, string vtype, string starttime, string endtime, string vatcationtime, string reason, string name, string leavleid, string processid, string imagecount, string applycode
        NSString *type = self.VatcationType.info;
        NSString *timestart = self.businessTripStart.info;
        NSString *timeend = self.businessTripEnd.info;
        NSString *vatcationtime = self.businessNum.info;
        NSString *reason = self.reason.info;
        NSString *imagecount = [NSString stringWithFormat:@"%d",self.image.images.count];
        if(![self isNumber:vatcationtime])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"请假时长必须为数字"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        // 字符串转float
        float floatString = [vatcationtime floatValue];
        if(floatString<=0)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"请假时长必须大于0"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if(floatString>9999)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"请假时长不能大于9999"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if(self.vatcationid.length >0)
        {
            
        }
        else
        {
            self.vatcationid = @"";
        }
        
        if(processid.length >0)
        {
            
        }
        else
        {
            processid = @"";
        }
        
        if(ApplyCode.length >0)
        {
            
        }
        else
        {
            ApplyCode = @"";
        }
        
        
        if([self.edittype isEqual:@"1"]){ //新增进入
            self.edittype=@"4";  //申请 原单海没有申请
        }
        else if([self.edittype isEqual:@"2"]){ //待申请进入
            self.edittype=@"5";  //申请 原单海没有申请
        }
        else if([self.edittype isEqual:@"3"]){ //修改已申请进入
            self.edittype=@"6";  //申请 原单海没有申请
        }
        
        //操作类型：1.新增-保存 4.新增-申请 2.修改-保存 5.修改-申请 3再申请-保存 6.再申请-申请
 
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/btnsave_new?ProcessApplyCode=%@&edittype=%@&userid=%@&groupid=%@&empid=%@&vtype=%@&starttime=%@&endtime=%@&vatcationtime=%@&reason=%@&name=%@&leavleid=%@&processid=%@&imagecount=%@&applycode=%@&CelReson=%@",self.ProcessApplyCode, self.edittype,userID,groupid,empID,type,timestart,timeend,vatcationtime,reason,empname,self.vatcationid,processid,imagecount,ApplyCode,self.proCelReson];
        
        
        
        NSString *urlStringUTF8 = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", strURL);
        NSURL *url = [NSURL URLWithString:urlStringUTF8];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
    
    
    } failure:^(NSString *error) {
        //NSLog(@"error====%@",error);
        //返回不为1显示登陆失败
        NSString *message = [[NSString alloc] initWithFormat:@"%@", error];
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: message
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (BOOL)isNumber:(NSString *)strValue
{
    if (strValue == nil || [strValue length] <= 0)
    {
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filtered = [[strValue componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![strValue isEqualToString:filtered])
    {
        return NO;
    }
    return YES;
}

- (NSString*)CharacterStringMainString:(NSString*)MainString AddDigit:(int)AddDigit AddString:(NSString*)AddString
{
    NSString*ret = [[NSString alloc]init];
    
    ret = MainString;
    for(int y =0;y < (AddDigit - MainString.length) ;y++ ){
        ret = [NSString stringWithFormat:@"%@%@",ret,AddString];
    }
    return ret;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadTableLocation
{
  
    self.formTableView.frame=CGRectMake(0,totalHeight-20, self.view.frame.size.width, 500);
}
- (void)textFieldWithText:(UITextField *)textField
{
    [myData replaceObjectAtIndex:textField.tag withObject:textField.text];
}


//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%@",@"connection1-begin");
    
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if([xmlString isEqualToString:@"OK"])
    {
        return ;
    }
    
    // 字符串截取
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
    NSRange endRagne = [xmlString rangeOfString:@"</string>"];
    NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
    NSString *resultString = [xmlString substringWithRange:reusltRagne];
    
    NSLog(@"%@", resultString);
    
    if([self.urltype isEqualToString:@"getdata"])
    {
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        listOfKeepLeave = [KeepLeave mj_objectArrayWithKeyValuesArray:resultDic];
        
        if(listOfKeepLeave.count > 0)
        {
            KeepLeave *kl = self.listOfKeepLeave[0];
            self.VatcationType.info = kl.vatcationtrpe;
            self.businessTripStart.info = kl.timestart;
            self.businessTripEnd.info = kl.timesend;
            self.businessNum.info = kl.timesum;
            self.reason.info = kl.vatcationreason;
            
            // 日期格式化类
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            // 设置日期格式 为了转换成功
            format.dateFormat = @"yyyy-MM-dd";
            // 时间字符串
            NSString *string = self.businessTripStart.info;
            // NSString * -> NSDate *
            NSDate *data = [format dateFromString:string];
            [datePickers setDate:data animated:YES];
            // 时间字符串
            string = self.businessTripEnd.info;
            // NSString * -> NSDate *
            data = [format dateFromString:string];
            [datePickere setDate:data animated:YES];
            
            NSMutableArray *imagepath = [[NSMutableArray alloc] init];
           
            
            for(NSInteger i = 0;i <listOfKeepLeave.count;i++)
            {
                 KeepLeave *kl2 = self.listOfKeepLeave[i];
                
                if(kl2.imagepath != nil)
                {
                    NSString *imagepath_s =
                    [@"http://47.94.85.101:8095/" stringByAppendingString: kl2.imagepath];
                    
                    UIImage *imagetest = [self SaveImageToLocal:imagepath_s Keys: [NSString stringWithFormat:@"%d",i]];
                    
                    [imagepath addObject:imagetest];
                }
            }
           
            self.image.images =imagepath;

            [self.formTableView reloadData];
        }
    }
    else if([self.urltype isEqualToString:@"keepsave"] )
    {
        
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];

        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        listOfLeave = [LeaveStatusModel mj_objectArrayWithKeyValuesArray:resultDic];
        
        if(listOfLeave.count > 0)
        {
            LeaveStatusModel *m =self.listOfLeave[0];//取出数据元素

            if ([ m.Status isEqualToString:@"suess"])
            {
                ApplyCode = m.ApplyCode;
                processid = m.ProcessID;
                //保存成功 提交成功
                NSString *message=@"提交成功";
                if([self.edittype isEqual:@"1"] || [self.edittype isEqual:@"2"]||[self.edittype isEqual:@"3"]){
                    message=@"保存成功";
                }
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @""
                                      message: message
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
                
                
                    [self uploadImg];
            }
            
        }
        
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
    [self presentViewController:navigationController animated:YES completion:nil];
}

//将图片保存到本地并且从本地返回出来
-(UIImage*)SaveImageToLocal:(NSString*)url Keys:(NSString*)key {

    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    //NSString *urlString = @"http://47.94.85.101:8095/APP/Annex/20191255QJ/1.png";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:url]];
    UIImage *saveimage = [UIImage imageWithData:data]; // 取得图片
    
    //UIImage *testimage = @"http://47.94.85.101:8095/APP/Annex/20191255QJ/1.png";
    
    [preferences setObject:UIImagePNGRepresentation(saveimage) forKey:key];
    
    NSData* imageData = [preferences objectForKey:key];
    UIImage* image;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }
    return image;
    
}



-(void)uploadImg{
    if(self.image.images.count >0)
    {
        for(int i = 0;i<self.image.images.count;i++)
        {
            UIImage *image = self.image.images[i];
            //字典里面装的是你要上传的内容
            NSDictionary *parameters = @{};
            
            //上传的接口
            NSString *urlstring = [NSString stringWithFormat:Common_WSUrl,@"UploadHandler.ashx"];
            //分界线的标识符
            NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
            //根据url初始化request
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring]
                                                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                timeoutInterval:10];
            //分界线 --AaB03x
            NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
            //结束符 AaB03x--
            NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
            //    //要上传的图片
            //    UIImage *image=[params objectForKey:@"pic"];
            //得到图片的data
            NSData *data = UIImagePNGRepresentation(image);
            //http body的字符串
            NSMutableString *body=[[NSMutableString alloc]init];
            //参数的集合的所有key的集合
            NSArray *keys= [parameters allKeys];
            
            //遍历keys
            for(int i=0;i<[keys count];i++)
            {
                //得到当前key
                NSString *key=[keys objectAtIndex:i];
                //如果key不是pic，说明value是字符类型，比如name：Boris
                if(![key isEqualToString:@"pic"])
                {
                    //添加分界线，换行
                    [body appendFormat:@"%@\r\n",MPboundary];
                    //添加字段名称，换2行
                    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
                    //添加字段的值
                    [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
                }
            }
            ////添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //声明pic字段，文件名为boris.png
            NSString *imagename = [self CharacterStringMainString:[NSString stringWithFormat:@"%d",i+1] AddDigit:30 AddString:@" "];
            NSString *name = [self CharacterStringMainString:ApplyCode AddDigit:20 AddString:@" "];
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.png\"\r\n",name,imagename];
            //声明上传文件的格式
            [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
            //声明结束符：--AaB03x--
            NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
            //声明myRequestData，用来放入http body
            NSMutableData *myRequestData=[NSMutableData data];
            //将body字符串转化为UTF8格式的二进制
            [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
            //将image的data加入
            [myRequestData appendData:data];
            //加入结束符--AaB03x--
            [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
            //设置HTTPHeader中Content-Type的值
            NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
            //设置HTTPHeader
            [request setValue:content forHTTPHeaderField:@"Content-Type"];
            //设置Content-Length
            [request setValue:[NSString stringWithFormat:@"%d", (int)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
            //设置http body
            [request setHTTPBody:myRequestData];
            //http method
            [request setHTTPMethod:@"POST"];
            //建立连接，设置代理
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            //设置接受response的data
            if (conn) {
                _mResponseData = [[NSMutableData alloc] init];
            }
        }
    }
}

@end
