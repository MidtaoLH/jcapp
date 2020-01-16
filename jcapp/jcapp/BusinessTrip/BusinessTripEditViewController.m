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
#import "../MJRefresh/MJRefresh.h"
#import "../MJExtension/MJExtension.h"
#import "../AppDelegate.h"
#import "../VatationPage/WayViewController.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#import "Masonry.h"
#import "TabBarViewController.h"
#import "LeaveStatusModel.h"

NSString * bflag = @"flase";
@interface BusinessTripEditViewController ()<UIActionSheetDelegate>
@property (nonatomic, strong) NSArray *genders;
@property (nonatomic, strong) SWFormItem *businessTripStart;
@property (nonatomic, strong) SWFormItem *businessTripEnd;
@property (nonatomic, strong) SWFormItem *businessNum;
@property (nonatomic, strong) SWFormItem *gender;
@property (nonatomic, strong) SWFormItem *reason;
@property (nonatomic, strong) SWFormItem *image;
@property (nonatomic, strong) NSMutableData *mResponseData;
@end
@implementation BusinessTripEditViewController

- (void)viewDidLoad
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    empname = [defaults objectForKey:@"empname"];
    groupid = [defaults objectForKey:@"Groupid"];
    
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.businessTripid=myDelegate.businessTripid;
    self.processid=myDelegate.processid;
    self.pageType=myDelegate.pageType;
    isLoad=@"true";

    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.title=@"出差申请";
    
    datePickers = [[UIDatePicker alloc] init]; datePickers.datePickerMode = UIDatePickerModeDate;
    [datePickers setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    datePickere = [[UIDatePicker alloc] init]; datePickere.datePickerMode = UIDatePickerModeDate;
    [datePickere setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    //totalcount=1;
    totalHeight=Common_CCRowHeight;
    //tableViewPlace.backgroundColor=UIColor.blueColor;
    tableViewPlace.frame = CGRectMake(0,StatusBarAndNavigationBarHeight, kScreenWidth, totalHeight);
    
//    [tableViewPlace mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(StatusBarAndNavigationBarHeight);
//
//        make.left.mas_equalTo(0);
//        // 添加大小约束
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, totalHeight));
//    }];
    tableViewPlace.rowHeight=Common_CCRowHeight;
    myData = [[NSMutableArray alloc]initWithObjects:@"",nil];
    //[myData insertObject:@"f" atIndex:0];

    self.genders = @[@"男",@"女"];
    [self datas];
    self.formTableView.frame = CGRectMake(0,StatusBarAndNavigationBarHeight+totalHeight, self.view.width, kScreenHeight-StatusBarAndNavigationBarHeight-totalHeight);
    
//    [self.formTableView  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+totalHeight);
//
//        make.left.mas_equalTo(0);
//        // 添加大小约束
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight-StatusBarAndNavigationBarHeight-totalHeight));
//    }];
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

    
    if([_pageType isEqualToString:@"2"] ||[_pageType isEqualToString:@"3"]){
        _operateType=@"2";
        //修改画面 加载数据
        [self LoadData];
        
    }
    
}
//修改画面 初始化 加载数据
-(void)LoadData
{
    //设置需要访问的ws和传入参数
    // code, string userID, string menuID
    //设置需要访问的ws和传入参数
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/BusinessTripSearchByID?userID=%@&businessTripID=%@",userID,_businessTripid];
    
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
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
    
    self.businessTripEnd = SWFormItem_Add(@"返回日期", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
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
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//
//        [defaults setObject:@"tableviewsend" forKey:@"type"];
//        [defaults synchronize];//保存到磁盘
//        CalendaViewController *nextVc = [[CalendaViewController alloc]init];//初始化下一个界面
//        [self presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
    };
    [items addObject:_businessTripEnd];
    
    self.businessNum = SWFormItem_Add(@"出差天数", nil, SWFormItemTypeInput, YES, YES, UIKeyboardTypeNumberPad);
    self.businessNum.maxInputLength = 4;
    self.businessNum.itemUnitType = SWFormItemUnitTypeCustom;
    self.businessNum.unit=@"天";
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
    
    self.reason = SWFormItem_Add(@"出差事由", @"", SWFormItemTypeTextViewInput, YES, YES, UIKeyboardTypeDefault);
    self.reason.showLength = YES;
    self.reason.placeholder=@"请输入出差事由";
    [items addObject:_reason];
    
    self.image = SWFormItem_Add(@"图片", nil, SWFormItemTypeImage, YES, NO, UIKeyboardTypeDefault);
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
    if([_pageType isEqualToString:@"1"]){
        return nil;
    }else{
        UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 60)];
        [_btnProcess addTarget:self action:@selector(processAction) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:_btnProcess];
        [_btnProcess  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(kScreenWidth-40);
        }];
        
        return footer;
    }
    
}
- (BOOL) isNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"^(\\-|\\+)?\\d+(\\.\\d+)?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

-(void)processAction{
    WayViewController *nextVc = [[WayViewController alloc]init];//初始化下一个界面
    nextVc.processid=_processid;
    nextVc.vatcationid=_businessTripid;
    nextVc.pageTypeID=@"2";
        [self.navigationController pushViewController:nextVc animated:YES];
    if([ bflag isEqualToString:@"flase"])
    {
        NSLog(@"%@", @"wybuttonclick flag");
        return ;
    }
    else
    {
        
        //tiaozhuan
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
    //[actionSheet release];
    
//    if (actionSheet.tag == 10) {
//        if (buttonIndex != 0) {
//            //self.gender.info = self.genders[buttonIndex-1];
//            [self.formTableView reloadData];
//        }
//    }
}
-(void)uploadImg{
    imgcount=self.image.images.count;
    errImgCount=0;
    rightImgCount=0;
    if(self.image.images.count >0)
    {
        for(int i = 0;i<self.image.images.count;i++)
        {
            UIImage *image = self.image.images[i];
            //收缩图片 第二个参数取值 0.0~1.0，值越小表示图片质量越低，图片文件越小
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            //UIImage *resultImage = [UIImage imageWithData:data];
            
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
            //NSData *data = UIImagePNGRepresentation(image);
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
            NSString *name = [self CharacterStringMainString:applyCode AddDigit:20 AddString:@" "];
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
- (void)addAction {
    NSMutableArray *myDataCopy=[[NSMutableArray alloc]init];
    for (int i=0; i<myData.count; i++) {
        NSString *ele=myData[i];
        [myDataCopy addObject:ele];
    }
    [myDataCopy removeObject:@""];
    if(myDataCopy.count==0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"请输入出差地点"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [SWFormHandler sw_checkFormNullDataWithWithDatas:self.mutableItems success:^{
        if(![self isNumber:self.businessNum.info])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"出差天数必须为数字"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if(![self isTwoFloat:self.businessNum.info])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"出差天数只能保留1位小数"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        // 字符串转float
        float floatString = [self.businessNum.info floatValue];
        if(floatString<=0)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"出差天数必须大于0"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if(floatString>365)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"出差天数不能大于365"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        self->_operateType=@"0";
        
        if([self->_pageType isEqual:@"4"]){
            self->_pageType=@"1";
        }else if([self->_pageType isEqual:@"5"]){
            self->_pageType=@"2";
        }else{
            self->_pageType=@"3";
        }
        
        NSDictionary *params3 = [NSDictionary dictionaryWithObjectsAndKeys:                                      myDataCopy, @"json",nil];
        //convert object to data
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:params3                                                              options:NSJSONWritingPrettyPrinted error:nil];
        //print out the data contents
        NSString* text =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json字典里面的内容为--》%@", text );
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSLog(@"text字典里面的内容为--》%@", text );
        
        NSString *post = [NSString stringWithFormat:@"userID=%@&processid=%@&businessTripID=%@&empID=%@&groupID=%@&starttime=%@&endtime=%@&businessTripNum=%@&reson=%@&operateType=%@&imageCount=%@&strdetail=%@", self->userID,self->_processid,self->_businessTripid,self->empID,self->groupid,self.businessTripStart.info,self.businessTripEnd.info,self.businessNum.info,self.reason.info,self->_pageType,[NSString stringWithFormat:@"%lu",self.image.images.count],text];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
        NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/BusinessTripSave?"];
        NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
        NSURL *webServiceURL = [NSURL URLWithString:strURL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webServiceURL];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request delegate:self];
        if (!connection) {
            NSLog(@"Failed to submit request");
        } else {
            
        }
        

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
    NSMutableArray *myDataCopy=[[NSMutableArray alloc]init];
    for (int i=0; i<myData.count; i++) {
        NSString *ele=myData[i];
        [myDataCopy addObject:ele];
    }
    [myDataCopy removeObject:@""];
    if(myDataCopy.count==0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"请输入出差地点"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [SWFormHandler sw_checkFormNullDataWithWithDatas:self.mutableItems success:^{
        if(![self isNumber:self.businessNum.info])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"出差天数必须为数字"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if(![self isTwoFloat:self.businessNum.info])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"出差天数只能保留1位小数"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        // 字符串转float
        float floatString = [self.businessNum.info floatValue];
        if(floatString<=0)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"出差天数必须大于0"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if(floatString>365)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"出差天数不能大于365"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        self->_operateType=@"0";
        NSDictionary *params3 = [NSDictionary dictionaryWithObjectsAndKeys:                                      self->myData, @"json",nil];
        //convert object to data
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:params3                                                              options:NSJSONWritingPrettyPrinted error:nil];
        //print out the data contents
        NSString* text =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //NSLog(@"text字典里面的内容为--》%@", text );
        if([self->_pageType isEqual:@"1"]){
            self->_pageType=@"4";
        }else if([self->_pageType isEqual:@"2"]){
            self->_pageType=@"5";
        }else{
            self->_pageType=@"6";
        }
        NSString *post = [NSString stringWithFormat:@"userID=%@&processid=%@&businessTripID=%@&empID=%@&groupID=%@&starttime=%@&endtime=%@&businessTripNum=%@&reson=%@&operateType=%@&imageCount=%@&strdetail=%@", self->userID,self->_processid,self->_businessTripid,self->empID,self->groupid,self.businessTripStart.info,self.businessTripEnd.info,self.businessNum.info,self.reason.info,self->_pageType,[NSString stringWithFormat:@"%lu",self.image.images.count],text];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
        NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/BusinessTripSave?"];
        NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
        NSURL *webServiceURL = [NSURL URLWithString:strURL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webServiceURL];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request delegate:self];
        if (!connection) {
            NSLog(@"Failed to submit request");
        } else {
            
        }
        
        
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
- (BOOL) isTwoFloat:(NSString *)str
{
    NSInteger flag = 0;
    const NSInteger limited = 1;
    for (NSInteger i = str.length - 1; i >= 0; i--) {
        if ([str characterAtIndex:i] == '.') {
            // 如果大于了限制的就提示
            if (flag > limited) {
                return NO;
            }
        }
        flag++;
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
    tableViewPlace.height=totalHeight;
//    [tableViewPlace mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(StatusBarAndNavigationBarHeight);
//
//        make.left.mas_equalTo(0);
//        // 添加大小约束
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, totalHeight));
//    }];
    //[tableViewPlace reloadData];
    [tableViewPlace beginUpdates];
    [tableViewPlace reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [tableViewPlace endUpdates];
    self.formTableView.frame = CGRectMake(0,StatusBarAndNavigationBarHeight+totalHeight, self.view.width, kScreenHeight-StatusBarAndNavigationBarHeight-totalHeight-TabbarHeight);
//    [self.formTableView  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+totalHeight);
//
//        make.left.mas_equalTo(0);
//        // 添加大小约束
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight-StatusBarAndNavigationBarHeight-totalHeight));
//    }];
//    [self.formTableView  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+totalHeight);
//        make.left.mas_equalTo(0);
//        // 添加大小约束
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 500));
//    }];
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
        if(totalHeight<Common_CCRowHeight*4){
            totalHeight=totalHeight+Common_CCRowHeight;
        }
        [self LoadTableLocation];
        //NSLog(@"indexPath.row:%@;mydata:%@",indexPath.row,myData.count);
        
    }
    
}
- (void)cellBtnClicked:(id)sender event:(id)event
{
    if(myData.count==1){//h至少有一条数据
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @""
                              message: @"出差地点至少保留一行数据"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSSet *touches =[event allTouches];
    
    UITouch *touch =[touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:tableViewPlace];
    
    NSIndexPath *indexPath= [tableViewPlace indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath!= nil) {
        
        // do something
        //totalcount--;
        [myData removeObjectAtIndex:indexPath.row];
        if(myData.count<4){
            totalHeight=totalHeight-Common_CCRowHeight;
        }
        [self LoadTableLocation];
        //NSLog(@"indexPath.row:%@;mydata:%@",indexPath.row,myData.count);
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alert isEqual:@"save"]){
        UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}
//弹出消息框
-(void) connection:(NSURLConnection *)connection
  didFailWithError: (NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: @""
                               message: Common_NetErrMsg
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    
}

//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(![_operateType isEqual:@"3"] ){
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"xmlString:%@",xmlString);
        // 字符串截取
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
        NSRange endRagne = [xmlString rangeOfString:@"</string>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSLog(@"requestTmp:%@",requestTmp);
        
        //上传图片
        if([_operateType isEqual:@"0"]){
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            NSMutableArray *listbusiness = [LeaveStatusModel mj_objectArrayWithKeyValuesArray:resultDic];
            if(listbusiness.count > 0)
            {
                LeaveStatusModel *m =listbusiness[0];//取出数据元素
                //接收返回的起案番号
                applyCode=m.ApplyCode;
                if([applyCode isEqualToString:@"-1"] || [applyCode isEqualToString:@"-2"]){
                    NSString *message = [[NSString alloc] initWithFormat:@"%@", @"出差日期已存在！"];
                    if([applyCode isEqualToString:@"-2"] ){
                        message=@"返回日期必须大于出发日期";
                    }
                    //显示信息。正式环境时改为跳转
                    UIAlertView *alert = [[UIAlertView alloc]  initWithTitle: @"" message: message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                if([m.ProcessID isEqualToString:@"0"]){
                    //保存成功 提交成功
                    NSString *message=@"提交失败";
                    if([self->_pageType isEqual:@"1"] || [self->_pageType isEqual:@"2"]||[self->_pageType isEqual:@"3"]){
                        message=@"保存失败";
                    }
                    alert=@"save";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                _businessTripid=m.LeaveID;
                _processid=m.ProcessID;
                _pageType=@"2";
                if(self.image.images.count >0){
                    _operateType=@"3";
                    [self uploadImg];
                }
                else{
                    //保存成功 提交成功
                    NSString *message=@"提交成功";
                    if([self->_pageType isEqual:@"1"] || [self->_pageType isEqual:@"2"]||[self->_pageType isEqual:@"3"]){
                        message=@"保存成功";
                    }
                    alert=@"save";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                
            }
            
        }
        
        if([_operateType isEqual:@"2"] && [isLoad isEqualToString:@"true"]){
            //将明细数据拆分，头表数据及出差地点数据
            NSArray *array = [requestTmp componentsSeparatedByString:@"+"];
            //解析头表数据
            NSData *resData = [[NSData alloc] initWithData:[array[0] dataUsingEncoding:NSUTF8StringEncoding]];
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *resultDic0;
            NSLog(@"resultDic0:%@",resultDic);
            //NSEnumerator *enumeratorkey=[mutableDictionary resultDic];
            for (NSDictionary *obj in resultDic) {
                resultDic0=obj;
            }
            
            self.businessTripStart.info=[resultDic0 objectForKey:@"BeignDate"];
            self.businessTripEnd.info=[resultDic0 objectForKey:@"EndDate"];
            self.businessNum.info=[resultDic0 objectForKey:@"BusinessNum"];
            self.reason.info=[resultDic0 objectForKey:@"BusinessTripReason"];
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
            
            //解析出差地点数据
            resData = [[NSData alloc] initWithData:[array[1] dataUsingEncoding:NSUTF8StringEncoding]];
            resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"resultDic1:%@",resultDic);
            myData = [[NSMutableArray alloc]init];
            for (NSDictionary *obj in resultDic) {
                [myData addObject:[obj objectForKey:@"BusinessTripPlace"]];
            }
            totalHeight=totalHeight+Common_CCRowHeight*(resultDic.count-1);
            if(totalHeight>Common_CCRowHeight*4){
                totalHeight=Common_CCRowHeight*4;
            }
            
            //解析图片数据
            resData = [[NSData alloc] initWithData:[array[2] dataUsingEncoding:NSUTF8StringEncoding]];
            resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"resultDic1:%@",resultDic);
            NSMutableArray *imagepath = [[NSMutableArray alloc] init];
            for (NSDictionary *obj in resultDic) {
                
                NSString *userurlString =[NSString stringWithFormat:Common_WSUrl,[obj objectForKey:@"AnnexPath"]];
                
                UIImage *imagetest = [self SaveImageToLocal:userurlString Keys: [NSString stringWithFormat:@"%@",[obj objectForKey:@"AnnexName"]]];
                if (imagetest) {
                    [imagepath addObject:imagetest];
                }
                
            }
            self.image.images =imagepath;
            
            [self.formTableView reloadData];
            [self LoadTableLocation];
            isLoad=@"false";
        }
    }
    else{
        if(rightImgCount+errImgCount==imgcount){
            return;
        }
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *message=@"";
        if([xmlString isEqualToString:@"OK"]){
            rightImgCount++;
            if(rightImgCount==imgcount){
                //保存成功 提交成功
                message=@"提交成功";
                if([self->_pageType isEqual:@"1"] || [self->_pageType isEqual:@"2"]||[self->_pageType isEqual:@"3"]){
                    message=@"保存成功";
                }
                alert=@"save";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"" message: message
                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        else{
            if(errImgCount==0){
                message=@"图片上传失败，请重新提交";
                if([self->_pageType isEqual:@"1"] || [self->_pageType isEqual:@"2"]||[self->_pageType isEqual:@"3"]){
                    message=@"图片上传失败，请重新保存";
                }
                alert=@"";
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"" message: message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            errImgCount--;
        }
    }
}
//将图片保存到本地并且从本地返回出来
-(UIImage*)SaveImageToLocal:(NSString*)url Keys:(NSString*)key {
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:url]];
    UIImage *saveimage = [UIImage imageWithData:data]; // 取得图片
    
    //[preferences setObject:UIImagePNGRepresentation(saveimage) forKey:key];
    
    NSData* imageData = [preferences objectForKey:key];
    UIImage* image;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }
    return image;
    
}
- (void)goBack {
    UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
