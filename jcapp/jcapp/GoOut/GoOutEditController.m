//
//  VatcationMainView.m
//  jcapp
//
//  Created by zhaodan on 2019/12/17.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "GoOutEditController.h"
#import "SWForm.h"
#import "SWFormHandler.h"
#import "../VatationPage/CalendaViewController.h"
#import "../MJRefresh/MJRefresh.h"
#import "../MJExtension/MJExtension.h"
#import "AppDelegate.h"
#import "VatationPageViewController.h"
#import "KeepLeave.h"
#import "LeaveStatusModel.h" 

@interface GoOutEditController ()<UIActionSheetDelegate>
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

@implementation GoOutEditController

@synthesize listOfKeepLeave;
@synthesize listOfLeave;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    empname = [defaults objectForKey:@"empname"];
    groupid = [defaults objectForKey:@"Groupid"];
    UserHour = [defaults objectForKey:@"UserHour"];
    
    edittype = @"NEW";
    //edittype = @"EDIT";
    
    if([edittype isEqualToString:@"EDIT"])
    {
        vatcationid = @"10688";
        urltype = @"getdata";
        processid = @"22798";
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
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.AppRoveType = @"waichu";
    
    totalHeight=150;
    
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
        }
        
    }
    
    
}

/**
 数据源处理
 */
- (void)datas {
    SWWeakSelf
    NSMutableArray *items = [NSMutableArray array];
 
    self.businessTripStart = SWFormItem_Add(@"出发时间", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
    //self.name.showLength = YES;
    self.businessTripStart.maxInputLength = 30;
    self.businessTripStart.itemSelectCompletion = ^(SWFormItem *item) {
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
        
        /////
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeTime;
        datePicker.frame = CGRectMake(0, 40,272,60);
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSDate *minDate = [fmt dateFromString:@"1930-01-01"];
        NSDate *maxDate = [fmt dateFromString:@"2099-01-01"];
            datePicker.minimumDate = minDate; // 设置最小时间
            datePicker.maximumDate = maxDate; // 设置最大时间
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        datePicker.locale = locale;
            datePicker.datePickerMode = UIDatePickerModeDate;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert.view addSubview:datePicker];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            //设置时间格式
            dateFormat.dateFormat = @"yyyy-MM-dd";
            
            NSString *dateString = [dateFormat stringFromDate:datePicker.date];
            
            NSLog(@"%@",dateString);
            
            self.businessTripStart.info =dateString;
            [self.formTableView reloadData];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:ok];//添加按钮
        [alert addAction:cancel];//添加按钮
        [self presentViewController:alert animated:YES completion:^{ }];
        ////////
        
    };
    [items addObject:_businessTripStart];
    
    self.businessTripEnd = SWFormItem_Add(@"返回时间", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
    self.businessTripEnd.maxInputLength = 30;
    //self.age.info=@"2019-12-15";
    self.businessTripEnd.itemSelectCompletion = ^(SWFormItem *item) {
        
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
        
        /////
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeTime;
        datePicker.frame = CGRectMake(0, 40,272,60);
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        NSDate *minDate = [fmt dateFromString:@"1930-01-01"];
        NSDate *maxDate = [fmt dateFromString:@"2099-01-01"];
            datePicker.minimumDate = minDate; // 设置最小时间
            datePicker.maximumDate = maxDate; // 设置最大时间
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        datePicker.locale = locale;
            datePicker.datePickerMode = UIDatePickerModeDate;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert.view addSubview:datePicker];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            //设置时间格式
            dateFormat.dateFormat = @"yyyy-MM-dd";
            
            NSString *dateString = [dateFormat stringFromDate:datePicker.date];
            
            NSLog(@"%@",dateString);
            
            self.businessTripEnd.info =dateString;
            [self.formTableView reloadData];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        [alert addAction:ok];//添加按钮
        [alert addAction:cancel];//添加按钮
        [self presentViewController:alert animated:YES completion:^{ }];
        ////////
    };
    [items addObject:_businessTripEnd];
    
    self.businessNum = SWFormItem_Add(@"外出时长(h)", nil, SWFormItemTypeInput, YES, YES, UIKeyboardTypeNumberPad);
    self.businessNum.maxInputLength = 5;
    self.businessNum.itemUnitType = SWFormItemUnitTypeNone;
    [items addObject:_businessNum];
 
    self.reason = SWFormItem_Add(@"外出理由", @"请输入外出事由", SWFormItemTypeTextViewInput, YES, YES, UIKeyboardTypeDefault);
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
    
}
- (void)addAction {
    [SWFormHandler sw_checkFormNullDataWithWithDatas:self.mutableItems success:^{
        
        //n保存
        /////
 
        if(self.businessTripStart.info.length > 0)
        {
            
        }
        else
        {
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息！"
                                  message: @"出发时间不能为空！"
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
                                  initWithTitle: @"提示信息！"
                                  message: @"返回时间不能为空！"
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
                                  initWithTitle: @"提示信息！"
                                  message: @"时长不能为空！"
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
                                  initWithTitle: @"提示信息！"
                                  message: @"事由不能为空！"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        urltype = @"keepsave";
        
        //string edittype, string userid, string groupid, string empid, string vtype, string starttime, string endtime, string vatcationtime, string reason, string name, string leavleid, string processid, string imagecount, string applycode
        NSString *type = self.VatcationType.info;
        NSString *timestart = self.businessTripStart.info;
        NSString *timeend = self.businessTripEnd.info;
        NSString *vatcationtime = self.businessNum.info;
        NSString *reason = self.reason.info;
        NSString *imagecount = [NSString stringWithFormat:@"%d",self.image.images.count];
        
        if(vatcationid.length >0)
        {
            
        }
        else
        {
            vatcationid = @"";
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
        
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GoOutSave?edittype=%@&userid=%@&groupid=%@&empid=%@&vtype=%@&starttime=%@&endtime=%@&vatcationtime=%@&reason=%@&name=%@&leavleid=%@&processid=%@&imagecount=%@&applycode=%@", edittype,userID,groupid,empID,type,timestart,timeend,vatcationtime,reason,empname,vatcationid,processid,imagecount,ApplyCode];
        
        
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
        NSLog(@"error====%@",error);
    }];
}
- (void)submitAction {
    
    [SWFormHandler sw_checkFormNullDataWithWithDatas:self.mutableItems success:^{
        
        //提交
 
        if(self.businessTripStart.info.length > 0)
        {
            
        }
        else
        {
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息！"
                                  message: @"出发时间不能为空！"
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
                                  initWithTitle: @"提示信息！"
                                  message: @"返回时间不能为空！"
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
                                  initWithTitle: @"提示信息！"
                                  message: @"时长不能为空！"
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
                                  initWithTitle: @"提示信息！"
                                  message: @"事由不能为空！"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        urltype = @"keepsave";
        
        //string edittype, string userid, string groupid, string empid, string vtype, string starttime, string endtime, string vatcationtime, string reason, string name, string leavleid, string processid, string imagecount, string applycode
        NSString *type = self.VatcationType.info;
        NSString *timestart = self.businessTripStart.info;
        NSString *timeend = self.businessTripEnd.info;
        NSString *vatcationtime = self.businessNum.info;
        NSString *reason = self.reason.info;
        NSString *imagecount = [NSString stringWithFormat:@"%d",self.image.images.count];
        
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/btnapply?edittype=%@&userid=%@&groupid=%@&empid=%@&vtype=%@&starttime=%@&endtime=%@&vatcationtime=%@&reason=%@&name=%@&leavleid=%@&processid=%@&imagecount=%@&applycode=%@", edittype,userID,groupid,empID,type,timestart,timeend,vatcationtime,reason,empname,vatcationid,processid,imagecount,ApplyCode];
        
        
        
        NSString *urlStringUTF8 = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", strURL);
        NSURL *url = [NSURL URLWithString:urlStringUTF8];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
        
        
    } failure:^(NSString *error) {
        NSLog(@"error====%@",error);
    }];
    
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
    
    if([urltype isEqualToString:@"getdata"])
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
            
            NSMutableArray *imagepath = [[NSMutableArray alloc] init];
            
            
            for(NSInteger i = 0;i <listOfKeepLeave.count;i++)
            {
                KeepLeave *kl2 = self.listOfKeepLeave[i];
                
                NSString *imagepath_s =
                [@"http://47.94.85.101:8095/" stringByAppendingString: kl2.imagepath];
                
                
                UIImage *imagetest = [self SaveImageToLocal:imagepath_s Keys: [NSString stringWithFormat:@"%d",i]];
                
                [imagepath addObject:imagetest];
            }
            
            
            self.image.images =imagepath;
            
            [self.formTableView reloadData];
        }
    }
    else if([urltype isEqualToString:@"keepsave"] )
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
                [self uploadImg];
            }
            
        }
        
    }
    
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