//
//  HomePageViewController.h
//  jcapp
//
//  Created by youkare on 2019/11/20.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageViewController : UIViewController{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    
    NSString *BLCount;
    NSString *DCLCount;
    NSString *HLCount;
}

@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
// 添加数据源
@property (strong,nonatomic) NSMutableArray *listOfMovies;
@end

NS_ASSUME_NONNULL_END
