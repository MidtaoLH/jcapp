//
//  NoticeViewController.m
//  jcapp
//
//  Created by zclmac on 2019/11/21.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "NoticeViewController.h"

@interface NoticeViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *NoticeTableView;

@end

@implementation NoticeViewController

@synthesize listOfMovies;

- (void)viewDidLoad {
    
    listOfMovies = [[NSMutableArray alloc] init];
    
    [listOfMovies addObject:@"I Love Tony"];
    [listOfMovies addObject:@"美丽心灵"];
    [listOfMovies addObject:@"雨人"];
    [listOfMovies addObject:@"波拉克"];
    [listOfMovies addObject:@"暗物质"];
    [listOfMovies addObject:@"天才瑞普利"];
    [listOfMovies addObject:@"猫鼠游戏"];
    [listOfMovies addObject:@"香水"];
    [listOfMovies addObject:@"一级恐惧"];
    [listOfMovies addObject:@"心灵捕手"];
    [listOfMovies addObject:@"莫扎特传"];
    [listOfMovies addObject:@"证据"];
    [listOfMovies addObject:@"海上钢琴师"];
    [listOfMovies addObject:@"电锯惊魂"];
    [listOfMovies addObject:@"沉默的羔羊"];
    [listOfMovies addObject:@"非常嫌疑犯"];
    [listOfMovies addObject:@"寻找弗罗斯特"];
 
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
