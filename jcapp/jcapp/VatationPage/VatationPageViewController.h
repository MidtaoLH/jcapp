//
//  VatationPageViewController.h
//  jcapp
//
//  Created by zhaodan on 2019/11/21.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//创建协议
@protocol VcBDelegate <NSObject>
- (void)sendValue:(NSString *)value; //声明协议方法
@end

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
    
    NSString *userID;
    NSString *iosid;
 
}
@property (nonatomic, weak)id<VcBDelegate> delegate; //声明协议变量

@property(retain,nonatomic) NSArray *data;
@property (copy, nonatomic) NSArray *datas;

@property (nonatomic,copy) NSString *selectindex;

-(IBAction)onClickButtontest:(id)sender;
-(IBAction)onClickButtonreturn:(id)sender;


@end



NS_ASSUME_NONNULL_END
