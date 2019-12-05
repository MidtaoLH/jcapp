//
//  CalendaViewController.m
//  jcapp
//
//  Created by zhaodan on 2019/11/27.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "CalendaViewController.h"

@interface CalendaViewController ()

@end

@implementation CalendaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 300)];
    
    // 设置日期选择控件的地区
    
    [picker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    //    [myDatePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_SC"]];
    
    //默认为当天。
    
    [picker setCalendar:[NSCalendar currentCalendar]];
    
    //    设置DatePicker的时区。
    
    //    默认为设置为：[datePicker setTimeZone:[NSTimeZone defaultTimeZone]];
    
    //    设置DatePicker的日期。
    
    //    默认设置为:
    
    [picker setDate:[NSDate date]];
    
    //    minimumDate设置DatePicker的允许的最小日期。
    
    //    maximumDate设置DatePicker的允许的最大日期
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setDay:10];//设置最大时间为：当前时间推后10天
    
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [comps setDay:0];//设置最小时间为：当前时间
    
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [picker setMaximumDate:maxDate];
    
    [picker setMinimumDate:minDate];
    
    
    
    
    
    
    
 
    
    
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
-(IBAction)datechanged:(id)sender {
    
  
      NSLog(@"%@", @"test");
}

-(IBAction)onClickButton:(id)sender {
  
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    
    
    
    NSString *dateStr = [formatter  stringFromDate:picker.date];
     NSLog(@"%@",dateStr);
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *type = [defaults objectForKey:@"type"];
    
    
    if ([type isEqualToString:@"tableviewstart"]){
      
        [defaults setObject:dateStr forKey:@"timestart"];
        
    }
    else if([type isEqualToString:@"tableviewend"])
    {
       
         [defaults setObject:dateStr forKey:@"timeend"];
        
    }

    
    [defaults synchronize];//保存到磁盘
    


    [self dismissViewControllerAnimated:YES completion:nil];//返回上一页面
    


}

@end
