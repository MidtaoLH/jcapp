//
//  BusinessTripEditViewController.m
//  jcapp
//
//  Created by youkare on 2019/12/12.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "BusinessTripEditViewController.h"

static NSInteger rowHeight=50;
@interface BusinessTripEditViewController ()
@end

@implementation BusinessTripEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    totalcount=1;
    totalHeight=150;
    //tableViewPlace.backgroundColor=UIColor.blueColor;
    tableViewPlace.frame = CGRectMake(0,-40, self.view.frame.size.width, totalHeight);
    tableViewPlace.rowHeight=rowHeight;
    //tableViewPlace.height=totalHeight;
    // table view data is being set here
    myData = [[NSMutableArray alloc]initWithObjects:
              @"Data 1 in array",@"Data 2 in array",@"Data 3 in array",
              @"Data 4 in array",@"Data 5 in array",@"Data 5 in array",
              @"Data 6 in array",@"Data 7 in array",@"Data 8 in array",
              @"Data 9 in array", nil];
//        UITableView * tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    
//        tableview.dataSource=self;
//        [self.view addSubview:tableview];
    // Do any additional setup after loading the view from its nib.
}
-(void)LoadTableLocation
{
    tableViewPlace.height=totalHeight;
    [tableViewPlace reloadData];
}
//如果不设置section 默认就1组
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return totalcount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    cell.textLabel.text=[NSString stringWithFormat:@"*"];
    cell.textLabel.textColor=UIColor.redColor;
    //cell.backgroundColor=UIColor.redColor;
    
    UILabel *cell0=[[UILabel alloc]init];
    cell0.text=[NSString stringWithFormat:@"出差地点"];
    cell0.textColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
    //cell0.left=40;
    cell0.frame = CGRectMake(30,0, 80, rowHeight);
    //cell0.backgroundColor=UIColor.greenColor;
    [cell.contentView addSubview:cell0];
    
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(cell.frame.size.width-50,cell.top, 50.0f, rowHeight);
    
    [btnAdd setTitle:@"➕" forState:UIControlStateNormal];
    
    [btnAdd addTarget:self action:@selector(cellAddBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    //btnAdd.backgroundColor=UIColor.blueColor;
    [cell.contentView addSubview:btnAdd];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(cell.frame.size.width-20,cell.top, 50.0f, rowHeight);

    [btn setTitle:@"✖️" forState:UIControlStateNormal];
    
    //btn.backgroundColor =[UIColor redColor];
    
    [btn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    
    //[btn3 addTarget:self action:@selector(onClick3:) forControlEvents:UIControlEventTouchUpInside];
    
    //btn3.tag=indexPath.row;
    //btn.backgroundColor=UIColor.greenColor;
    [cell.contentView addSubview:btn];
        
    return cell;
}
//-(IBAction)delRows:(id)sender{
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//    [datas removeObjectAtIndex:0];
//    [indexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [self.tableView beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
//}
- (void)cellAddBtnClicked:(id)sender event:(id)event
{
    
    NSSet *touches =[event allTouches];
    
    UITouch *touch =[touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:tableViewPlace];
    
    NSIndexPath *indexPath= [tableViewPlace indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath!= nil) {
        
        // do something
        totalcount++;
        totalHeight=totalHeight+rowHeight;
        [self LoadTableLocation];
        NSLog(@"%zd",indexPath.row);
        
    }
    
}
- (void)cellBtnClicked:(id)sender event:(id)event
{
    
    NSSet *touches =[event allTouches];
    
    UITouch *touch =[touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:tableViewPlace];
    
    NSIndexPath *indexPath= [tableViewPlace indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath!= nil) {
        
        // do something
        totalcount--;
        totalHeight=totalHeight-rowHeight;
        [self LoadTableLocation];
        NSLog(@"%zd",indexPath.row);
    }
    
}

//-(void)onClick3:(UIButton *) sender{

//    NSLog(@"%ld",sender.tag);

//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
    // 获取cell 对象
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:111];
    // 获取昵称
    //_inputView.inputText.text = [NSString stringWithFormat:@"回复 %@ :", name.text];
    // 加上对应的回复昵称
}

- (IBAction)addPlace:(id)sender {
    totalcount++;
    totalHeight=totalHeight+rowHeight;
    tableViewPlace.height=totalHeight;
    [tableViewPlace reloadData];
}


@end
