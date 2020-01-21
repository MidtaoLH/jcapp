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
#import "SelectUserViewController.h"
#import "SkyAssociationMenuView.h"
#import "../Model/Group.h"
#import "../MJExtension/MJExtension.h"
#import "../Model/Emp.h"
#import "AppDelegate.h"
#import "SetAgentViewController.h"
#import "../TabBar/TabBarViewController.h"
#import "Masonry.h"
#import "ViewController.h"

@interface VatationPageViewController ()

@end

@implementation VatationPageViewController

NSString *strtype;

- (void)viewDidLoad {
    
        [super viewDidLoad];
    
    allString = @"";
    //设置需要访问的ws和传入参数
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    iosid = [defaults objectForKey:@"adId"];
    
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetVacation?data=%@&userID=%@&iosid=%@", @"1",userID,iosid];
    
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
    NSURL *url = [NSURL URLWithString:strURL];
    
    
    //NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetVacation?data=%@", @"1"];
    //NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];

    count = 1;

    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view, typically from a nib.
    //NSArray *provinces=[[NSArray alloc] initWithObjects:@"事假",@"病假",@"年假",@"调休",@"婚假",@"产假",@"陪产//假",@"计划生育假", nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gotoback)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.title=@"请假类型";
    //行高
    
  //  self.title = @"标题";
    
    // 添加账单按钮
 //   UIBarButtonItem *bill = [[UIBarButtonItem alloc] initWithTitle:@"账单" style:UIBarButtonItemStylePlain target:nil action:nil];
 //   self.navigationItem.rightBarButtonItem = bill;
    
}
-(void)gotoback {
    //点击返回的时候 把选择的数据清空
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"vatcationname"];
    [defaults synchronize];//保存到磁盘
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)save {
 
    //当代理响应sendValue方法时，把_tx.text中的值传到VCA
    if ([_delegate respondsToSelector:@selector(sendValue:)]) {
        [_delegate sendValue:strtype];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    // 定义一个JSON字符串
    [self dismissViewControllerAnimated:YES completion:nil];//返回上一页面
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
    
    //如果已经选择 类型 直接打勾
    if(_selectindex != nil)
    {
        if([m.Name isEqual: _selectindex])
        {
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
            _selectindex = nil;
            _selIndex = indexPath;
        }
    }
    
     NSLog(@"%@",@"tableView1-begin");
    return cell;
 
    ////////
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
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    strtype = cell.textLabel.text;
    [defaults setObject:cell.textLabel.text forKey:@"vatcationname"];
    
    [defaults synchronize];//保存到磁盘
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//调用ws之后的方法
//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    @try {
        NSLog(@"%@", data);
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        //NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //NSString *gbkNSString = [[NSString alloc] initWithData:data encoding: enc];
        
        if([xmlString containsString: Common_MoreDeviceLoginFlag])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"" message: Common_MoreDeviceLoginErrMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            ViewController * valueView = [[ViewController alloc] initWithNibName:@"ViewController"bundle:[NSBundle mainBundle]];
            //跳转
            [self presentModalViewController:valueView animated:YES];
        }
        else
        {
            NSLog(@"%@", xmlString);
            
            //NSLog(@"%@", utf8NSString);
            //下边为手动释放内存需要进行设置MRC 和 ARC
            //[gbkNSString release];
        }
        
       
        
    }
    @catch (NSException *exception) {
        
    }
    
    
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
    
    //当代理响应sendValue方法时，把_tx.text中的值传到VCA
    if ([_delegate respondsToSelector:@selector(sendValue:)]) {
        [_delegate sendValue:strtype];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    // 定义一个JSON字符串
 [self dismissViewControllerAnimated:YES completion:nil];//返回上一页面
 /*    [self.formTableView beginUpdates];
    [self.formTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.formTableView endUpdates];
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.way_groupname =lbgroupname.text;
    myDelegate.way_groupid =lbgroupid.text;
    myDelegate.way_empid =lbempid.text;
    myDelegate.way_empname =lbempname.text;
    
    myDelegate.agentType = @"true";
    myDelegate.TimeStart=self.startTime;
    myDelegate.TimeEnd=self.endTime;
    myDelegate.agentid=self.agentID;
    SetAgentViewController  * VCCollect = [[SetAgentViewController alloc] init];
    [self.navigationController pushViewController:VCCollect animated:YES];*/
}

-(IBAction)onClickButtonreturn:(id)sender {
    
    //点击返回的时候 把选择的数据清空
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    
    [defaults setObject:@"" forKey:@"vatcationname"];
    
    [defaults synchronize];//保存到磁盘
    
NSLog(@"%@", @"return");
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
