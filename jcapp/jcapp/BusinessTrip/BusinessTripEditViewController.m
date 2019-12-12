//
//  BusinessTripEditViewController.m
//  jcapp
//
//  Created by youkare on 2019/12/11.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "BusinessTripEditViewController.h"
#import "BusinessTripCell.h"
#import "../Model/Pending.h"
#import "../MJExtension/MJExtension.h"

static NSString *const ID = @"cell";
@interface BusinessTripEditViewController ()<UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation BusinessTripEditViewController
NSInteger currentPageCountwait4;
- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.dataSource = self;
    // cell注册
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    // 请求数据
    // ......
    [self getDataFromWeb];
}

/**
 
 *  请求网络数据
 
 */

- (void)getDataFromWeb {
    
    NSString *currentPageCountstr = [NSString stringWithFormat: @"%ld", (long)currentPageCountwait4];
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetPendingInfo?pasgeIndex=%@&pageSize=%@&code=%@&userID=%@&menuID=%@",@"1",currentPageCountstr,userID,empID,@"2"];
    
    NSString *url = [NSString stringWithFormat:Common_WSUrl,strPara];
    //NSURL *url = [NSURL URLWithString:strURL];
    
    //NSString *url = @"http:192.168.31.167:8000";
    // 创建session
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:
                             [NSURLSessionConfiguration defaultSessionConfiguration]];
    
    // 创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // 为了防止block中产生循环引用
    __weak typeof (self)weakSelf = self;
    
    // 创建请求任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                          NSURLResponse *response, NSError *error) {
        // 请求完成处理
        if (error) {
            NSLog(@"Error :%@", error.localizedDescription);
        } else {
            self->xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            // 将Json数据解析成OC对象
            NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
            NSRange endRagne = [xmlString rangeOfString:@"</string>"];
            NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
            NSString *resultString = [xmlString substringWithRange:reusltRagne];
            
            NSString *requestTmp = [NSString stringWithString:resultString];
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            _dataSource= [Pending mj_objectArrayWithKeyValuesArray:resultDic];
            // 在主线程中刷新数据
            [weakSelf performSelectorOnMainThread:@selector(refreshDataSource:)withObject:_dataSource waitUntilDone:YES];
            //[super viewDidLoad];
        }
        
    }];
    
    // 启动请求
    [task resume];
}
/**
 
 *  刷新数据源
 
 */

- (void)refreshDataSource:(NSMutableArray *)data {
    
    [self.dataSource addObjectsFromArray:data];
    
    [self.tableView  reloadData];
    
}
#pragma mark -  代理方法<UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    // 先从缓存中找，如果没有再创建
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    Pending *p = self.dataSource[indexPath.row];
    cell.textLabel.text = p.CaseName;
    
    
    
    return cell;
    
}
@end
