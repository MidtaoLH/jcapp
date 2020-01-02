
#import <Foundation/Foundation.h>

@interface BRResultModel : NSObject
/** ID */
@property (nonatomic, copy) NSString *ID;
/** 名称 */
@property (nonatomic, copy) NSString *name;

/** 选择值对应的索引（行数） */
@property (nonatomic, assign) NSInteger index;
/** 选择的值 */
@property (nonatomic, copy) NSString *selectValue;

@end
