
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,XMGStyleType) {
    XMGStyleTypeYear = 0,//年
    XMGStyleTypeYearAndMonth,//年月
    
};


@protocol MCDatePickerViewDelegate <NSObject>

- (void)didSelectDateResult:(NSString *)resultDate;

@end

@interface MCDatePickerView : UIView

@property (nonatomic ,weak) id<MCDatePickerViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(XMGStyleType)type;

/**
 显示PickerView
 */
- (void)show;

/**
 移除PickerView
 */
- (void)remove;

@end
