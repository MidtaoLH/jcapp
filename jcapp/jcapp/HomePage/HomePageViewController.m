//
//  HomePageViewController.m
//  jcapp
//
//  Created by youkare on 2019/11/20.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "HomePageViewController.h"
#import "../Notice/NewViewController.h"
#import "WebViewController.h"
#import "../MJExtension/MJExtension.h"
#import "../Model/ScrollView.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#import "DXLAutoButtonView.h"
#import "../Leave/LeaveViewController.h"
#import "../Leave/LeaveTabBarViewController.h"

#import "../GoOut/GoOutViewController.h"
#import "../GoOut/GoOutTabBarViewController.h"

#import "../PendingPage/PendingViewController.h"
#import "../MyApply/MyApplyTabBarViewController.h"
#import "../PendingPage/PendingTabBarViewController.h"
#import "../AttendanceCalendar/AttendanceTabBarViewController.h"
#import "../AttendanceCalendar/AttendanceCalendarViewController.h"
#import "../BusinessTrip/BusinessTripTabBarViewController.h"

#import "../TaskViewBack/TaskViewTabBarViewController.h"
/**屏幕尺寸-宽度*/
#define kWidth ([UIScreen mainScreen].bounds.size.width)
/**屏幕尺寸-高度*/
#define kHeight ([UIScreen mainScreen].bounds.size.height)

@interface HomePageViewController ()
{
    int *index;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
- (IBAction)test:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomePageViewController
static NSString *identifier =@"TableViewCell";
@synthesize listOfMovies;

- (void)viewDidLoad {
    //调用webservice
    
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,@"AppWebService.asmx/GetScrollviewList"];
    //[NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetScrollviewList"];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
    [super viewDidLoad];
    CGFloat navigationBarAndStatusBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    self.scrollview.frame=CGRectMake(0, navigationBarAndStatusBarHeight, self.view.frame.size.width, 200);
    self.scrollview.backgroundColor= UIColor.orangeColor;
    
    //设置顶部导航栏的显示名称
    self.navigationItem.title=@"北京中道益通软件技术有限公司";
    //设置子视图的f导航栏的返回按钮
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    [self setView1];
    [self setView2];
    [self setView3];
}

- (void)nextImage
{
    int page = (int)self.pageControl.currentPage;
    if (page == self.listOfMovies.count-1) {
        page = 0;
    }else
    {
        page++;
    }
    
    //  滚动scrollview
    CGFloat x = page * self.scrollview.frame.size.width;
    self.scrollview.contentOffset = CGPointMake(x, 0);
}

// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"滚动中");
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.pageControl.currentPage = page;
}

// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
    //    [self.timer invalidate];
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    开启定时器
    [self addTimer];
}

/**
 *  开启定时器
 */
- (void)addTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}
/**
 *  关闭定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
}
- (IBAction)test:(id)sender {
    //NoticeViewController * VCCollect = [[NoticeViewController alloc] init];
    //[self.navigationController pushViewController:VCCollect animated:YES];
    
    //发送请求
    NSURL *url=[NSURL URLWithString:@"http://www.baidu.com"];
    //请求
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(!connectionError){
            //把二进制数据转化成NSString
            //NSString *html=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            //
            WebViewController *web=[[WebViewController alloc] init];
            //[web.webview loadRequest:request];
            //[self.webview loadHTMLString:html baseURL:nil];
            [self.navigationController pushViewController:web animated:YES];
            web.request=request;
            
            //NSLog(@"%@",html);
        }else{
            NSLog(@"连接出错%@",connectionError);
        }
    }];
    
}

//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"%@",@"connection1-begin");
    
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", @"kaishidayin");
    //NSLog(@"%@", xmlString);
    
    // 字符串截取
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
    NSRange endRagne = [xmlString rangeOfString:@"</string>"];
    NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
    NSString *resultString = [xmlString substringWithRange:reusltRagne];
    
    //NSLog(@"%@", resultString);
    
    NSString *requestTmp = [NSString stringWithString:resultString];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    listOfMovies = [ScrollView mj_objectArrayWithKeyValuesArray:resultDic];
    
    //
    //    图片的宽
    CGFloat imageW = self.scrollview.frame.size.width;
    //    CGFloat imageW = 300;
    //    图片高
    CGFloat imageH = self.scrollview.frame.size.height;
    //    图片的Y
    CGFloat imageY = 0;
    //    图片中数
    NSInteger totalCount = listOfMovies.count;
    self.pageControl.numberOfPages=totalCount;
    
    for (int i = 0; i < totalCount; i++) {
        index=i;
        UIImageView *imageView = [[UIImageView alloc] init];
        //        图片X
        CGFloat imageX = i * imageW;
        
        //        设置图片
        //NSString *name = [NSString stringWithFormat:@"0%d.jpg", i + 1];
        //imageView.image = [UIImage imageNamed:name];
        
        ScrollView *m =self.listOfMovies[i];
        //NSLog(@"img%@",m.ScrollImage);
        //加载网络图片
        [imageView sd_setImageWithURL:[NSURL URLWithString:m.ScrollImage]];
        
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
    CGFloat contentW = totalCount *imageW;
    //不允许在垂直方向上进行滚动
    self.scrollview.contentSize = CGSizeMake(contentW, 0);
    // 3.设置分页
    self.scrollview.pagingEnabled = YES;
    
    //4.监听scrollview的滚动
    self.scrollview.delegate = self;
    
    [self addTimer];
    
    
    //    for (ScrollView *user in listOfMovies) {
    //        NSLog(@"img=%@, imgUrl=%@", user.ScrollImage, user.ScrollURL);
    //    }
    //    NSLog(@"%@",@"connection1-end");
}

-(void)doTapAction:(UITapGestureRecognizer*)sender{
    //跳转
    //NSLog(@"6666666666666");
    ScrollView *m =self.listOfMovies[self.pageControl.currentPage];
    //NSLog(@"666666666img=%@, imgUrl=%@", [NSString stringWithFormat:@"%ld", (long)self.pageControl.currentPage], m.ScrollURL);
    //发送请求
    NSURL *url=[NSURL URLWithString:m.ScrollURL];
    //请求
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(!connectionError){
            //把二进制数据转化成NSString
            //NSString *html=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            //
            WebViewController *web=[[WebViewController alloc] init];
            //[web.webview loadRequest:request];
            //[self.webview loadHTMLString:html baseURL:nil];
            [self.navigationController pushViewController:web animated:YES];
            //self.navigationItem.title=@"返回";
            web.request=request;
            
            //NSLog(@"%@",html);
        }else{
            NSLog(@"连接出错%@",connectionError);
        }
    }];
    
    
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
    
    //NSLog(@"%@", @"kaishijiex");    //开始解析XML
    
    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    ipParser.delegate = self;
    [ipParser parse];
    //NSLog(@"%@",@"connectionDidFinishLoading-end");
    
    [self.NewTableView reloadData];
}

//解析xml回调方法
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    info = [[NSMutableDictionary alloc] initWithCapacity: 1];
    
    //NSLog(@"%@",@"parserDidStartDocument-end");
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
    //NSLog(@"%@",@"parser-end");
}

//解析返回xml的节点elementName
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
    //NSLog(@"value2: %@\n", elementName);
    //NSLog(@"%@", @"jiedian1");    //设置标记查看解析到哪个节点
    currentTagName = elementName;
    
    //NSLog(@"%@",@"parser2-end");
}

//取得我们需要的节点的数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    //NSLog(@"%@",@"parser3-begin");
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
}

//循环解析d节点
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    //NSLog(@"%@",@"parserDidEndDocument-begin");
    
    NSMutableString *outstring = [[NSMutableString alloc] initWithCapacity: 1];
    for (id key in info) {
        [outstring appendFormat: @"%@: %@\n", key, [info objectForKey:key]];
    }
    
    //[outstring release];
    //[xmlString release];
}



- (void)setView1
{
    //上面图片下面文字
    NSArray *title = @[@"我的申请",@"待我审批",@"待我回览"];
    NSArray *image = @[@"1",@"2",@"3"];
    DXLAutoButtonView *btn = [[DXLAutoButtonView alloc] initWithFrame:CGRectMake(0, 300, kWidth, 80) autoWidthFlowItems:image autolabelItem:title withPerRowItemsCount:3 widthRatioToView:0.55 heightRatioToView:0.55 imageTopWithView:3 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:3 horizontalEdgeInset:3];
    //DXLAutoButtonView *btn = [[DXLAutoButtonView alloc] initWithFrame:CGRectMake(0, 300, kWidth, 80) autoWidthFlowItems:title autoImageItem:image withPerRowItemsCount:3 widthRatioToView:0.55 heightRatioToView:0.55 imageTopWithView:3 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:3 horizontalEdgeInset:3];
    [btn setLabelClickBlock:^(NSInteger index) {
        switch (index) {
            case 0:
            {
                //[self presentViewController:navigationController animated:YES completion:^{}];

                //[self dismissViewControllerAnimated:YES completion:nil];//返回上一页面
                UITabBarController *tabBarCtrl = [[MyApplyTabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
                break;
            case 1:
            {
//                UITabBarController *tabBarCtrl = [[PendingTabBarViewController alloc]init];
//
//                [self presentViewController:tabBarCtrl animated:YES completion:nil];
                UITabBarController *tabBarCtrl = [[PendingTabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
                break;
            case 2:
            {
                UITabBarController *tabBarCtrl = [[TaskViewTabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
                break;
            case 3:
            {
                NSLog(@"点击第四个按键");
            }
                break;
                
            default:
                break;
        }
    }];
    [self.view addSubview:btn];
}
- (void)setView2
{
    //上面图片下面文字
    NSArray *title = @[@"请假",@"出差",@"外出"];
    NSArray *image = @[@"app05.png",@"app06.png",@"app07.png"];
    DXLAutoButtonView *btn = [[DXLAutoButtonView alloc] initWithFrame:CGRectMake(0, 410, kWidth, 80) autoWidthFlowItems:title autoImageItem:image withPerRowItemsCount:3 widthRatioToView:0.55 heightRatioToView:0.55 imageTopWithView:3 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:3 horizontalEdgeInset:3];
    [btn setBtnClickBlock:^(NSInteger index) {
        switch (index) {
            case 0:
            {
//                NSLog(@"点击第1个按键");
//                UITabBarController *tabBarCtrl = [[LeaveTabBarViewController alloc]init];
//
//                [self presentViewController:tabBarCtrl animated:YES completion:nil];
//
                UITabBarController *tabBarCtrl = [[LeaveTabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
                
//                LeaveViewController * valueView = [[LeaveViewController alloc] initWithNibName:@"LeaveViewController"bundle:[NSBundle mainBundle]];
//                //从底部划入
//                [valueView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//                //跳转
//                [self presentModalViewController:valueView animated:YES];
            }
                break;
            case 1:
            {
                UITabBarController *tabBarCtrl = [[BusinessTripTabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
                break;
            case 2:
            {
                UITabBarController *tabBarCtrl = [[GoOutTabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
                break;
            case 3:
            {
                NSLog(@"点击第四个按键");
            }
                break;
                
            default:
                break;
        }
    }];
    [self.view addSubview:btn];
}
- (void)setView3
{
    //上面图片下面文字
    NSArray *title = @[@"考勤日历",@"代理人设置",@"公告"];
    NSArray *image = @[@"app08.png",@"app09.png",@"app10.png"];
    DXLAutoButtonView *btn = [[DXLAutoButtonView alloc] initWithFrame:CGRectMake(0, 520, kWidth, 80) autoWidthFlowItems:title autoImageItem:image withPerRowItemsCount:3 widthRatioToView:0.55 heightRatioToView:0.55 imageTopWithView:3 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:3 horizontalEdgeInset:3];
    [btn setBtnClickBlock:^(NSInteger index) {
        switch (index) {
            case 0:
            {
                UITabBarController *tabBarCtrl = [[AttendanceTabBarViewController alloc]init];
                [self presentViewController:tabBarCtrl animated:YES completion:nil];
            }
                break;
            case 1:
            {
                NSLog(@"点击第二个按键");
            }
                break;
            case 2:
            {
                NewViewController * VCCollect = [[NewViewController alloc] init];
                [self.navigationController pushViewController:VCCollect animated:YES];
            }
                break;
                
            default:
                break;
        }
    }];
    [self.view addSubview:btn];
}

@end
