//
//  LeavePendingViewController.m
//  jcapp
//
//  Created by lh on 2019/12/2.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "PendingViewController.h"
#import "MJExtension.h"
#import "../Model/Pending.h"
#import "PendingListCell.h"

static NSString * identifier = @"PendingListCell";

@interface PendingViewController ()

@end

@implementation PendingViewController
NSInteger currentPage;
@synthesize listOfMovies;

- (void)viewDidLoad {
    
    self.title = @"待审批记录";
    //e注册自定义 cell
    [_NewTableView registerClass:[PendingListCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight = 150;
    CGFloat headimageX = self.view.frame.size.width;
    CGFloat headimageY = self.view.frame.size.height;
    CGFloat headimageW = self.view.frame.size.width*1.104;
    CGFloat headimageH =  self.view.frame.size.height;
    self.NewTableView.frame = CGRectMake(0, 0, headimageW, headimageH);
    currentPage=1;
    [self LoadDate];
    [super viewDidLoad];
}

-(void)LoadDate
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"username"];
    NSString *userid = [defaults objectForKey:@"userid"];
    //设置需要访问的ws和传入参数
    // code, string userID, string menuID
    NSString *currentPagestr = [NSString stringWithFormat: @"%ld", (long)currentPage];
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetPendingInfo?pasgeIndex=%@&pageSize=%@&code=%@&userID=%@&menuID=%@",currentPagestr,@"10",@"19",@"19",@"4"];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
}
//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 字符串截取
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
    NSRange endRagne = [xmlString rangeOfString:@"</string>"];
    NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
    NSString *resultString = [xmlString substringWithRange:reusltRagne];
    NSString *requestTmp = [NSString stringWithString:resultString];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    listOfMovies = [Pending mj_objectArrayWithKeyValuesArray:resultDic];
    //[self.listOfMovies addObjectsFromArray:self.listMovies];
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
}

//解析返回的xml系统自带方法不需要h中声明
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    ipParser.delegate = self;
    [ipParser parse];
    [self.NewTableView reloadData];
}

//解析xml回调方法
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    info = [[NSMutableDictionary alloc] initWithCapacity: 1];
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
}

//解析返回xml的节点elementName
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
    currentTagName = elementName;
}

//取得我们需要的节点的数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
}

//循环解析d节点
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSMutableString *outstring = [[NSMutableString alloc] initWithCapacity: 1];
    for (id key in info) {
        [outstring appendFormat: @"%@: %@\n", key, [info objectForKey:key]];
    }
}


//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    return self.listOfMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PendingListCell * cell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(cell == nil)
    {
        if([indexPath row] == [self.listOfMovies count])
        {
            //新建一个单元格, 并且将其样式调整成我们需要的样子.
            cell=[[UITableViewCell alloc] initWithFrame:CGRectZero
                  
                                        reuseIdentifier:@"LoadMoreIdentifier"];
            cell.font = [UIFont boldSystemFontOfSize:13];
            cell.textLabel.text = @"读取更多...";
        }
    }
    else
    {
        cell.pendinglistitem =self.listOfMovies[indexPath.row];//取出数据元素
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == [self.listOfMovies count])
    {
        UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath];
        loadMoreCell.textLabel.text=@"正在读取更多信息 …";
        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    else
    {
        //其它单元格的事件
    }
}
-(void)loadMore
{
    //当你按下这个按钮的时候, 意味着你需要看下一页了, 因此当前页码加1
    currentPage++;
    [self LoadDate];//通过调用GetRecord方法, 将数据取出.
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // 返回顶部标题
    return @"待审批记录";
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    // 返回底部文字
    return @"中道益通";
}

@end
