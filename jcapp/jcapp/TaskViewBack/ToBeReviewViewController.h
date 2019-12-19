//
//  ToBeReviewViewController.h
//  jcapp
//
//  Created by lh on 2019/12/15.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToBeReviewViewController : UIViewController
{
    NSString *xmlString;
    NSMutableDictionary *info;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    NSInteger currentPageCount;
}
@property (weak, nonatomic) IBOutlet UITableView *NewTableView;


// 添加数据源
@property (strong,nonatomic) NSMutableArray *listOfMovies;
@end

NS_ASSUME_NONNULL_END
