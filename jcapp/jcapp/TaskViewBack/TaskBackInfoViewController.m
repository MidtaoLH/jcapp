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

@property (nonatomic, strong) NSMutableArray *srcStringArray;

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
    self.navigationItem.title=self.title;
    [self loadstyle];
    [self loadInfo];
    [self loadTaskInfo];
  
    if([self.pagetype isEqualToString:@"0"] && self.taskcode.length!=0)
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
    _lblccdr.textColor = [UIColor grayColor];
    _lblccdr.font=kFont_Lable_14;
    _lblprocstatus.font=kFont_Lable_18;
    _lblproctype.font=kFont_Lable_16;
    _imgvprocstatus.backgroundColor = kColor_Cyan;
    //注册自定义 cell
    [_NewTableView registerClass:[TaskBackListCell class] forCellReuseIdentifier:identifier];
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
    [_imgvprocstatus mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加右
        make.right.mas_equalTo(-Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(Common_StatusImageSize,Common_StatusImageSize));
    }];
    [_lblprocstatus mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [_lblccdr mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize*2);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-Common_ColSize,Common_TxTHeight));
    }];
    [_lblproctype mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
      make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-Common_ColSize,Common_TxTHeight));
    }];
    [_lblprocdate mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
       make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize*3);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-Common_ColSize,Common_TxTHeight));
    }];
    [_lblproccounts mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
       make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize*4);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-Common_ColSize,Common_TxTHeight));
    }];
    [_lblprocremark mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize*5);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-Common_ColSize,Common_TxTHeight));
    }];
    [_ImageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(0);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_RowSize*6);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, Common_ImageTableHeight));
    }];
    [_lblcr mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加左
        make.left.mas_equalTo(Common_ColSize);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_ImageTableHeight+Common_RowSize*6);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,  Common_TxTHeight));
    }];
    // 审批列表view添加约束
    [_NewTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight-(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_ImageTableHeight+Common_RowSize*7)));
        // 添加左
        make.left.mas_equalTo(0);
        // 添加上
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight+Common_UserImageSize+Common_ImageTableHeight+Common_RowSize*7);
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
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetProcInfo?userID=%@&processInstanceID=%@&pageType=%@",userid,self.code,self.pagetype];
    
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
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetProcFile?userID=%@&processInstanceID=%@&pageType=%@",userid,self.code,self.pagetype];
    
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
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetProcTaskInstance?userID=%@&processInstanceID=%@&pageType=%@",userid,self.code,self.pagetype];
    
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
        //self.navigationItem.title=viewBackInfo.DocumentName;
        self.emplbl.text=viewBackInfo.ApplyManName;
        self.lblempgroup.text=viewBackInfo.ApplyGroupName;
        self.lblapplydate.text=[NSString stringWithFormat:@"申请时间:%@",viewBackInfo.ApplyDate];
        
        self.lblproctype.text=viewBackInfo.HistoryType;
        self.lblprocdate.text=[NSString stringWithFormat:@"%@时间：%@～%@",viewBackInfo.DocumentName,viewBackInfo.strattime,viewBackInfo.endtime];
       
        if([viewBackInfo.DocumentName isEqual:@"出差"])
        {
             self.lblproccounts.text=[NSString stringWithFormat:@"%@时长（天）：%@",viewBackInfo.DocumentName,viewBackInfo.ApplyAmount];
             self.lblccdr.text=[NSString stringWithFormat:@"出差地点:%@",viewBackInfo.CCAddress];
        }
        else
        {
             self.lblproccounts.text=[NSString stringWithFormat:@"%@时长（h）：%@",viewBackInfo.DocumentName,viewBackInfo.ApplyAmount];
             self.lblccdr.text=@"";
        }
       
        self.lblprocremark.text=[NSString stringWithFormat:@"%@事由：%@",viewBackInfo.DocumentName,viewBackInfo.ProcDescribe];
        self.lblprocstatus.text=viewBackInfo.ProcStatus;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,viewBackInfo.ApplyMan];
        [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString]];
        self.imgvemp.image=imageView.image;
        [self loadImageInfo];

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
        listtask = [ViewBackDetail mj_objectArrayWithKeyValuesArray:resultDic];
        
        self.srcStringArray = [NSMutableArray arrayWithCapacity:listtask.count];
        for(int i=0;i<[listtask count];i++)
        {
            ViewBackDetail *detail=listtask[i];
            NSString *obj = [NSString stringWithFormat:Common_WSUrl,detail.AttachFilePath];
            [_srcStringArray addObject:obj];
        }
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
}
//解析xml回调方法
- (void)parserDidStartDocument:(NSXMLParser *)parser {
}
//解析返回xml的节点elementName
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
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
}
//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//如果不设置section 默认就1组
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 默认有此行，请删除或注 释 #warning Incomplete method implementation.
    // 这里是返回节点的行数
    if ([tableView isEqual:self.NewTableView]) {
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
