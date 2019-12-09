//
//  MyDateTimeView.h
//  DateTimePickerViewDemo
//
//  Created by hniisoft on 2018/9/11.
//  Copyright © 2018年 TZF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MyDatePickerViewMode) {
    
    MyDatePickerViewDateYearMonthDayHourMinuteSecondMode = 0,//年月日,时分秒
    MyDatePickerViewDateYearMonthDayHourMinuteMode,//年月日,时分
    MyDatePickerViewDateYearMonthDayHourMode,//年月日,时
    MyDatePickerViewDateYearMonthDayMode,//年月日
    MyDatePickerViewDateYearMonthMode,//年月
    MyDatePickerViewDateYearMode,//年
    
};

@interface MyDateTimeView : UIView

/**选择模式*/
@property (nonatomic, assign) MyDatePickerViewMode pickerViewMode;

@end
