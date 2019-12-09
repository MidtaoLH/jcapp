
#import <UIKit/UIKit.h>

@interface WHUCalendarCell : UICollectionViewCell
@property(nonatomic,strong) UILabel* lbl;
@property(nonatomic,strong) UILabel* dbl;
@property(nonatomic,assign) BOOL isToday;
@property(nonatomic,assign) BOOL isDayInCurMonth;
@property(nonatomic,assign) NSInteger rowIndex;
@property(nonatomic,assign) NSInteger total;
@end
