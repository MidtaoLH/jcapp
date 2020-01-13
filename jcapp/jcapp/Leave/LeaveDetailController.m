//
//  LeaveDetailController.m
//  jcapp
//
//  Created by zclmac on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "LeaveDetailController.h"
#import "MJExtension.h"
#import "../Model/LeaveHead.h"
#import "../Model/LeaveDeatil.h"
#import "LeaveDetailCell.h"
#import "LeaveImageCell.h"
#import "../Model/MdlAnnex.h"
#import "SDDemoCell.h"
#import "SDPhotoItem.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "../VatationPage/VatcationMainView.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#import "Masonry.h"
#define kCount 6  //图片总张数

@interface LeaveDetailController ()
{
    CGFloat scaleMini;
    CGFloat scaleMax;
    //0 初始化 1 承认 2 驳回
    long edittype;
}

@property (strong,nonatomic) LeaveHead *leavehead;
@property (nonatomic, strong) NSMutableArray *srcStringArray;

@end

@implementation LeaveDetailController

static NSString *identifier =@"LeaveDetailCell";
static NSString *identifierImage =@"LeaveImageCell.h";

@synthesize listdetail;
@synthesize listhead;
@synthesize  listtask; 
@synthesize  listAnnex;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //设置子视图的f导航栏的返回按钮
    self.navigationItem.title=self.title;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetLeaveDataByID?userID=%@&LeaveID=%@&ProcessInstanceID=%@", userID,self.awardID_FK,self.processInstanceID ];
    
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
 
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
   
    
    [self setlblcolor];
    [self.btnEdit.layer setCornerRadius:12];
    self.btnEdit.layer.masksToBounds=YES;
    [self.btncancle.layer setCornerRadius:12];
    self.btncancle.layer.masksToBounds=YES;
    [_btnEdit addTarget:self action:@selector(TaskUpdate:)   forControlEvents:UIControlEventTouchUpInside];
    [_btncancle addTarget:self action:@selector(TaskCancle:)   forControlEvents:UIControlEventTouchUpInside];
    
    [self loadstyle];
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
    _lblleavestatus.font=kFont_Lable_18;
    _lblleavetype.font=kFont_Lable_16;
    _imgvleavestatus.backgroundColor = kColor_Cyan;
    //注册自定义 cell
    [_NewTableView registerClass:[LeaveDetailCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight = Common_TableRowHeight;
    
    [_ImageTableView registerClass:[SDDemoCell class] forCellReuseIdentifier:identifierImage];
    _ImageTableView.rowHeight = Common_ImageTableRowHeight;
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
    
    // 审批列表view添加约束
    [_NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_EditImageTableHeight+Common_CRTableHeight+Common_RowSize*5);
        // 添加大小约束
        //make.size.mas_equalTo(CGSizeMake(kScreenWidth, Common_EditTableHeight));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight-(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_EditImageTableHeight+Common_CRTableHeight+Common_RowSize*7)-Common_BtnHeight*2));
        // 添加左
        make.left.mas_equalTo(0);
        
    }];
    
    [self.btncancle mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_EditImageTableHeight+Common_CRTableHeight+Common_EditTableHeight+Common_RowSize*6);
        make.top.mas_equalTo(kScreenHeight-Common_BtnHeight-Common_RowSize-Common_RowSize/2);
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-Common_ColSize*2,Common_BtnHeight));
    }];
    [self.btnEdit mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加上
        //make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_EditImageTableHeight+Common_CRTableHeight+Common_EditTableHeight+Common_RowSize*6);
        make.top.mas_equalTo(kScreenHeight-Common_BtnHeight-Common_RowSize-Common_RowSize/2);
        // 添加左
        make.left.mas_equalTo(kScreenWidth/2+Common_ColSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2-Common_ColSize*2,Common_BtnHeight));
    }];
    _imgvemp.layer.masksToBounds = YES;
    _imgvemp.layer.cornerRadius = Common_UserImageSize * 0.5;
    
    _imgvleavestatus.layer.masksToBounds = YES;
    _imgvleavestatus.layer.cornerRadius = self.imgvleavestatus.width * 0.5;
}
-(void)ShowMessage
{
    //提示框添加文本输入框
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请输入理由"
                                                                   message:@"当前记录取消后不能恢复"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //响应事件
                                                         //得到文本信息
                                                         for(UITextField *text in alert.textFields){
                                                             
                                                             NSLog(@"text = %@", text.text);
                                                             
                                                             if([text.text isEqualToString:@""])
                                                             {
                                                                 NSLog(@"text = %@", @"asdfsdfsdf");
                                                                 [self ShowMessage];
                                                                 return;
                                                             }
                                                             
                                                             edittype = 1;
                                                             
                                                             NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/TaskCancle?UserID=%@&MenuID=%@&ProcessInstanceID=%@&CelReson=%@", userID, @"1", self.processInstanceID, text.text ];
                                                             
                                                             NSLog(@"%@", strURL);
                                                             NSURL *url = [NSURL URLWithString:strURL];
                                                             //进行请求
                                                             NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
                                                             
                                                             NSURLConnection *connection = [[NSURLConnection alloc]
                                                                                            initWithRequest:request
                                                                                            delegate:self];
                                                         }
                                                     }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", alert.textFields);
                                                         }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"取消修改理由必填";
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)TaskCancle:(id)sender{
    
    [self ShowMessage];
}
-(void)TaskUpdate:(id)sender{
    //修改是已驳回不写理由。 直接跳到明细编辑画面，点保存生成下一版本
    if([_lblleavestatus.text isEqualToString:@"已驳回"])
    {
        //待申请任务 进入明细编辑画面为修改操作
        VatcationMainView * VCCollect = [[VatcationMainView alloc] init];
        VCCollect.vatcationid=self.awardID_FK;
        VCCollect.processInstanceID=self.processInstanceID;
        VCCollect.ProcessApplyCode=self.ProcessApplyCode;
        VCCollect.edittype = @"3"; //编辑
        VCCollect.urltype = @"getdata";
        [self.navigationController pushViewController:VCCollect animated:YES];
    }
    else
    {
        //提示框添加文本输入框
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请输入理由"
                                                                       message:@"当前记录修改后，原版本不能恢复"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             //得到文本信息
                                                             for(UITextField *text in alert.textFields){
                                                                 
                                                                 NSLog(@"text = %@", text.text);
                                                                 
                                                                 if([text.text isEqualToString:@""])
                                                                 {
                                                                     NSLog(@"text = %@", @"asdfsdfsdf");
                                                                     return;
                                                                 }
                                                                 //待申请任务 进入明细编辑画面为修改操作
                                                                 VatcationMainView * VCCollect = [[VatcationMainView alloc] init];
                                                                 VCCollect.vatcationid=self.awardID_FK;
                                                                 VCCollect.processInstanceID=self.processInstanceID;
                                                                 VCCollect.ProcessApplyCode=self.ProcessApplyCode;
                                                                 VCCollect.edittype = @"3";
                                                                 VCCollect.urltype = @"getdata";
                                                                 VCCollect.proCelReson = text.text;
                                                                 [self.navigationController pushViewController:VCCollect animated:YES];
                                                             }
                                                         }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                                 NSLog(@"action = %@", alert.textFields);
                                                             }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"取消修改理由必填";
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)setlblcolor
{
    _lblempgroup.textColor = [UIColor grayColor];
    _lblleavedate.textColor = [UIColor grayColor];
    _lblapplydate.textColor = [UIColor grayColor];
    _lblleavecounts.textColor = [UIColor grayColor];
    _lblleaveremark.textColor = [UIColor grayColor];
}


//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%@",@"kaishidayin");
    
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 
    NSLog(@"%@", xmlString);
 
    //此页面为详细 查看画面 0为查看
    if(edittype == 0)
    {
        // 字符串截取
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">{\"Table\":"];
        NSRange endRagne = [xmlString rangeOfString:@",\"Table1\":"];
        
        NSRange startRange2 =[xmlString rangeOfString:@",\"Table1\":"];
        NSRange endRagne2 = [xmlString rangeOfString:@",\"Table2\":"];
        
        NSRange startRange3 =[xmlString rangeOfString:@",\"Table2\":"];
        NSRange endRagne3 =[xmlString rangeOfString:@"}</string>"];
        
        //获取附件数据
        NSRange reusltRagnedetail3 = NSMakeRange(startRange3.location + startRange3.length, endRagne3.location - startRange3.location - startRange3.length);
        NSString *resultString3 = [xmlString substringWithRange:reusltRagnedetail3];
        
        NSString *requestTmp3 = [NSString stringWithString:resultString3];
        NSData *resData3 = [[NSData alloc] initWithData:[requestTmp3 dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *resultDic3 = [NSJSONSerialization JSONObjectWithData:resData3 options:NSJSONReadingMutableLeaves error:nil];
        listAnnex = [MdlAnnex mj_objectArrayWithKeyValuesArray:resultDic3];
        
        //补充附件图片路径
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        for (MdlAnnex *mdla in listAnnex) {
            NSString *urlstring = [NSString stringWithFormat:Common_WSUrl,mdla.AnnexPath];
            [array1 addObject:urlstring];
        }
        _srcStringArray =array1;
        
        //获取回览明细表数据
        NSRange reusltRagnedetail2 = NSMakeRange(startRange2.location + startRange2.length, endRagne2.location - startRange2.location - startRange2.length);
        NSString *resultString2 = [xmlString substringWithRange:reusltRagnedetail2];
        
        NSString *requestTmp2 = [NSString stringWithString:resultString2];
        NSData *resData2 = [[NSData alloc] initWithData:[requestTmp2 dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *resultDic2 = [NSJSONSerialization JSONObjectWithData:resData2 options:NSJSONReadingMutableLeaves error:nil];
        listdetail = [LeaveDeatil mj_objectArrayWithKeyValuesArray:resultDic2];
        
        //获取头表数据
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        
        NSLog(@"%@", resultString);
        
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        
          listhead = [LeaveHead mj_objectArrayWithKeyValuesArray:resultDic];
        for (LeaveHead *p1 in listhead) {
            UIImageView *imageView = [[UIImageView alloc] init];
            NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,p1.U_LoginName];
            [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString]];
            _imgvemp.image =imageView.image;
            
            _lblleavestatus.text = p1.ProcessStutasTxt;
            _emplbl.text = p1.EmpName;
            _lblempgroup.text = p1.G_CName;
            
            NSString * strapplydate =[[NSString alloc]initWithFormat:@"%@%@",@"申请时间：",p1.ApplyDate];
            
            _lblapplydate.text = strapplydate;
            
            NSString * strleavedate =[[NSString alloc]initWithFormat:@"%@%@ ~ %@",@"请假时间：",p1.PlanStartTime,p1.PlanEndTime];
            
            _lblleavedate.text = strleavedate;
            
            _lblleavetype.text = p1.LeaveTypeTxt;
            
            NSString * strleavecounts =[[NSString alloc]initWithFormat:@"%@%@",@"请假时长(h)：",p1.TimePlanNum];
            
            _lblleavecounts.text =strleavecounts;
            
            NSString * strleaveremark =[[NSString alloc]initWithFormat:@"%@%@",@"请假事由：",p1.CaseDescribe];
            
            _lblleaveremark.text = strleaveremark;
        }
    }
    else if (edittype == 1)
    {
        // 字符串截取
        NSRange startRangetaskedit = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
        NSRange endRangetaskedit =[xmlString rangeOfString:@"</string>"];
        
        NSRange reusltRagnedetaskedit = NSMakeRange(startRangetaskedit.location + startRangetaskedit.length, endRangetaskedit.location - startRangetaskedit.location - startRangetaskedit.length);
        NSString *resultStringtaskedit = [xmlString substringWithRange:reusltRagnedetaskedit];
        
        if(![resultStringtaskedit isEqualToString:@"0"])
        {
            // 弹出 对话框
         //   [self showError:resultStringtaskedit];
        }
        else
        {
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
    }
    else if (edittype == 2)
    {
        // 字符串截取
        NSRange startRangetaskedit = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
        NSRange endRangetaskedit =[xmlString rangeOfString:@"</string>"];
        
        NSRange reusltRagnedetaskedit = NSMakeRange(startRangetaskedit.location + startRangetaskedit.length, endRangetaskedit.location - startRangetaskedit.location - startRangetaskedit.length);
        NSString *resultStringtaskedit = [xmlString substringWithRange:reusltRagnedetaskedit];
        
        if(![resultStringtaskedit isEqualToString:@"0"])
        {
            // 弹出 对话框
            [self showError:resultStringtaskedit];
        }
        else
        {
            // 弹出 对话框
            [self showError:@"操作成功！"];
        }
    }
    [self.ImageTableView reloadData];
    [self.ImageTableView layoutIfNeeded];
    NSLog(@"%@",@"connection1-end");
}
// 提示错误信息
- (void)showError:(NSString *)errorMsg {
    // 1.弹框提醒
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
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
    
    [self.NewTableView reloadData];
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
    
    //[outstring release];
    //[xmlString release];
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
        LeaveDetailCell * cell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        cell.leavedetail =self.listdetail[indexPath.row];//取出数据元素
        
        return cell;
    }
    else if ([tableView isEqual:self.ImageTableView]) {
        
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
@end
