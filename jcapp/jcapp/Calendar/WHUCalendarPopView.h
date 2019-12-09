

#import <UIKit/UIKit.h>

@interface WHUCalendarPopView : UIWindow
@property(nonatomic,strong) void(^onDateSelectBlk)(NSDate*);
-(void)dismiss;
-(void)show;
@end
