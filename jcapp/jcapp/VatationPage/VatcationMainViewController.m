//
//  VatcationMainViewController.m
//  jcapp
//
//  Created by zhaodan on 2019/11/26.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "VatcationMainViewController.h"
#import "CalendaViewController.h"
#import "VatationPageViewController.h"
#import "ViewController.h"
#import "WayViewController.h"
#import "../MJExtension/MJExtension.h"
#import "../Model/LeaveStatusModel.h"
#import "AppDelegate.h"


NSString * flag = @"flase";
@interface VatcationMainViewController ()

@end

@implementation VatcationMainViewController

@synthesize txttime;
@synthesize textviewreason1;
@synthesize listOfLeave;
@synthesize waybutton;

- (void)viewDidLoad {
    [super viewDidLoad];
    txttime.textAlignment = NSTextAlignmentRight;//
    //初始化一个UIImageView的对象
    waybutton.multipleTouchEnabled  = NO;
    //此处判断是不是新增，新增为new，编辑为edit；
    edittype = @"NEW";
    
    imageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [imageview addGestureRecognizer:singleTap];

    
    // Do any additional setup after loading the view from its nib.
}


-(IBAction)onClickButtonupload:(id)sender {
    NSLog(@"%@", @"shangchuan");
    
    UIAlertView * Alert=[[UIAlertView alloc]initWithTitle:@"请选择获取方式" message:@""
                                                 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:
                         @"打开照相机",@"从手机相册获取", nil];
    Alert.delegate=self;
    [Alert show ];
}

//点击事件
-(void)choseImage:(UITapGestureRecognizer*)sender{
    
     NSLog(@"%@", @"shangchuan");
    
    UIAlertView * Alert=[[UIAlertView alloc]initWithTitle:@"请选择获取方式" message:@""
                                                 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:
                         @"打开照相机",@"从手机相册获取", nil];
    Alert.delegate=self;
    [Alert show ];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
   
     NSLog(@"%@", @"选择");
    if (buttonIndex == 1) {
        [self getAvatatFormCamera:self];//调用相机
    }
    if (buttonIndex ==2) {
        [self getAvatatFormPhotoLibrary:self];//调用相册
    }
}
- (void)getAvatatFormPhotoLibrary:(UIViewController *)controller
{
    //这里可以判断类型是相册还是相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        //加上下面这句会有编辑框
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (void)getAvatatFormCamera:(UIViewController *)controller
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.showsCameraControls = YES;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma - mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //这里可以选择image类型,
    //原图:UIImagePickerControllerOriginalImage
    //获取编辑框里的图:UIImagePickerControllerEditedImage
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        CGSize newSize = CGSizeMake(300.0f, 300.0f);
        UIGraphicsBeginImageContext(newSize);
        UIImage *imagechuansong = image;
        [imagechuansong drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *imagename=[NSString stringWithFormat:@"%d.png",@"test"];
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imagename];
        BOOL result =[UIImagePNGRepresentation(newImage) writeToFile:filePath atomically:YES];
        if (result == YES) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            
            NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                                  [NSString stringWithFormat:imagename]];
            // 保存文件的名称
            UIImage *img = [UIImage imageWithContentsOfFile:filePath];
            // 保存文件的名称
            [imageview setImage:img];
            //self.lblimagename.hidden=YES;
        }
        UIGraphicsEndImageContext();
        //上传图片,以文件形式,还是base64在这调用就ok
    }];
}////////////////上传图片

-(NSInteger) numberOfSectionsInTableView:(UITableView *)name
{
    NSLog(@"%@", @"1kaishi1");
    
    return 1;
}

-(NSInteger) tableView:(UITableView *)name numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@", @"1kaishi2");
    return 1;
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    [self loadView];
    
}



-(UITableViewCell*) tableView:(UITableView *)name cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(name == tableviewtype)
    {

        static NSString *CellTableIndentifier = @"CellTableIdentifier";
        //单元格ID
        //重用单元格
        UITableViewCell *cell = [name dequeueReusableCellWithIdentifier:CellTableIndentifier];
        //初始化单元格
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
            //自带有两种基础的tableView样式，UITableViewCellStyleValue1、2. 后面的文章会讲解自定义样式
        }

        cell.textLabel.text =  @"请假类型";
        //当上下拉动的时候，因为cell的复用性，我们需要重新判断一下哪一行是打勾的
         NSLog(@"%@", @"type赋值");
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *user = [defaults objectForKey:@"vatcationname"];
         NSLog(@"%@", user);
        if(user.length>0)
        {
                cell.detailTextLabel.text = user;
        }
        else
        {
            cell.detailTextLabel.text = [@"请选择" stringByAppendingString:@"    >"];
            
        }
        
        
        return cell;
        
    }
    else if(name == tableviewstart )
    {
        
        static NSString *CellTableIndentifier = @"CellTableIdentifier";
        //单元格ID
        //重用单元格
        UITableViewCell *cell = [name dequeueReusableCellWithIdentifier:CellTableIndentifier];
        //初始化单元格
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
            //自带有两种基础的tableView样式，UITableViewCellStyleValue1、2. 后面的文章会讲解自定义样式
        }
        
        cell.textLabel.text =  @"开始时间";
        //当上下拉动的时候，因为cell的复用性，我们需要重新判断一下哪一行是打勾的
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *timestart = [defaults objectForKey:@"timestart"];
         NSLog(@"%@", timestart);
        
        NSLog(@"%@", @"timestart");


        if(timestart.length>0)
        {
            cell.detailTextLabel.text = timestart;
            
        }
        else
        {
            cell.detailTextLabel.text = [@"请选择" stringByAppendingString:@"    >"];
            
        }
        
      
        
        return cell;

    }
    else if( name == tableviewend)
    {
        static NSString *CellTableIndentifier = @"CellTableIdentifier";
        //单元格ID
        //重用单元格
        UITableViewCell *cell = [name dequeueReusableCellWithIdentifier:CellTableIndentifier];
        //初始化单元格
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
            //自带有两种基础的tableView样式，UITableViewCellStyleValue1、2. 后面的文章会讲解自定义样式
        }
        
        cell.textLabel.text =  @"结束时间";
        //当上下拉动的时候，因为cell的复用性，我们需要重新判断一下哪一行是打勾的
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSString *timeend = [defaults objectForKey:@"timeend"];
        
        NSLog(@"%@", timeend);
        
        NSLog(@"%@", @"timeend");
        
        if(timeend.length>0)
        {
            cell.detailTextLabel.text = timeend;
        }
        else
        {
             cell.detailTextLabel.text = [@"请选择" stringByAppendingString:@"    >"];
            
        }
        
        return cell;
        
    }
    else if( name == tableviewtime)
    {
        
      
        
        static NSString *CellTableIndentifier = @"CellTableIdentifier";
        //单元格ID
        //重用单元格
        UITableViewCell *cell = [name dequeueReusableCellWithIdentifier:CellTableIndentifier];
        //初始化单元格
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
            //自带有两种基础的tableView样式，UITableViewCellStyleValue1、2. 后面的文章会讲解自定义样式
        }
        
        cell.textLabel.text =  @"请假时长(h)";
        //当上下拉动的时候，因为cell的复用性，我们需要重新判断一下哪一行是打勾的
        
        //cell.detailTextLabel.text = @"请输入";
        UITextField *textField=[[UITextField alloc] initWithFrame:CGRectMake(250, 50, 150, 22)];
        textField.tag=[indexPath row];
        textField.delegate=self;
        textField.placeholder = @"请输入";
        textField.font = [UIFont fontWithName:@"Times New Roman" size:25];
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell addSubview:textField];//第二步,实现回调函数
        
        
        
        
        //cell.placeHolderF.clearButtonMode = UITextFieldViewModeWhileEditing;
        return cell;
    }
    return nil;
    
    
    
}

- (void) textFieldDidChange:(id) sender {
    NSNumber *tag=[NSNumber numberWithInt:[sender tag]];
    UITextField *_field = (UITextField *)sender;
    NSLog(@"tag%@",tag);
    NSLog(@"_field%@",[_field text]);
}


-(void) tableView:(UITableView *)name didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(name == tableviewtype)
    {
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        
        [defaults setObject:@"tableviewtype" forKey:@"type"];
        
        
        [defaults synchronize];//保存到磁盘
        
        VatationPageViewController *nextVc = [[VatationPageViewController alloc]init];//初始化下一个界面
        [self presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
        
        
    }
    else if(name == tableviewstart )
    {
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        
        [defaults setObject:@"tableviewstart" forKey:@"type"];
        
        
        [defaults synchronize];//保存到磁盘
        
        
        CalendaViewController *nextVc = [[CalendaViewController alloc]init];//初始化下一个界面
        [self presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
        
     
        
        
    }
    else if( name == tableviewend)
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        
        [defaults setObject:@"tableviewend" forKey:@"type"];
        
        
        [defaults synchronize];//保存到磁盘
        
        CalendaViewController *nextVc = [[CalendaViewController alloc]init];//初始化下一个界面
        [self presentViewController:nextVc animated:YES completion:nil];//跳转到下一个
        
        

        
    }
    else if( name == tableviewtime)
    {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        
        [defaults setObject:@"tableviewtime" forKey:@"type"];
        
        
        [defaults synchronize];//保存到磁盘
        
    }
    
}

// 监听
- (void)dateChanged:(UIDatePicker *)picker{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [formatter stringFromDate:picker.date];
}



//输入完成键盘退出
-(IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}
//点击背景键盘退出
-(IBAction)backgroundTap:(id)sender {
    [txttime resignFirstResponder];
     [textviewreason1 resignFirstResponder];}

//点击背景键盘退出
-(IBAction)onClickButtonnext:(id)sender {
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *vatcationname = [defaults objectForKey:@"vatcationname"];
    NSString *timestart = [defaults objectForKey:@"timestart"];
    NSString *timeend = [defaults objectForKey:@"timeend"];
    NSString *userid = [defaults objectForKey:@"userid"];
    NSString *EmpID = [defaults objectForKey:@"EmpID"];
    NSString *name = [defaults objectForKey:@"empname"];
    NSString *Groupid = [defaults objectForKey:@"Groupid"];
    NSString *type = [defaults objectForKey:@"vatcationname"];

    NSString *imagecount = @"3";
    NSString *applycode = @"";
    
    if(vatcationname.length > 0)
    {
        
    }
    else
    {
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"提示信息！"
                              message: @"请假类型不能为空！"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(timestart.length > 0)
    {
        
    }
    else
    {
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"提示信息！"
                              message: @"开始时间不能为空！"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(timeend.length > 0)
    {
        
    }
    else
    {
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"提示信息！"
                              message: @"结束时间不能为空！"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(txttime.text.length > 0)
    {
        
    }
    else
    {

         NSLog(@"time%@",txttime.text);
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
    
    if(textviewreason1.text.length > 0)
    {
        
    }
    else
    {
        NSLog(@"textviewreason1%@",textviewreason1.text);
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"提示信息！"
                              message: @"请假事由不能为空！"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    NSLog(@"%@", userid);
    NSLog(@"%@", Groupid);
    NSLog(@"%@", EmpID);
    NSLog(@"%@", type);
    NSLog(@"%@", timestart);
    NSLog(@"%@", timeend);
    NSLog(@"%@", txttime.text);
    NSLog(@"%@", textviewreason1.text);
    NSLog(@"%@", name);
    
    //timestart = timestart.trim
    
    NSString *vatcationtime = txttime.text;
NSString *reason = textviewreason1.text;
    
    
    //XINZENG SHI WEI 0
    int *leaveid = 0;
    int *processid = 0;
    
    
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/btnsave?edittype=%@&userid=%@&groupid=%@&empid=%@&vtype=%@&starttime=%@&endtime=%@&vatcationtime=%@&reason=%@&name=%@&leavleid=%@&processid=%@&imagecount=%@&applycode=%@", edittype,userid,Groupid,EmpID,type,timestart,timeend,vatcationtime,reason,name,@0,@0,imagecount,applycode];
    
    
    
    NSString *urlStringUTF8 = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        NSLog(@"%@", strURL);
    
    NSURL *url = [NSURL URLWithString:urlStringUTF8];
    
   
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
 
}

-(IBAction)onClickButtonapply:(id)sender {
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *vatcationname = [defaults objectForKey:@"vatcationname"];
    NSString *timestart = [defaults objectForKey:@"timestart"];
    NSString *timeend = [defaults objectForKey:@"timeend"];
    NSString *userid = [defaults objectForKey:@"userid"];
    NSString *EmpID = [defaults objectForKey:@"EmpID"];
    NSString *name = [defaults objectForKey:@"empname"];
    NSString *Groupid = [defaults objectForKey:@"Groupid"];
    NSString *type = [defaults objectForKey:@"vatcationname"];

    if(vatcationname.length > 0)
    {
        
    }
    else
    {
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"提示信息！"
                              message: @"请假类型不能为空！"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(timestart.length > 0)
    {
        
    }
    else
    {
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"提示信息！"
                              message: @"开始时间不能为空！"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(timeend.length > 0)
    {
        
    }
    else
    {
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"提示信息！"
                              message: @"结束时间不能为空！"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(txttime.text.length > 0)
    {
        
    }
    else
    {
        
        NSLog(@"time%@",txttime.text);
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
    
    if(textviewreason1.text.length > 0)
    {
        
    }
    else
    {
        NSLog(@"textviewreason1%@",textviewreason1.text);
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"提示信息！"
                              message: @"请假事由不能为空！"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    NSLog(@"%@", userid);
    NSLog(@"%@", Groupid);
    NSLog(@"%@", EmpID);
    NSLog(@"%@", type);
    NSLog(@"%@", timestart);
    NSLog(@"%@", timeend);
    NSLog(@"%@", txttime.text);
    NSLog(@"%@", textviewreason1.text);
    NSLog(@"%@", name);
    
    //timestart = timestart.trim
    
    NSString *vatcationtime = txttime.text;
    NSString *reason = textviewreason1.text;
    
    //设置需要访问的ws和传入参数
       NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/btnapply?edittype=%@&userid=%@&groupid=%@&empid=%@&vtype=%@&starttime=%@&endtime=%@&vatcationtime=%@&reason=%@&name=%@&leavleid=%@&processid=%@", edittype,userid,Groupid,EmpID,type,timestart,timeend,vatcationtime,reason,name,0,0];
    
    NSString *urlStringUTF8 = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", strURL);
    
    NSURL *url = [NSURL URLWithString:urlStringUTF8];
    
    
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
    
    
   
}

-(IBAction)onClickButtonway:(id)sender {
    
    WayViewController *nextVc = [[WayViewController alloc]init];//初始化下一个界面
    //nextVc.processid=processid;
    //nextVc.vatcationid=vatcationid;
    nextVc.pageTypeID=@"4";
    
    if([ flag isEqualToString:@"flase"])
    {
        return ;
    }
    else
    {
        
        //tiaozhuan
        NSLog(@"%@", @"wybuttonclick");
    }
    
    
}



//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    
    NSLog(@"%@",@"connection1-begin");
    
    
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", data);
    
    NSLog(@"%@", xmlString);
    
    
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
    NSRange endRagne = [xmlString rangeOfString:@"</string>"];
    NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
    NSString *resultString = [xmlString substringWithRange:reusltRagne];
    
    NSLog(@"%@", resultString);
    
    NSString *requestTmp = [NSString stringWithString:resultString];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    listOfLeave = [LeaveStatusModel mj_objectArrayWithKeyValuesArray:resultDic];
    
    if(listOfLeave.count > 0)
    {
        
        LeaveStatusModel *m =self.listOfLeave[0];//取出数据元素
        

        if ([ m.Status isEqualToString:@"suess"])
        {
            
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            myDelegate.leaveid =m.LeaveID;
            myDelegate.processid =m.ProcessID;
            flag = @"true";
        }
        
    }
   
    
    
    
    //NSString *test = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",test);
    
    
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSLog(@"%@", @"test3");
    NSLog(@"%@", xmlString);
    NSLog(@"%@", @"kaishijiex");    //开始解析XML
    
    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    ipParser.delegate = self;
    [ipParser parse];

}

//弹出消息框
-(void) connection:(NSURLConnection *)connection
  didFailWithError: (NSError *)error {
    
    NSLog(@"%@", @"test2");
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [error localizedDescription]
                               message: [error localizedFailureReason]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    //[errorAlert release];
    
}

//解析xml回调方法
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"%@", @"test4");
    info = [[NSMutableDictionary alloc] initWithCapacity: 1];
}

//回调方法出错弹框
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"%@", @"test5");
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [parseError localizedDescription]
                               message: [parseError localizedFailureReason]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    //[errorAlert release];
}

//解析返回xml的节点elementName
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
    NSLog(@"%@", @"test6");
    NSLog(@"value: %@\n", elementName);
    NSLog(@"value: %@\n", qualifiedName);
    //NSLog(@"%@", @"jiedian1");    //设置标记查看解析到哪个节点
    
}

//取得我们需要的节点的数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    

    
    //此处解析出来全部为单个的字段
    NSLog(@"%@", @"test7");
    

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
