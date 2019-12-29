//
//  HomePageViewController.m
//  jcapp
//
//  Created by youkare on 2019/11/20.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "HomePageViewController.h"
#import "../MJExtension/MJExtension.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#import "../Model/ScrollView.h"
#import "../TabBar/TabBarViewController.h"
#import "AppDelegate.h"
#import "DXLAutoButtonView.h"
#import "WebViewController.h"

@interface HomePageViewController ()
{
    int *index;
}
- (IBAction)test:(id)sender;
@end

@implementation HomePageViewController
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
    self.scrollview.contentOffset = CGPointMake(x, StatusBarAndNavigationBarHeight);
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
    //发送请求
    NSURL *url=[NSURL URLWithString:@"http://www.baidu.com"];
    //请求
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(!connectionError){
            WebViewController *web=[[WebViewController alloc] init];
            [self.navigationController pushViewController:web animated:YES];
            web.request=request;
        }else{
            NSLog(@"连接出错%@",connectionError);
        }
    }];
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
    listOfMovies = [ScrollView mj_objectArrayWithKeyValuesArray:resultDic];
    //    图片中数
    NSInteger totalCount = listOfMovies.count;
    self.pageControl.numberOfPages=totalCount;
    for (int i = 0; i < totalCount; i++) {
        index=i;
        UIImageView *imageView = [[UIImageView alloc] init];
        //        图片X
        CGFloat imageX = i * kScreenWidth;
        
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
        imageView.frame = CGRectMake(imageX, StatusBarAndNavigationBarHeight, kScreenWidth, Common_ScrollSize);
        [self.scrollview addSubview:imageView];
    }
    
    // 2.设置scrollview的滚动范围-----
    CGFloat contentW = totalCount *kScreenWidth;
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
    
    ScrollView *m =self.listOfMovies[self.pageControl.currentPage];
  
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
- (void)setView1
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    //上面图片下面文字
    NSArray *title = @[@"我的申请",@"待我审批",@"待我回览"];
    NSArray *image = @[@"1",@"2",@"3"];
    DXLAutoButtonView *btn = [[DXLAutoButtonView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight+Common_ScrollSize, kScreenWidth, Common_HomeCellSize) autoWidthFlowItems:image autolabelItem:title withPerRowItemsCount:3 widthRatioToView:0.55 heightRatioToView:0.55 imageTopWithView:3 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:3 horizontalEdgeInset:3];
    [btn setLabelClickBlock:^(NSInteger index) {
        switch (index) {
            case 0:
            {
                myDelegate.tabbarType=@"2";
                UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
                break;
            case 1:
            {
                myDelegate.tabbarType=@"3";
                UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
                break;
            case 2:
            {
                myDelegate.tabbarType=@"4";
                UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
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
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    //上面图片下面文字
    NSArray *title = @[@"请假",@"出差",@"外出"];
    NSArray *image = @[@"app05.png",@"app06.png",@"app07.png"];
    DXLAutoButtonView *btn = [[DXLAutoButtonView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight+Common_ScrollSize+Common_HomeCellSize+Common_HomeRowSize, kScreenWidth, Common_HomeCellSize) autoWidthFlowItems:title autoImageItem:image withPerRowItemsCount:3 widthRatioToView:0.55 heightRatioToView:0.55 imageTopWithView:3 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:3 horizontalEdgeInset:3];
    [btn setBtnClickBlock:^(NSInteger index) {
        switch (index) {
            case 0:
            {
                myDelegate.tabbarType=@"5";
                UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
                break;
            case 1:
            {
                
                myDelegate.tabbarType=@"6";
                UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];               
            }
                break;
            case 2:
            {
                myDelegate.tabbarType=@"7";
                UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
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
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    //上面图片下面文字
    NSArray *title = @[@"考勤日历",@"代理人设置",@"公告"];
    NSArray *image = @[@"app08.png",@"app09.png",@"app10.png"];
    DXLAutoButtonView *btn = [[DXLAutoButtonView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight+Common_ScrollSize+Common_HomeCellSize*2+Common_HomeRowSize*2, kScreenWidth, Common_HomeCellSize) autoWidthFlowItems:title autoImageItem:image withPerRowItemsCount:3 widthRatioToView:0.55 heightRatioToView:0.55 imageTopWithView:3 verticalMargin:0 horizontalMargin:0 verticalEdgeInset:3 horizontalEdgeInset:3];
    [btn setBtnClickBlock:^(NSInteger index) {
        switch (index) {
            case 0:
            {
                myDelegate.tabbarType=@"8";
                UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
                break;
            case 1:
            {
                myDelegate.tabbarType=@"9";
                UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
                break;
            case 2:
            {
                myDelegate.tabbarType=@"10";
                UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
                [self presentViewController:navigationController animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }];
    [self.view addSubview:btn];
}
@end
