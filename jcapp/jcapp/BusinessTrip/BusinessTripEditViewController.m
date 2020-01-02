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
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    empname = [defaults objectForKey:@"empname"];
    groupid = [defaults objectForKey:@"Groupid"];
    
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
    self.formTableView.frame = CGRectMake(0,StatusBarAndNavigationBarHeight+totalHeight, kScreenWidth, 500);
    
//    [self.formTableView  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+totalHeight);
//
//        make.left.mas_equalTo(0);
//        // 添加大小约束
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 500));
//    }];
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
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    businessTripid=myDelegate.businessTripid;
    processid=myDelegate.processid;
    pageType=myDelegate.pageType;
    if([pageType isEqualToString:@"2"]){
        operateType=@"2";
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
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/BusinessTripSearchByID?userID=%@&businessTripID=%@",userID,businessTripid];
    
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
    submitBtn.bounds = CGRectMake(0, 0, self.view.bounds.size.width-50, 40);
    submitBtn.center = footer.center;
    submitBtn.backgroundColor = [UIColor orangeColor];
    [submitBtn setTitle:@"查看审批路径" forState:UIControlStateNormal];
    //[submitBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [submitBtn addTarget:self action:@selector(processAction) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:submitBtn];
    
    return footer;
}
-(void)processAction{
    WayViewController *nextVc = [[WayViewController alloc]init];//初始化下一个界面
    [self presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
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
    [SWFormHandler sw_checkFormNullDataWithWithDatas:self.mutableItems success:^{
        operateType=@"0";
        
        NSDictionary *params3 = [NSDictionary dictionaryWithObjectsAndKeys:                                      myData, @"json",nil];
        //convert object to data
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:params3                                                              options:NSJSONWritingPrettyPrinted error:nil];
        //print out the data contents
        NSString* text =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json字典里面的内容为--》%@", text );
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSLog(@"text字典里面的内容为--》%@", text );
        
        NSString *post = [NSString stringWithFormat:@"userID=%@&processid=%@&businessTripID=%@&empID=%@&groupID=%@&starttime=%@&endtime=%@&businessTripNum=%@&reson=%@&operateType=%@&imageCount=%@&strdetail=%@", self->userID,self->processid,self->businessTripid,self->empID,self->groupid,self.businessTripStart.info,self.businessTripEnd.info,self.businessNum.info,self.reason.info,self->pageType,[NSString stringWithFormat:@"%lu",self.image.images.count],text];
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
            NSLog(@"Request submitted");
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
    [SWFormHandler sw_checkFormNullDataWithWithDatas:self.mutableItems success:^{
        self->operateType=@"0";
        NSDictionary *params3 = [NSDictionary dictionaryWithObjectsAndKeys:                                      self->myData, @"json",nil];
        //convert object to data
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:params3                                                              options:NSJSONWritingPrettyPrinted error:nil];
        //print out the data contents
        NSString* text =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if([self->pageType isEqual:@"2"]){
            self->pageType=@"5";
        }else{
            self->pageType=@"4";
        }
        NSString *post = [NSString stringWithFormat:@"userID=%@&processid=%@&businessTripID=%@&empID=%@&groupID=%@&starttime=%@&endtime=%@&businessTripNum=%@&reson=%@&operateType=%@&imageCount=%@&strdetail=%@", self->userID,self->processid,self->businessTripid,self->empID,self->groupid,self.businessTripStart.info,self.businessTripEnd.info,self.businessNum.info,self.reason.info,self->pageType,[NSString stringWithFormat:@"%lu",self.image.images.count],text];
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
            NSLog(@"Request submitted");
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
    [tableViewPlace reloadData];
    self.formTableView.frame = CGRectMake(0,StatusBarAndNavigationBarHeight+totalHeight, kScreenWidth, 500);
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
        totalHeight=totalHeight+Common_CCRowHeight;
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
        totalHeight=totalHeight-Common_CCRowHeight;
        [self LoadTableLocation];
        //NSLog(@"indexPath.row:%@;mydata:%@",indexPath.row,myData.count);
    }
    
}

//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(![operateType isEqual:@"3"] ){
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"xmlString:%@",xmlString);
        // 字符串截取
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
        NSRange endRagne = [xmlString rangeOfString:@"</string>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSLog(@"requestTmp:%@",requestTmp);
        if([requestTmp isEqual:@"-1"]){
            NSString *message = [[NSString alloc] initWithFormat:@"%@", @"出差日期已存在！"];
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: message
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        //上传图片
        if([operateType isEqual:@"0"]){
            //接收返回的起案番号
            applyCode=requestTmp;
            operateType=@"3";
            [self uploadImg];
        }
        
        if([operateType isEqual:@"2"]){
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
            
            //解析出差地点数据
            resData = [[NSData alloc] initWithData:[array[1] dataUsingEncoding:NSUTF8StringEncoding]];
            resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"resultDic1:%@",resultDic);
            myData = [[NSMutableArray alloc]init];
            for (NSDictionary *obj in resultDic) {
                [myData addObject:[obj objectForKey:@"BusinessTripPlace"]];
            }
            
            //解析图片数据
            resData = [[NSData alloc] initWithData:[array[2] dataUsingEncoding:NSUTF8StringEncoding]];
            resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"resultDic1:%@",resultDic);
            NSMutableArray *imagepath = [[NSMutableArray alloc] init];
            for (NSDictionary *obj in resultDic) {
                [myData addObject:[obj objectForKey:@"AnnexPath"]];
                
                NSString *userurlString =[NSString stringWithFormat:Common_WSUrl,[obj objectForKey:@"AnnexPath"]];
                
                UIImage *imagetest = [self SaveImageToLocal:userurlString Keys: [NSString stringWithFormat:@"%@",[obj objectForKey:@"AnnexName"]]];
                
                [imagepath addObject:imagetest];
            }
            self.image.images =imagepath;
            
            [self.formTableView reloadData];
            [tableViewPlace reloadData];
        }
    }
}
//将图片保存到本地并且从本地返回出来
-(UIImage*)SaveImageToLocal:(NSString*)url Keys:(NSString*)key {
    
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:url]];
    UIImage *saveimage = [UIImage imageWithData:data]; // 取得图片
    
    [preferences setObject:UIImagePNGRepresentation(saveimage) forKey:key];
    
    NSData* imageData = [preferences objectForKey:key];
    UIImage* image;
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }
    return image;
    
}
- (void)goBack {
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    myDelegate.tabbarType=@"6";
    UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
    [self presentViewController:navigationController animated:YES completion:nil];
}
////弹出消息框
//-(void) connection:(NSURLConnection *)connection
//  didFailWithError: (NSError *)error {
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle: [error localizedDescription]
//                               message: [error localizedFailureReason]
//                               delegate:nil
//                               cancelButtonTitle:@"OK"
//                               otherButtonTitles:nil];
//    [errorAlert show];
//}
//
////解析返回的xml系统自带方法不需要h中声明
//- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
//
//    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
//    ipParser.delegate = self;
//    [ipParser parse];
//    //[self.NewTableView reloadData];
//}
//
////解析xml回调方法
//- (void)parserDidStartDocument:(NSXMLParser *)parser {
//    info = [[NSMutableDictionary alloc] initWithCapacity: 1];
//}
//
////回调方法出错弹框
//- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle: [parseError localizedDescription]
//                               message: [parseError localizedFailureReason]
//                               delegate:nil
//                               cancelButtonTitle:@"OK"
//                               otherButtonTitles:nil];
//    [errorAlert show];
//}
//
////解析返回xml的节点elementName
//- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
//  namespaceURI:(NSString *)namespaceURI
// qualifiedName:(NSString *)qualifiedName
//    attributes:(NSDictionary *)attributeDict  {
//    NSLog(@"value2: %@\n", elementName);
//    //NSLog(@"%@", @"jiedian1");    //设置标记查看解析到哪个节点
//    currentTagName = elementName;
//
//}
//
////取得我们需要的节点的数据
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//
//    NSLog(@"%@",@"parser3-begin");
//
//}
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
//  namespaceURI:(NSString *)namespaceURI
// qualifiedName:(NSString *)qName {
//
//}
//
////循环解析d节点
//- (void)parserDidEndDocument:(NSXMLParser *)parser {
//
//    NSLog(@"%@",@"parserDidEndDocument-begin");
//
//    NSMutableString *outstring = [[NSMutableString alloc] initWithCapacity: 1];
//    for (id key in info) {
//        [outstring appendFormat: @"%@: %@\n", key, [info objectForKey:key]];
//    }
//
//    //[outstring release];
//    //[xmlString release];
//}
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
