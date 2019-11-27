//
//  NewViewController.m
//  jcapp
//
//  Created by zclmac on 2019/11/25.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "NewViewController.h"
#import "MJExtension.h"
#import "../Model/NoticeNews.h"

@interface NewViewController ()


@end

@implementation NewViewController

static NSString *identifier =@"TableViewCell";

@synthesize listOfMovies;

- (void)viewDidLoad {
     
    NSLog(@"%@",@"viewDidLoad-bgn");
 
    //设置需要访问的ws和传入参数
    
     NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetNoticeNews"];
    
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
 
    
   /* listOfMovies = [[NSMutableArray alloc] init];
    
    [listOfMovies addObject:@"I Love Tony"];
    [listOfMovies addObject:@"美丽心灵"];
    [listOfMovies addObject:@"雨人"];
    [listOfMovies addObject:@"波拉克"];
    [listOfMovies addObject:@"暗物质"];
    [listOfMovies addObject:@"天才瑞普利"];
    [listOfMovies addObject:@"猫鼠游戏"];
    [listOfMovies addObject:@"香水"];
    [listOfMovies addObject:@"一级恐惧"];
    [listOfMovies addObject:@"心灵捕手"];
    [listOfMovies addObject:@"莫扎特传"];
    [listOfMovies addObject:@"证据"];
    [listOfMovies addObject:@"海上钢琴师"];
    [listOfMovies addObject:@"电锯惊魂"];
    [listOfMovies addObject:@"沉默的羔羊"];
    [listOfMovies addObject:@"非常嫌疑犯"];
    [listOfMovies addObject:@"寻找弗罗斯特"];*/
   
    [super viewDidLoad];
   NSLog(@"%@",@"viewDidLoad-end");
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
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
    NSRange endRagne = [xmlString rangeOfString:@"</string>"];
    NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
    NSString *resultString = [xmlString substringWithRange:reusltRagne];
    
    NSLog(@"%@", resultString);
    
    NSString *requestTmp = [NSString stringWithString:resultString];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
 
    
    NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    listOfMovies = [NoticeNews mj_objectArrayWithKeyValuesArray:resultDic];
 
  NSLog(@"%@",@"connection1-end");
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
    return self.listOfMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
    }
    // 大家还记得，之前让你们设置的Cell Identifier 的 值，一定要与前面设置的值一样，不然数据会显示不出来
 // UITableViewCell *cell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
 
    NoticeNews *m =self.listOfMovies[indexPath.row];//取出数据元素
 
    cell.textLabel.text = m.NewsTheme;
 
    cell.detailTextLabel.text = m.NewsContent;
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // 返回顶部标题
    NSLog(@"%@",@"tableView2-begin");
    return @"公告";
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSLog(@"%@",@"tableView3-begin");
    // 返回底部文字
    return @"中道益通";
}







@end
