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

static NSInteger rowHeight=50;
@interface VatcationMainView ()<UIActionSheetDelegate>
@property (nonatomic, strong) NSArray *genders;
@property (nonatomic, strong) SWFormItem *businessTripStart;
@property (nonatomic, strong) SWFormItem *businessTripEnd;
@property (nonatomic, strong) SWFormItem *businessNum;
@property (nonatomic, strong) SWFormItem *gender;
@property (nonatomic, strong) SWFormItem *reason;
@property (nonatomic, strong) SWFormItem *image;

@property (nonatomic, strong) NSMutableData *mResponseData;
@end

@implementation VatcationMainView

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    empname = [defaults objectForKey:@"empname"];
    groupid = [defaults objectForKey:@"Groupid"];
    
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
    
    self.businessTripStart = SWFormItem_Add(@"开始时间", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
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
    
    self.businessTripEnd = SWFormItem_Add(@"结束时间", nil, SWFormItemTypeSelect, YES, YES, UIKeyboardTypeDefault);
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
    
    self.businessNum = SWFormItem_Add(@"请假时长(h)", nil, SWFormItemTypeInput, YES, YES, UIKeyboardTypeNumberPad);
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
    
    self.reason = SWFormItem_Add(@"请假理由", @"请输入请假事由", SWFormItemTypeTextViewInput, YES, YES, UIKeyboardTypeDefault);
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
        NSLog(@"text字典里面的内容为--》%@", text );
        
        NSString *post = [NSString stringWithFormat:@"userID=%@&processid=%@&businessTripID=%@&empID=%@&groupID=%@&starttime=%@&endtime=%@&businessTripNum=%@&reson=%@&operateType=%@&strdetail=%@",
                          userID,@"0",@"0",empID,groupid,self.businessTripStart.info,self.businessTripEnd.info,self.businessNum.info,self.reason.info,@"1",text];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *webServiceURL = [NSURL URLWithString:@"http://47.94.85.101:8095/AppWebService.asmx/BusinessTripSave?"];
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
        NSLog(@"error====%@",error);
    }];
}
- (void)submitAction {
    [SWFormHandler sw_checkFormNullDataWithWithDatas:self.mutableItems success:^{
        
        NSLog(@"selectImages === %@", self.image.selectImages);
        //NSLog(@"images === %@", image.images);
        NSLog(@"businessTripEnd === %@", self.businessTripEnd.info);
        NSLog(@"businessTripStart === %@", self.businessTripStart.info);
        
        if(self.image.images.count >0)
        {
            for(int i = 0;i<self.image.images.count;i++)
            {
                UIImage *image = self.image.images[0];
                //字典里面装的是你要上传的内容
                NSDictionary *parameters = @{};
                
                //上传的接口
                NSString* urlstring = @"http://47.94.85.101:8095/UploadHandler.ashx";
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
                NSString *imagename = [self CharacterStringMainString:@"test" AddDigit:30 AddString:@" "];
                [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@.png\"\r\n",imagename];
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

//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%@",@"connection1-begin");
    
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", @"34443333kaishidayin");
    NSLog(@"%@", xmlString);
    
    // 字符串截取
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
    NSRange endRagne = [xmlString rangeOfString:@"</string>"];
    NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
    NSString *resultString = [xmlString substringWithRange:reusltRagne];
    
    NSLog(@"%@", resultString);
    
    NSString *requestTmp = [NSString stringWithString:resultString];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"%@",@"connection1-end");
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
