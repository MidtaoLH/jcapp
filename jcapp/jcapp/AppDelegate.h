//
//  AppDelegate.h
//  jcapp
//
//  Created by lh on 2019/11/15.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/** 设置全局变量的属性. */
//用户头像
@property (nonatomic, strong) UIImageView *userPhotoimageView;


//出差编号
@property (nonatomic, strong) NSString *businessTripid;
//出差画面 1:新增 2:修改
@property (nonatomic, strong) NSString *pageType;
@property (nonatomic, strong) NSString *leaveid;
@property (nonatomic, strong) NSString *agentid;
@property (nonatomic, strong) NSString *processid;

@property (nonatomic, strong) NSString *Vatcation_refresh;

@property (nonatomic, strong) NSString *way_groupid;

@property (nonatomic, strong) NSString *way_groupname;

@property (nonatomic, strong) NSString *way_empid;

@property (nonatomic, strong) NSString *way_empname;

@property (nonatomic, strong) NSString *way_empenglishname;

@property (nonatomic, strong) NSString *way_refresh;

@property (nonatomic, strong) NSString *way_post_level;

@property (nonatomic, strong) NSString *way_post_index;

@property (nonatomic, strong) NSString *way_post_delete;

@property (nonatomic, strong) NSString *way_post_index_delete;

@property (nonatomic, strong) NSString *AppRoveType;

@property (nonatomic, strong) NSString *TimeStart;

@property (nonatomic, strong) NSString *TimeEnd;

@property (nonatomic, strong) NSString *agentType;

@property (nonatomic, strong) NSString *tabbarType;
@property (nonatomic, strong) NSString  *tabbarIndex;
@property (strong,nonatomic) NSMutableArray *aclistOfMovies;
@end

