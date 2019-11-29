//
//  VatationPageViewController.h
//  jcapp
//
//  Created by zhaodan on 2019/11/21.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VatationPageViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate>{
    
    IBOutlet UITableView *tableview;
    NSArray *data;//数组的每一个元素对应tableView相应的一格
    int *count;
    NSIndexPath *_selIndex;
    NSString *xmlString;
    NSString *currentTagName;
    NSString *currentValue;
    NSString *resultString;
    NSString *allString;
    NSMutableDictionary *info;
    NSMutableArray *vatcationArray;
    NSMutableArray *listOfMovies;
    
}

@property(retain,nonatomic) NSArray *data;
@property (copy, nonatomic) NSArray *datas;

-(IBAction)onClickButtontest:(id)sender;
-(IBAction)onClickButtonreturn:(id)sender;


@end



NS_ASSUME_NONNULL_END
