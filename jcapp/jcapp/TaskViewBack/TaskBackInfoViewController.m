//
//  TaskBackInfoViewController.m
//  jcapp
//
//  Created by lh on 2019/12/15.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "TaskBackInfoViewController.h"
#import "MJExtension.h"
#import "ExamineEditImageCell.h"
#import "TaskBackListCell.h"
#import "SDDemoCell.h"
#import "SDPhotoItem.h"
#import "../Model/ViewBackInfo.h"
#import "../Model/ViewBackTask.h"
#import "../Model/ViewBackDetail.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#import "Masonry.h"
#define kCount 6  //图片总张数

static long step = 0; //记录时钟动画调用次数
@interface TaskBackInfoViewController ()
{
    CGFloat scaleMini;
    CGFloat scaleMax;
    
}
@property (nonatomic, strong) NSArray *srcStringArray;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation TaskBackInfoViewController


static NSString *identifier =@"TaskBackListCell";
static NSString *identifierImage =@"WaitTaskImageCell";

@synthesize  listtask;
@synthesize  listdetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子视图的f导航栏的返回按钮
  
    [self loadstyle];
    [self loadInfo];
    [self loadTaskInfo];
  
    if( self.taskcode.length!=0)
    {
        [self updateStatus];
    }
}

-(void)loadstyle{
    _emplbl.font=kFont_Lable_15;
    _lblempgroup.textColor = [UIColor grayColor];
    _lblempgroup.font=kFont_Lable_14;
    _lblprocdate.textColor = [UIColor grayColor];
    _lblprocdate.font=kFont_Lable_14;
    _lblapplydate.textColor = [UIColor grayColor];
    _lblapplydate.font=kFont_Lable_14;
    _lblproccounts.textColor = [UIColor grayColor];
    _lblproccounts.font=kFont_Lable_14;
    _lblprocremark.textColor = [UIColor grayColor];
    _lblprocremark.font=kFont_Lable_14;
    _lblprocstatus.font=kFont_Lable_18;
    _lblproctype.font=kFont_Lable_16;
    CGFloat tabBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    _imgvprocstatus.backgroundColor = kColor_Cyan;
    NSInteger ColSize=[Common_ColSize intValue];//列宽
    NSInteger RowSize=[Common_RowSize intValue];//行高
    NSInteger UserIamgeSize=[Common_UserImageSize intValue];//头像图片大小
    NSInteger StatusImageSize=[Common_StatusImageSize intValue];//状态图片
    NSInteger TxTHeight=[Common_TxTHeight intValue];//文本高度
    NSInteger TxTWidth=[Common_TxTWidth intValue];//文本宽度
    NSInteger TableHeight=[Common_TableHeight intValue];//列表高度
    NSInteger ImageTableHeight=[Common_ImageTableHeight intValue];//图片列表高度
    NSInteger TableRowHeight=[Common_TableRowHeight intValue];
    NSInteger ImageTableRowHeight=[Common_ImageTableRowHeight intValue];
    
    //注册自定义 cell
    [_NewTableView registerClass:[TaskBackListCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight = TableRowHeight;
    
    [_ImageTableView registerClass:[SDDemoCell class] forCellReuseIdentifier:identifierImage];
    _ImageTableView.rowHeight = ImageTableRowHeight;
    [_imgvemp mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(ColSize);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(UserIamgeSize,UserIamgeSize));
    }];
    [_imgvprocstatus mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加右
        make.right.mas_equalTo(-ColSize);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(StatusImageSize,StatusImageSize));
    }];
    [_lblprocstatus mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加右
        make.right.mas_equalTo(-ColSize);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(StatusImageSize,StatusImageSize));
    }];
    [_emplbl mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(UserIamgeSize+ColSize*2);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(TxTWidth,TxTHeight));
    }];
    [_lblempgroup mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(UserIamgeSize+ColSize*2);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+RowSize*2);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(TxTWidth,TxTHeight));
    }];
    [_lblapplydate mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(UserIamgeSize+ColSize*2);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+RowSize*3);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(TxTWidth,TxTHeight));
    }];
    [_lblproctype mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(ColSize);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+UserIamgeSize+RowSize*2);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(TxTWidth,TxTHeight));
    }];
    [_lblprocdate mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(ColSize);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+UserIamgeSize+RowSize*3);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(TxTWidth*2,TxTHeight));
    }];
    [_lblproccounts mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(ColSize);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+UserIamgeSize+RowSize*4);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(TxTWidth,TxTHeight));
    }];
    [_lblprocremark mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(ColSize);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+UserIamgeSize+RowSize*5);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(TxTWidth,TxTHeight));
    }];
    [_ImageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(0);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+UserIamgeSize+RowSize*6);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(self.view.width, ImageTableHeight));
    }];
    [_lblcr mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(ColSize);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+UserIamgeSize+ImageTableHeight+RowSize*6);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(self.view.width, TxTHeight));
    }];
    // 审批列表view添加约束
    [_NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(self.view.width, TableHeight));
        // 添加左
        make.left.mas_equalTo(0);
        // 添加上
        make.top.mas_equalTo(tabBarHeight+UserIamgeSize+ImageTableHeight+RowSize*7);
    }];
    _imgvemp.layer.masksToBounds = YES;
    _imgvemp.layer.cornerRadius = self.imgvemp.width * 0.5;
    
    _imgvprocstatus.layer.masksToBounds = YES;
    _imgvprocstatus.layer.cornerRadius = self.imgvprocstatus.width * 0.5;
}
-(void)updateStatus
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userid= [defaults objectForKey:@"userid"];
    //设置需要访问的ws和传入参数
    // code, string userID, string menuID
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/UpdateTaskViewStatus?userID=%@&processInstanceID=%@",userid,self.taskcode];
    
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
}
-(void)loadInfo
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userid= [defaults objectForKey:@"userid"];
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetViewBackInfo?userID=%@&processInstanceID=%@",userid,self.code];
    
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
}
-(void)loadImageInfo
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userid= [defaults objectForKey:@"userid"];
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetViewBackFile?userID=%@&processInstanceID=%@",userid,self.code];
    
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
}
-(void)loadTaskInfo
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userid= [defaults objectForKey:@"userid"];
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetViewBackTaskInstance?userID=%@&processInstanceID=%@",userid,self.code];
    
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
    
    if([xmlString containsString:@"ProcessInstanceID"])
    {
        // 字符串截取
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">["];
        NSRange endRagne = [xmlString rangeOfString:@"]</string>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        ViewBackInfo *viewBackInfo = [ViewBackInfo mj_objectWithKeyValues:resultDic];
        self.navigationItem.title=viewBackInfo.DocumentName;
        self.emplbl.text=viewBackInfo.ApplyManName;
        self.lblempgroup.text=viewBackInfo.ApplyGroupName;
        self.lblapplydate.text=[NSString stringWithFormat:@"申请时间:%@",viewBackInfo.ApplyDate];
        
        self.lblproctype.text=viewBackInfo.HistoryType;
        self.lblprocdate.text=[NSString stringWithFormat:@"%@时间：%@～%@",viewBackInfo.DocumentName,viewBackInfo.strattime,viewBackInfo.endtime];
        self.lblproccounts.text=[NSString stringWithFormat:@"%@时长（h）：%@",viewBackInfo.DocumentName,viewBackInfo.ApplyAmount];
        self.lblprocremark.text=[NSString stringWithFormat:@"%@事由：%@",viewBackInfo.DocumentName,viewBackInfo.ProcDescribe];
        self.lblprocstatus.text=viewBackInfo.ProcStatus;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,viewBackInfo.ApplyMan];
        [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString]];
        self.imgvemp.image=imageView.image;
        [self loadImageInfo];
        _srcStringArray = @[@"http://47.94.85.101:8095/img/01.jpg",
                            @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                            ];
        [self.ImageTableView reloadData];
        [self.ImageTableView layoutIfNeeded];
    }
    else  if([xmlString containsString:@"AttachFilePath"])
    {
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
        NSRange endRagne = [xmlString rangeOfString:@"</string>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        _srcStringArray = [ViewBackDetail mj_objectArrayWithKeyValuesArray:resultDic];
        [self.ImageTableView reloadData];
        [self.ImageTableView layoutIfNeeded];
    }
    else if([xmlString containsString:@"TaskNodeLevel"])
    {
        NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
        NSRange endRagne = [xmlString rangeOfString:@"</string>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [xmlString substringWithRange:reusltRagne];
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        listdetail = [ViewBackTask mj_objectArrayWithKeyValuesArray:resultDic];
        [self.NewTableView reloadData];
        [self.NewTableView layoutIfNeeded];
    }
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
        TaskBackListCell * wcell = [self.NewTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        wcell.taskBacklistitem =self.listdetail[indexPath.row];//取出数据元素
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
