//
//  BusinessTripDetailViewController.m
//  jcapp
//
//  Created by zhaodan on 2019/12/24.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "BusinessTripDetailViewController.h"
#import "MJExtension.h"
#import "../Model/MdlBusinessTrip.h"
#import "../Model/MdlEvectionDetail.h"
#import "BusinessTripDetailImagecell.h"
#import "../Model/LeaveTask.h"
#import "BusinessTripDetailCell.h"
#import "../AppDelegate.h"

@interface BusinessTripDetailViewController (){
    
    CGFloat scaleMini;
    CGFloat scaleMax;
    
    //0 初始化 1 承认 2 驳回
    long edittype;
    
}

@property (strong,nonatomic) MdlBusinessTrip *leavehead;

@end

@implementation BusinessTripDetailViewController

static NSString *identifier =@"DetailCell";
static NSString *identifierImage =@"ImageCell.h";

@synthesize listdetail;
@synthesize listhead;
@synthesize  listtask;

- (void)viewDidLoad {
    [super viewDidLoad];
    edittype = 0;
    
    NSString *userid = @"77";
    NSString *BusinessTripID = @"10";
    NSString *ProcessInstanceID = @"50";
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    BusinessTripID=myDelegate.businessTripid;
    ProcessInstanceID=myDelegate.processid;
    
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetBusinessTripDataByID?userID=%@&BusinessTripID=%@&ProcessInstanceID=%@", userid,BusinessTripID,ProcessInstanceID ];
    
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
    //e注册自定义 cell
    [_NewTableView registerClass:[BusinessTripDetailCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight = 150;
    
    [_ImageTableView registerClass:[BusinessTripDetailImagecell class] forCellReuseIdentifier:identifierImage];
    _ImageTableView.rowHeight = 150;
    
    NSLog(@"%@",@"viewDidLoad-end");
    
    _imgvleavestatus.layer.masksToBounds = YES;
    
    _imgvleavestatus.layer.cornerRadius = _imgvleavestatus.frame.size.width / 2;
    
    _imgvleavestatus.backgroundColor = [UIColor greenColor];
    [self setlblcolor];
    
    [_btnEdit addTarget:self action:@selector(TaskUpdate:)   forControlEvents:UIControlEventTouchUpInside];
    [_btncancle addTarget:self action:@selector(TaskCancle:)   forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)TaskCancle:(id)sender{
    
    edittype = 1;
    
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/TaskCancle?UserID=%@&MenuID=%@&ProcessInstanceID=%@&CelReson=%@", @"80", @"1", @"22770", @"80" ];
    
    NSLog(@"%@", strURL);
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
}
-(void)TaskUpdate:(id)sender{
    edittype = 2;
    
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/TaskUpdate?UserID=%@&ProcessInstanceID=%@&CelReson=%@&Updator=%@", @"80", @"22770", @"80" , @"80"];
    NSLog(@"%@", strURL);
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
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
    NSLog(@"%@",@"connection1-begin");
    
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", @"kaishidayin");
    NSLog(@"%@", xmlString);
    
    if(edittype == 0)
    {
        // 字符串截取
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">{\"Table\":"];
        NSRange endRagne = [xmlString rangeOfString:@",\"Table1\":"];
        
        NSRange startRange2 =[xmlString rangeOfString:@",\"Table1\":"];
        NSRange endRagne2 =[xmlString rangeOfString:@"}</string>"];
        
        
        //获取回览明细表数据
        NSRange reusltRagnedetail2 = NSMakeRange(startRange2.location + startRange2.length, endRagne2.location - startRange2.location - startRange2.length);
        NSString *resultString2 = [xmlString substringWithRange:reusltRagnedetail2];
        
        NSString *requestTmp2 = [NSString stringWithString:resultString2];
        NSData *resData2 = [[NSData alloc] initWithData:[requestTmp2 dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *resultDic2 = [NSJSONSerialization JSONObjectWithData:resData2 options:NSJSONReadingMutableLeaves error:nil];
        listdetail = [MdlEvectionDetail mj_objectArrayWithKeyValuesArray:resultDic2];
        
        //获取头表数据
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        
        NSLog(@"%@", resultString);
        
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        
        listhead = [MdlBusinessTrip mj_objectArrayWithKeyValuesArray:resultDic];
        for (MdlBusinessTrip *p1 in listhead) {
            _imgvemp.image =[UIImage imageNamed:@"01.jpg"];
            
            _lblleavestatus.text = p1.ProcessStutasTxt;
            _emplbl.text = p1.EmpName;
            _lblempgroup.text = p1.G_CName;
            
            NSString * strapplyplace =[[NSString alloc]initWithFormat:@"%@%@",@"出差地点：",p1.ApplyPlace];
            
            _lblapplydate.text = strapplyplace;
            
            NSString * strleavedate =[[NSString alloc]initWithFormat:@"%@%@ ~ %@",@"出差时间：",p1.StartTime,p1.EndTime];
            
            _lblleavedate.text = strleavedate;
            
            _lblleavetype.text = @"";
            
            NSString * strleavecounts =[[NSString alloc]initWithFormat:@"%@%@",@"出差天数(h)：",p1.TimeNum];
            
            _lblleavecounts.text =strleavecounts;
            
            NSString * strleaveremark =[[NSString alloc]initWithFormat:@"%@%@",@"出差事由：",p1.BusinessTripReason];
            
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
            [self showError:resultStringtaskedit];
        }
        else
        {
            // 弹出 对话框
            [self showError:@"操作成功！"];
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
        BusinessTripDetailCell * cell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        cell.leavedetail =self.listdetail[indexPath.row];//取出数据元素
        
        return cell;
    } else if ([tableView isEqual:self.ImageTableView]) {
        
        BusinessTripDetailImagecell * cell = [self.ImageTableView dequeueReusableCellWithIdentifier:identifierImage forIndexPath:indexPath];
        
        cell.str  = @"Rem【ar【k【k2";
        
        return cell;
        
    }
    return 0;
    
}


@end
