//
//  VatationPageViewController.m
//  jcapp
//
//  Created by zhaodan on 2019/11/21.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "VatationPageViewController.h"
#import "../Model/Vatcation.h"
#import "../MJExtension/MJExtension.h"
@interface VatationPageViewController ()

@end

@implementation VatationPageViewController

- (void)viewDidLoad {
    
    allString = @"";
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetVacation?data=%@", @"1"];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    [super viewDidLoad];
    count = 1;
    // Do any additional setup after loading the view, typically from a nib.
    //NSArray *provinces=[[NSArray alloc] initWithObjects:@"事假",@"病假",@"年假",@"调休",@"婚假",@"产假",@"陪产//假",@"计划生育假", nil];
   
    //行高
    
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%@", @"2是否走到这里1");
    
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@", @"3是否走到这里1");
    return [vatcationArray count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"cellid";
    
     Vatcation  *m =vatcationArray[indexPath.row];//取出数据元素
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
     cell.textLabel.text =  [NSString stringWithFormat:@"%@",m.Name];
    
    //当上下拉动的时候，因为cell的复用性，我们需要重新判断一下哪一行是打勾的
    if (_selIndex == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    

    [defaults setObject:cell.textLabel.text forKey:@"vatcationname"];

    [defaults synchronize];//保存到磁盘
                

    
    
    return cell;
    
    
    
    ////////
    NSLog(@"%@",@"tableView1-begin");
    
    /*
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }

    cell.textLabel.text =  [NSString stringWithFormat:@"%@",m.Name];
    cell.detailTextLabel.text = @"按天请假     >";
    return cell;
     */
    
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //之前选中的，取消选择
    UITableViewCell *celled = [tableView cellForRowAtIndexPath:_selIndex];
    
    celled.accessoryType = UITableViewCellAccessoryNone;
    //记录当前选中的位置索引
    _selIndex = indexPath;
    //当前选择的打勾
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
}

//调用ws之后的方法
//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    
    NSLog(@"%@", data);
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //NSString *gbkNSString = [[NSString alloc] initWithData:data encoding: enc];
    
    NSLog(@"%@", xmlString);
    
    //NSLog(@"%@", utf8NSString);
    //下边为手动释放内存需要进行设置MRC 和 ARC
    //[gbkNSString release];
    
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
//解析返回的xml系统自带方法不需要h中声明
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSLog(@"%@", @"test3");
    NSLog(@"%@", xmlString);
    NSLog(@"%@", @"kaishijiex");    //开始解析XML
    
    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    ipParser.delegate = self;
    [ipParser parse];
    
    vatcationArray = [Vatcation mj_objectArrayWithKeyValuesArray:allString];
    [tableview reloadData];
    
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
    currentTagName = elementName;
}

//取得我们需要的节点的数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    allString = [allString stringByAppendingString:string];
    
    
    //此处解析出来全部为单个的字段
    NSLog(@"%@", @"test7");
    
    
    NSLog(@"value: %@\n", allString);
    
    
}

-(IBAction)onClickButtontest:(id)sender {
    
    // 定义一个JSON字符串
    NSLog(@"%@", allString);
    // JSON字符串转模型
    //Vatcation *vatcation = [Vatcation mj_objectWithKeyValues:allString];
    
    vatcationArray = [Vatcation mj_objectArrayWithKeyValuesArray:allString];
    
    for (Vatcation *vatcation in vatcationArray) {
        NSLog(@"name=%@",  vatcation.Name);
    }
    self.data = vatcationArray;
    
    tableview.rowHeight = 59;
    NSLog(@"%@", @"1是否走到这里1");
    
    
    //[tableview reloadData];
    
}

-(IBAction)onClickButtonreturn:(id)sender {
    

     [self dismissViewControllerAnimated:YES completion:nil];//返回上一页面
    //[tableview reloadData];
    
}




- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
}

//循环解析d节点
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    //此处没有用处？
    /*
     NSMutableString *outstring = [[NSMutableString alloc] initWithCapacity: 1];
     for (id key in info) {
     [outstring appendFormat: @"%@: %@\n", key, [info objectForKey:key]];
     NSLog(@"%@", @"key");
     NSLog(@"%@", outstring);
     
     }
     */
    
    
    
    //[outstring release];
    //[xmlString release];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
