//
//  LeaveDetailController.m
//  jcapp
//
//  Created by zclmac on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "ExamineEditLController.h"
#import "MJExtension.h"
#import "../Model/ExamineHead.h"
#import "../Model/LeaveDeatil.h"
#import "ExamineEditImageCell.h"
#import "../Model/LeaveTask.h"
#import "../Model/MdlAnnex.h"
#import "ExamineEditCell.h"
#import "SDDemoCell.h"
#import "SDPhotoItem.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#import "TabBarViewController.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "../ViewController.h"
#import "../Model/ExamineEditReturn.h"
#define kCount 4  //图片总张数
 
@interface ExamineEditLController ()
{
    CGFloat scaleMini;
    CGFloat scaleMax;
    
    NSString *strlblleavedate;
    NSString *strlblleavecounts;
    NSString *strlblleaveremark;
 
     //0 初始化 1 承认 2 驳回
    long edittype;

    UIButton *_progressHUD;
    UIView *_HUDContainer;
    UIActivityIndicatorView *_HUDIndicatorView;
    UILabel *_HUDLable;
}
@property (nonatomic, strong) NSArray *srcStringArray;

@property (strong,nonatomic) ExamineHead *exahead;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation ExamineEditLController

static NSString *identifier =@"WaitTaskCell";
static NSString *identifierImage =@"WaitTaskImageCell";

@synthesize listdetail;
@synthesize listhead;
@synthesize  listtask;
@synthesize listAnnex;
@synthesize taskeditreturn;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadstyle];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    edittype = 0;
 
    //当前登陆者
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userid = [defaults objectForKey:@"userid"];
    iosid = [defaults objectForKey:@"adId"];
 
  //  self.strTaskid = @"23184";
 //   self.taskType =@"13";
    
    //设置需要访问的ws和传入参数
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetExamineEditData?userID=%@&taskID=%@&TaskType=%@&iosid=%@",userid,self.strTaskid,self.taskType,iosid];
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
    
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
 
    [_ImageTableView registerClass:[SDDemoCell class] forCellReuseIdentifier:identifierImage];
    //_ImageTableView.rowHeight = Common_EditImageTableHeight;
    
    NSLog(@"%@",@"viewDidLoad-end");
        //d根据不同单据类型 设置文字
    [self settsaktype];
//    [self.btntaskno.layer setCornerRadius:12];
//    self.btntaskno.layer.masksToBounds=YES;
//    [self.buttaskyes.layer setCornerRadius:12];
//    self.buttaskyes.layer.masksToBounds=YES;
//
//     [_btntaskno addTarget:self action:@selector(actionno:)   forControlEvents:UIControlEventTouchUpInside];
//     [_buttaskyes addTarget:self action:@selector(actionyes:)   forControlEvents:UIControlEventTouchUpInside];
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    [self.view addSubview:toolBar];
    [toolBar  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScreenHeight-TabbarHeight);
        
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, TabbarHeight));
        make.left.mas_equalTo(0);
    }];
    
    UIImage* itemImage= [UIImage imageNamed:@"reject.png"];
    
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem * rejectBtn =[[UIBarButtonItem  alloc]initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(actionno:)];
    
    rejectBtn.width=kScreenWidth/2;
    
    itemImage= [UIImage imageNamed:@"agree.png"];
    
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem * agreeBtn =[[UIBarButtonItem  alloc]initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(actionyes:)];
    agreeBtn.width=kScreenWidth/2;
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:rejectBtn,agreeBtn, nil];
    
    [toolBar setItems:toolbarItems animated:YES];
   
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
//    UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
//    [self presentViewController:navigationController animated:YES completion:nil];
}
-(void)loadstyle{
    _emplbl.font=kFont_Lable_15;
    _lblempgroup.textColor = [UIColor grayColor];
    _lblempgroup.font=kFont_Lable_14;
    _lblapplydate.textColor = [UIColor grayColor];
    _lblapplydate.font=kFont_Lable_14;
    _lblapplydate.textColor = [UIColor grayColor];
    _lblapplydate.font=kFont_Lable_14;
    _lblleavecounts.textColor = [UIColor grayColor];
    _lblleavecounts.font=kFont_Lable_14;
    _lblleaveremark.textColor = [UIColor grayColor];
    _lblleaveremark.font=kFont_Lable_14;
    _lblleavedate.textColor = [UIColor grayColor];
    _lblleavedate.font=kFont_Lable_14;
    _lblccdr.textColor = [UIColor grayColor];
    _lblccdr.font=kFont_Lable_14;
    
    _txtvexamineremark.layer.borderColor =[[UIColor redColor] CGColor];
    _txtvexamineremark.font =kFont_Lable_16;
    _txtvexamineremark.layer.borderWidth = 1.0f;
    _txtvexamineremark.layer.cornerRadius = 6.0f;
    
    
    _lblleavestatus.font=kFont_Lable_18;
    _lblleavetype.font=kFont_Lable_16;
    _imgvleavestatus.backgroundColor = kColor_Cyan;
    //注册自定义 cell
    [_NewTableView registerClass:[ExamineEditCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight = Common_TableRowHeight;
    
    [_ImageTableView registerClass:[SDDemoCell class] forCellReuseIdentifier:identifierImage];
    _ImageTableView.rowHeight = Common_ImageTableRowHeight;
    _ImageTableView.scrollEnabled=NO;
    [_imgvemp mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_UserImageSize,Common_UserImageSize));
    }];
    [_imgvleavestatus mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加右
        make.right.mas_equalTo(-Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_StatusImageSize,Common_StatusImageSize));
    }];
    [_lblleavestatus mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加右
        make.right.mas_equalTo(-Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_StatusImageSize,Common_StatusImageSize));
    }];
    [_emplbl mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_UserImageSize+Common_ColSize*2);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_TxTHeight));
    }];
    [_lblempgroup mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_UserImageSize+Common_ColSize*2);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize*2);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_TxTHeight));
    }];
    [_lblapplydate mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_UserImageSize+Common_ColSize*2);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize*3);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_TxTHeight));
    }];
    [_lblleavetype mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_TxTHeight));
    }];
    [_lblleavedate mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize*2);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth*2,Common_TxTHeight));
    }];
    [_lblccdr mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-Common_ColSize,Common_TxTHeight));
    }];
    [_lblleavecounts mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize*3);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth,Common_TxTHeight));
    }];
    [_lblleaveremark mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize*4);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_TxTWidth*4,Common_TxTHeight));
    }];
    [_ImageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(0);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize*5);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, Common_EditImageTableHeight));
    }];
    [_lblcryj mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(0);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_EditImageTableHeight+Common_RowSize*5);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,  Common_TxTHeight));
    }];
    [_txtvexamineremark mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(0);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_EditImageTableHeight+Common_RowSize*6);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, Common_CRTableHeight));
    }];
    
    
    // 审批列表view添加约束
    [_NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
    make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_EditImageTableHeight+Common_CRTableHeight+Common_RowSize*6);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight-(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_EditImageTableHeight+Common_CRTableHeight+Common_RowSize*6)-TabbarHeight));
        // 添加左
        make.left.mas_equalTo(0);
        
    }];
//    [self.btntaskno mas_makeConstraints:^(MASConstraintMaker *make) {
//        // 添加上
//        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_EditImageTableHeight+Common_CRTableHeight+Common_RowSize*6+Common_EditTableHeight);
//        // 添加左
//        make.left.mas_equalTo(Common_ColSize);
//        // 添加大小约束
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-Common_ColSize*2,Common_BtnHeight));
//    }];
//    [self.buttaskyes mas_makeConstraints:^(MASConstraintMaker *make) {
//        // 添加上
//        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_EditImageTableHeight+Common_CRTableHeight+Common_RowSize*6+Common_EditTableHeight);
//        // 添加左
//        make.left.mas_equalTo(kScreenWidth/2+Common_ColSize);
//        // 添加大小约束
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-Common_ColSize*2,Common_BtnHeight));
//    }];
    _imgvemp.layer.masksToBounds = YES;
    _imgvemp.layer.cornerRadius = Common_UserImageSize * 0.5;
    
    _imgvleavestatus.layer.masksToBounds = YES;
    _imgvleavestatus.layer.cornerRadius = self.imgvleavestatus.width * 0.5;
}
-(void)settsaktype
{
    //请假
    if([self.taskType isEqualToString:@"1"])
    {
        strlblleavedate = @"请假时间:";
        strlblleavecounts = @"请假时长:";
        strlblleaveremark = @"请假事由:";
    }
    //外出
    if([self.taskType isEqualToString:@"3"])
    {
        strlblleavedate = @"外出时间:";
        strlblleavecounts = @"外出时长:";
        strlblleaveremark = @"外出事由:";
    }
    //出差
    if([self.taskType isEqualToString:@"13"])
    {
        strlblleavedate = @"出差时间：";
        strlblleavecounts = @"出差天数：";
        strlblleaveremark = @"出差事由：";
    }
}

-(void)taskedittoservice:(NSMutableDictionary *)mutableDic0
{
    id objtasktype = mutableDic0[@"tasktype"];
    id objremark = mutableDic0[@"remark"];
    
    //设置需要访问的ws和传入参数
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/TaskInstanceEdit?userID=%@&taskInstanceID=%@&Remark=%@&operate=%@&operatr=%@&iosid=%@",userid,self.strTaskid,objremark,objtasktype,userid,iosid];
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];

    NSString *urlStringUTF8 = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", strURL);
    NSURL *url = [NSURL URLWithString:urlStringUTF8];
 
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
    [self showProgressHUD];
}
// 驳回操作
-(void)actionno:(id)sender{
 
    if([self.txtvexamineremark.text isEqualToString:@""])
    {
        [self showError:@"请输入驳回理由"];
        return;
    }
    
    edittype = 2;
    NSMutableDictionary *mutableDic0 = [NSMutableDictionary dictionary];
    [mutableDic0 setObject:@"3" forKey:@"tasktype"];
    [mutableDic0 setObject:self.txtvexamineremark.text forKey:@"remark"];
 
    [self taskedittoservice:mutableDic0];
 }
//同意操作
-(void)actionyes:(id)sender{
    edittype = 1;
    NSMutableDictionary *mutableDic0 = [NSMutableDictionary dictionary];
    [mutableDic0 setObject:@"2" forKey:@"tasktype"];
    [mutableDic0 setObject:self.txtvexamineremark.text forKey:@"remark"];
    
    [self taskedittoservice:mutableDic0];
}
#pragma mark - 封装弹出对话框方法
// 提示错误信息
- (void)showError:(NSString *)errorMsg {
    // 1.弹框提醒
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self hideProgressHUD];
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //判断账号是否总其他设备登录
    if([xmlString containsString: Common_MoreDeviceLoginFlag])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"" message: Common_MoreDeviceLoginErrMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        ViewController * valueView = [[ViewController alloc] initWithNibName:@"ViewController"bundle:[NSBundle mainBundle]];
        //跳转
        [self presentModalViewController:valueView animated:YES];
        return;
    }
    //承认 驳回，服务器返回了 方法名
    if([xmlString containsString: @"TaskInstanceEdit"])
    {
        // 字符串截取
        NSRange startRangetaskedit = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
        NSRange endRangetaskedit =[xmlString rangeOfString:@"</string>"];
 
        NSRange reusltRagnedetaskedit = NSMakeRange(startRangetaskedit.location + startRangetaskedit.length, endRangetaskedit.location - startRangetaskedit.location - startRangetaskedit.length);
        NSString *resultStringtaskedit = [xmlString substringWithRange:reusltRagnedetaskedit];

        NSString *returntmp = [NSString stringWithString:resultStringtaskedit];
        NSData *returnData = [[NSData alloc] initWithData:[returntmp dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        
        taskeditreturn = [ExamineEditReturn mj_objectArrayWithKeyValuesArray:returnDic];
        
        NSString *strmessage = @"";
        
        for (ExamineEditReturn *mdre in taskeditreturn)
        {
            if(![mdre.resuelt isEqualToString:@"0"])
            {
                // 弹出 对话框
                [self showError:resultStringtaskedit];
            }
            else
            {
                //2 承认
                if([mdre.edittype isEqualToString:@"2"])
                {
                    strmessage = @"同意成功";
                }
                else if([mdre.edittype isEqualToString:@"3"])
                {
                    strmessage = @"驳回成功";
                }
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @""
                                      message: strmessage
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    else
    {
        // 字符串截取
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">{\"Table\":"];
        NSRange endRagne = [xmlString rangeOfString:@",\"Table1\":"];
        
        NSRange startRange2 =[xmlString rangeOfString:@",\"Table1\":"];
        NSRange endRagne2 =[xmlString rangeOfString:@",\"Table2\":"];
        
        NSRange startRange3 =[xmlString rangeOfString:@",\"Table2\":"];
        NSRange endRagne3 =[xmlString rangeOfString:@",\"Table3\":"];
        
        NSRange startRangeEnd =[xmlString rangeOfString:@",\"Table3\":"];
        NSRange endRagneEnd =[xmlString rangeOfString:@"}</string>"];
        
        //获取申请附件数据
        NSRange reusltRagnedetail2 = NSMakeRange(startRange2.location + startRange2.length, endRagne2.location - startRange2.location - startRange2.length);
        NSString *resultString2 = [xmlString substringWithRange:reusltRagnedetail2];
        
        NSString *requestTmp2 = [NSString stringWithString:resultString2];
        NSData *resData2 = [[NSData alloc] initWithData:[requestTmp2 dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *resultDic2 = [NSJSONSerialization JSONObjectWithData:resData2 options:NSJSONReadingMutableLeaves error:nil];
        listAnnex = [MdlAnnex mj_objectArrayWithKeyValuesArray:resultDic2];
        
        //补充附件图片路径
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        for (MdlAnnex *mdla in listAnnex) {
            NSString *urlstring = [NSString stringWithFormat:Common_WSUrl,mdla.AnnexPath];
            [array1 addObject:urlstring];
        }
        _srcStringArray =array1;
        
        //获取承认数据
        NSRange reusltRagnedetail3 = NSMakeRange(startRange3.location + startRange3.length, endRagne3.location - startRange3.location - startRange3.length);
        NSString *resultString3 = [xmlString substringWithRange:reusltRagnedetail3];
        NSLog(@"%@", resultString3);
        
        NSString *requestTmp3 = [NSString stringWithString:resultString3];
        NSData *resData3 = [[NSData alloc] initWithData:[requestTmp3 dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *resultDic3 = [NSJSONSerialization JSONObjectWithData:resData3 options:NSJSONReadingMutableLeaves error:nil];
        listdetail = [LeaveDeatil mj_objectArrayWithKeyValuesArray:resultDic3];
        
        //获取头表数据
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        
        NSLog(@"%@", resultString);
        
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        
        listhead = [ExamineHead mj_objectArrayWithKeyValuesArray:resultDic];
        for (ExamineHead *p1 in listhead) {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,p1.U_LoginName];
            [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString]];
            _imgvemp.image =imageView.image;
            
            _lblleavestatus.text = p1.StatusTxt;
            _emplbl.text = p1.EmpCName;
            _lblempgroup.text = p1.groupname;
            if([self.taskType isEqualToString:@"13"])
            {
                self.lblccdr.text=[NSString stringWithFormat:@"出差地点：%@",p1.BusinessTripPlace];
            }
            else
            {
                self.lblccdr.text=@"";
            }
            NSString * strapplydate =[[NSString alloc]initWithFormat:@"%@%@",@"申请时间：",p1.ExamineDate];
            
            _lblapplydate.text = strapplydate;
            
            NSString * strleavedate =[[NSString alloc]initWithFormat:@"%@%@ ~ %@",strlblleavedate,p1.BeignDate,p1.EndDate];
            
            _lblleavedate.text = strleavedate;
            
            _lblleavetype.text = p1.TypeTxt;
            
            NSString * strleavecounts =[[NSString alloc]initWithFormat:@"%@%@",strlblleavecounts,p1.numcount];
            
            _lblleavecounts.text =strleavecounts;
            
            NSString * strleaveremark =[[NSString alloc]initWithFormat:@"%@%@",strlblleaveremark,p1.Describe];
            
            _lblleaveremark.text = strleaveremark;
        }
    }
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self.ImageTableView reloadData];
    }];
    [self.ImageTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [CATransaction commit];
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [_NewTableView reloadData];
    }];
    [_NewTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [CATransaction commit];

    NSLog(@"%@",@"connection1-end");
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
       navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:nil];
}

//弹出消息框
-(void) connection:(NSURLConnection *)connection
  didFailWithError: (NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [error localizedDescription]
                               message: [error localizedFailureReason]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    NSLog(@"%@",@"connection2-end");
}

//解析返回的xml系统自带方法不需要h中声明
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    
    NSLog(@"%@", @"kaishijiex");    //开始解析XML
    
    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    ipParser.delegate = self;
    [ipParser parse];
    NSLog(@"%@",@"connectionDidFinishLoading-end");
    
  
}

//解析xml回调方法
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    info = [[NSMutableDictionary alloc] initWithCapacity: 1];
    
    NSLog(@"%@",@"parserDidStartDocument-end");
}

//回调方法出错弹框
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [parseError localizedDescription]
                               message: [parseError localizedFailureReason]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    NSLog(@"%@",@"parser-end");
}

//解析返回xml的节点elementName
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
    NSLog(@"value2: %@\n", elementName);
    //NSLog(@"%@", @"jiedian1");    //设置标记查看解析到哪个节点
    currentTagName = elementName;
    
    NSLog(@"%@",@"parser2-end");
}

//取得我们需要的节点的数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSLog(@"%@",@"parser3-begin");
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
}

//循环解析d节点
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    NSLog(@"%@",@"parserDidEndDocument-begin");
    
    NSMutableString *outstring = [[NSMutableString alloc] initWithCapacity: 1];
    for (id key in info) {
        [outstring appendFormat: @"%@: %@\n", key, [info objectForKey:key]];
    }
}

//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%@",@"numberOfSectionsInTableView-begin");
    // 默认有些行，请删除或注 释 #warning Potentially incomplete method implementation.
    // 这里是返回的节点数，如果是简单的一组数据，此处返回1，如果有多个节点，就返回节点 数
    
    return 1;
}

//如果不设置section 默认就1组
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 默认有此行，请删除或注 释 #warning Incomplete method implementation.
    // 这里是返回节点的行数
    NSLog(@"%@",@"tableView-begin");
    //  return self.listdetail.count;
    
    if ([tableView isEqual:self.NewTableView]) {
        
        NSLog(@"%@",@"tableView-begin");
        return self.listdetail.count;
        
    } else if ([tableView isEqual:self.ImageTableView]) {
        
        return 1;
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:self.NewTableView]) {
        ExamineEditCell * wcell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        //去掉行选择
        wcell.selectionStyle = UITableViewCellSelectionStyleNone;   
        wcell.leavedetail =self.listdetail[indexPath.row];//取出数据元素
        
        return wcell;
    } else if ([tableView isEqual:self.ImageTableView]) {
        
        SDDemoCell *sdcell =[self.ImageTableView dequeueReusableCellWithIdentifier:identifierImage forIndexPath:indexPath];
        sdcell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableArray *temp = [NSMutableArray array];
        [_srcStringArray enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
            SDPhotoItem *item = [[SDPhotoItem alloc] init];
            item.thumbnail_pic = src;
            [temp addObject:item];
        }];
        sdcell.photosGroup.photoItemArray = [temp copy];
        return sdcell;
/*
 * cell = [self.ImageTableView dequeueReusableCellWithIdentifier:identifierImage forIndexPath:indexPath];
 
 cell.str  = @"Rem【ar【k【k2";
 
 return cell;

 */
        
    }
    return 0;
    
}
//解决tableview线不对的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
//解决tableview线不对的问题
- (void)viewDidLayoutSubviews
{
    if ([_NewTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_NewTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_NewTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_NewTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([_ImageTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_ImageTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_ImageTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_ImageTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)showProgressHUD {
    if (!_progressHUD) {
        _progressHUD = [UIButton buttonWithType:UIButtonTypeCustom];
        [_progressHUD setBackgroundColor:[UIColor clearColor]];
        
        _HUDContainer = [[UIView alloc] init];
        _HUDContainer.frame = CGRectMake(150, 300, 100,100 );
        _HUDContainer.layer.cornerRadius = 8;
        _HUDContainer.clipsToBounds = YES;
        _HUDContainer.backgroundColor = [UIColor darkGrayColor];
        _HUDContainer.alpha = 0.7;
        
        _HUDIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _HUDIndicatorView.frame = CGRectMake(45, 15, 30, 30);
        
        _HUDLable = [[UILabel alloc] init];
        _HUDLable.frame = CGRectMake(0,40, 100, 50);
        _HUDLable.textAlignment = NSTextAlignmentCenter;
        _HUDLable.text = @"正在处理...";
        _HUDLable.font = [UIFont systemFontOfSize:15];
        _HUDLable.textColor = [UIColor whiteColor];
        
        [_HUDContainer addSubview:_HUDLable];
        [_HUDContainer addSubview:_HUDIndicatorView];
        [_progressHUD addSubview:_HUDContainer];
    }
    [_HUDIndicatorView startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:_progressHUD];
}

- (void)hideProgressHUD {
    if (_progressHUD) {
        [_HUDIndicatorView stopAnimating];
        [_progressHUD removeFromSuperview];
    }
}
@end
