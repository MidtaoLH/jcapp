//
//  LeaveDetailController.m
//  jcapp
//
//  Created by zclmac on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "WaitTaskController.h"
#import "MJExtension.h"
#import "../Model/LeaveHead.h"
#import "../Model/LeaveDeatil.h"
#import "WaitTaskImageCell.h"
#import "../Model/LeaveTask.h"
#import "WaitTaskCell.h"


#define kCount 6  //图片总张数

 static long step = 0; //记录时钟动画调用次数

@interface WaitTaskController ()
{
    CGFloat scaleMini;
    CGFloat scaleMax;
}

@property (strong,nonatomic) LeaveHead *leavehead;
 
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation WaitTaskController

static NSString *identifier =@"WaitTaskCell";
static NSString *identifierImage =@"WaitTaskImageCell";

@synthesize listdetail;
@synthesize listhead;
@synthesize  listtask; 

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.title = @"请假";
    
    //设置需要访问的ws和传入参数
    
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetLeaveDetail"];
    
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
    //e注册自定义 cell
    [_NewTableView registerClass:[WaitTaskCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight = 150;

    [_ImageTableView registerClass:[WaitTaskImageCell class] forCellReuseIdentifier:identifierImage];
    _ImageTableView.rowHeight = 150;
    
        NSLog(@"%@",@"viewDidLoad-end");
    
    _imgvleavestatus.layer.masksToBounds = YES;
    
    _imgvleavestatus.layer.cornerRadius = _imgvleavestatus.frame.size.width / 2;
    
    _imgvleavestatus.backgroundColor = [UIColor greenColor];
    [self setlblcolor];

    /*
    self.scrollview.frame=CGRectMake(0, 236, self.view.frame.size.width, 200);
    self.scrollview.backgroundColor= UIColor.orangeColor;
    self.scrollview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    int index = 0;
    //
    //    图片的宽
    CGFloat imageW = 100;
    //    CGFloat imageW = 300;
    //    图片高
    CGFloat imageH = 100;
    //    图片的Y
    CGFloat imageY = 50;
    
    for (int i = 0; i < 3; i++) {
        index=i;
        UIImageView *imageView = [[UIImageView alloc] init];
        //        图片X
        CGFloat imageX = i * imageW + i*50;
 
        //        设置图片
        NSString *name = [NSString stringWithFormat:@"0%d.jpg", i + 1];
        imageView.image = [UIImage imageNamed:name];
 
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapAction:)];
        [imageView addGestureRecognizer:tap];
        //        隐藏指示条
        self.scrollview.showsHorizontalScrollIndicator = NO;
        
        //        设置frame
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [self.scrollview addSubview:imageView];
        
    }
    // 2.设置scrollview的滚动范围-----
    CGFloat contentW = 500 *imageW;
    //不允许在垂直方向上进行滚动
    self.scrollview.contentSize = CGSizeMake(contentW, 0);
    
    */
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
    //upateData = [[NSData alloc] initWithData:data];
    //默认对于中文的支持不好
    //   NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //   NSString *gbkNSString = [[NSString alloc] initWithData:data encoding: enc];
    //如果是非UTF－8  NSXMLParser会报错。
    //   xmlString = [[NSString alloc] initWithString:[gbkNSString stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"gbk\"?>"
    //                                                                                       withString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"]];
    
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", @"kaishidayin");
    NSLog(@"%@", xmlString);
    
    // 字符串截取
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">{\"ds\":"];
    NSRange endRagne = [xmlString rangeOfString:@",\"ds1\":"];
    
    NSRange startRange2 =[xmlString rangeOfString:@",\"ds1\":"];
    NSRange endRagne2 =[xmlString rangeOfString:@"}</string>"];
 

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
        _imgvemp.image =[UIImage imageNamed:@"01.jpg"];

    }

    
    
    NSLog(@"%@", resultString2);
    
    NSLog(@"%@",@"connection1-end");
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
        WaitTaskCell * cell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        cell.leavedetail =self.listdetail[indexPath.row];//取出数据元素
        
        return cell;
    } else if ([tableView isEqual:self.ImageTableView]) {
        
       WaitTaskImageCell * cell = [self.ImageTableView dequeueReusableCellWithIdentifier:identifierImage forIndexPath:indexPath];
        
        cell.str  = @"Rem【ar【k【k2";
        
        return cell;
        
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
