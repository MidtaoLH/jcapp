//
//  LookImageController.m
//  jcapp
//
//  Created by zclmac on 2019/12/11.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "LookImageController.h"

#define imageHeight 300

@interface LookImageController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl * pageControll;

@end

@implementation LookImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, imageHeight)];
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * 6, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    for (int i = 0; i < 3; i ++) {
        
        NSString * imageName = [NSString stringWithFormat:@"0%d.jpg",i+1];
        
        UIImage * image = [UIImage imageNamed:imageName];
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        
        imageView.frame = CGRectMake(scrollView.bounds.size.width * i, 0, scrollView.bounds.size.width, imageHeight);
        
        [scrollView addSubview:imageView];
    }
    
    [self.view addSubview:scrollView];
    self.imagescrolview = scrollView;
    
    //实例化UIPageControl
    UIPageControl * pageControll = [[UIPageControl alloc] init];
    //    pageControll.backgroundColor = [UIColor grayColor];
    //设置点数
    pageControll.numberOfPages = 6;
    //设置当前点数
    pageControll.currentPage = 0;
    //如果是单页，隐藏
    pageControll.hidesForSinglePage = YES;
    //计算UIPageControl的大小
    CGSize size = [pageControll sizeForNumberOfPages:6];
    //设置默认点的颜色
    pageControll.pageIndicatorTintColor = [UIColor greenColor];
    //设置当前点的颜色
    pageControll.currentPageIndicatorTintColor = [UIColor redColor];
    pageControll.bounds = (CGRect){CGPointZero,size};
    pageControll.center = CGPointMake(scrollView.bounds.size.width/2, imageHeight - size.height/2);
    [self.view addSubview:pageControll];
    [pageControll addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    self.pageControll = pageControll;
}

- (void)pageAction:(UIPageControl *)pageControl {
    
    //    NSLog(@"%ld",pageControl.currentPage);
    
    NSInteger idx = pageControl.currentPage;
    
    [self.imagescrolview setContentOffset:CGPointMake(idx * self.imagescrolview.bounds.size.width, 0) animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    //    NSLog(@"%lf",scrollView.contentOffset.x);
    
    //    NSLog(@"%ld",(NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width));
    
    NSInteger pageIndex = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width);
    self.pageControll.currentPage = pageIndex;
}

@end
