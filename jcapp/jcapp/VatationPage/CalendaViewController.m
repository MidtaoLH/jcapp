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
    

     UIDatePicker *oneDatePicker = [[UIDatePicker alloc] init];
    
        oneDatePicker.frame = CGRectMake(0, 112, 375, 216); // 设置显示的位置和大小
    
        
    
        oneDatePicker.date = [NSDate date]; // 设置初始时间
    
        // [oneDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:48 * 20 * 18] animated:YES]; // 设置时间，有动画效果
    
        oneDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"]; // 设置时区，中国在东八区
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *minDate = [fmt dateFromString:@"1930-01-01"];
    NSDate *maxDate = [fmt dateFromString:@"2099-01-01"];
    

    
        oneDatePicker.minimumDate = minDate; // 设置最小时间
    
        oneDatePicker.maximumDate = maxDate; // 设置最大时间
    
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    oneDatePicker.locale = locale;

        
    
        oneDatePicker.datePickerMode = UIDatePickerModeDate; // 设置样式
    
        // 以下为全部样式
    
        // typedef NS_ENUM(NSInteger, UIDatePickerMode) {
    
        //    UIDatePickerModeTime,           // 只显示时间
    
        //    UIDatePickerModeDate,           // 只显示日期
    
        //    UIDatePickerModeDateAndTime,    // 显示日期和时间
    
        //    UIDatePickerModeCountDownTimer  // 只显示小时和分钟 倒计时定时器
    
      [oneDatePicker addTarget:self action:@selector(oneDatePickerValueChanged:)forControlEvents:UIControlEventValueChanged]; // 添加监听器
    
     
    
        [self.view addSubview:oneDatePicker]; // 添加到View上
    


    
    
    // Do any additional setup after loading the view from its nib.
}


- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    dateStr = [formatter  stringFromDate:sender.date];
    NSLog(@"%@",dateStr);
        

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)onClickButton:(id)sender {
  
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    
 
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
