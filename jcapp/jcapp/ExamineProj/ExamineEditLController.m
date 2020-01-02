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
#import "ExamineEditCell.h"
#import "SDDemoCell.h"
#import "SDPhotoItem.h"

#define kCount 4  //图片总张数
 
@interface ExamineEditLController ()
{
    CGFloat scaleMini;
    CGFloat scaleMax;
    
     //0 初始化 1 承认 2 驳回
    long edittype;

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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    edittype = 0;
    self.strTaskid = @"23180";
    
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetExamineEditData?userID=%@&taskID=%@&TaskType=%@",@"1",self.strTaskid,@"2"];
    
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
    //注册自定义 cell
    [_NewTableView registerClass:[ExamineEditCell class] forCellReuseIdentifier:identifier];
    _NewTableView.rowHeight = 100;
    
    [_ImageTableView registerClass:[SDDemoCell class] forCellReuseIdentifier:identifierImage];
    _ImageTableView.rowHeight = 150;
    
    NSLog(@"%@",@"viewDidLoad-end");
    
    _imgvleavestatus.layer.masksToBounds = YES;
    
    _imgvleavestatus.layer.cornerRadius = _imgvleavestatus.frame.size.width / 2;
    
    _imgvleavestatus.backgroundColor = [UIColor greenColor];
    [self setlblcolor];
    
    _srcStringArray = @[@"http://47.94.85.101:8095/img/01.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
             	           //  @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                        //    @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                     //   @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                     //   @"http://ww1.sinaimg.cn/thumbnail/9be2329dgw1etlyb1yu49j20c82p6qc1.jpg"
                        ];
    
    
     [_btntaskno addTarget:self action:@selector(actionno:)   forControlEvents:UIControlEventTouchUpInside];
     [_buttaskyes addTarget:self action:@selector(actionyes:)   forControlEvents:UIControlEventTouchUpInside];
    
    //当前登陆者
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *userid = [defaults objectForKey:@"userid"];
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
-(void)taskedittoservice:(NSMutableDictionary *)mutableDic0
{
    
    id objtasktype = mutableDic0[@"tasktype"];
    id objremark = mutableDic0[@"remark"];
    
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/TaskInstanceEdit?userID=%@&taskInstanceID=%@&Remark=%@&operate=%@&operatr=%@",@"1",self.strTaskid,objremark,objtasktype,@"1"];
    
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
}
// 驳回操作
-(void)actionno:(id)sender{
 
    NSLog(@"Vvvverify : %@", @"23423");
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

-(void)setlblcolor
{
    _lblempgroup.textColor = [UIColor grayColor];
    _lblleavedate.textColor = [UIColor grayColor];
    _lblapplydate.textColor = [UIColor grayColor];
    _lblleavecounts.textColor = [UIColor grayColor];
    _lblleaveremark.textColor = [UIColor grayColor];
    
    _txtvexamineremark.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _txtvexamineremark.layer.borderColor = [[UIColor redColor]CGColor];
    _txtvexamineremark.layer.borderWidth = 1.0;
    [_txtvexamineremark.layer setMasksToBounds:YES];
}


//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%@",@"connection1-begin");
 
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", @"kaishidayin");
    
    // 字符串截取
    NSRange startRangetaskedit = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
    NSRange endRangetaskedit =[xmlString rangeOfString:@"</string>"];
    
    if(edittype == 1)
    {
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
        NSRange reusltRagnedetaskedit = NSMakeRange(startRangetaskedit.location + startRangetaskedit.length, endRangetaskedit.location - startRangetaskedit.location - startRangetaskedit.length);
        NSString *resultStringtaskedit = [xmlString substringWithRange:reusltRagnedetaskedit];
        
        if(![resultStringtaskedit isEqualToString:@"0"])
        {
            // 弹出“请检查用户名和密码是否为空！”对话框
            [self showError:resultStringtaskedit];
        }
        else
        {
            // 弹出 对话框
            [self showError:@"操作成功！"];
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
            _imgvemp.image =[UIImage imageNamed:@"01.jpg"];
            
            _lblleavestatus.text = p1.StatusTxt;
            _emplbl.text = p1.EmpCName;
            _lblempgroup.text = p1.groupname;
            
            NSString * strapplydate =[[NSString alloc]initWithFormat:@"%@%@",@"申请时间：",p1.ExamineDate];
            
            _lblapplydate.text = strapplydate;
            
            NSString * strleavedate =[[NSString alloc]initWithFormat:@"%@%@ ~ %@",@"请假时间：",p1.BeignDate,p1.EndDate];
            
            _lblleavedate.text = strleavedate;
            
            _lblleavetype.text = p1.TypeTxt;
            
            NSString * strleavecounts =[[NSString alloc]initWithFormat:@"%@%@",@"请假时长(h)：",p1.numcount];
            
            _lblleavecounts.text =strleavecounts;
            
            NSString * strleaveremark =[[NSString alloc]initWithFormat:@"%@%@",@"请假事由：",p1.Describe];
            
            _lblleaveremark.text = strleaveremark;
        }
        
    }
 
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
        wcell.leavedetail =self.listdetail[indexPath.row];//取出数据元素
        
        return wcell;
    } else if ([tableView isEqual:self.ImageTableView]) {
        
        
        SDDemoCell *sdcell =[self.ImageTableView dequeueReusableCellWithIdentifier:identifierImage forIndexPath:indexPath];
        //[tableView dequeueReusableCellWithIdentifier:identifierImage];
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

@end
