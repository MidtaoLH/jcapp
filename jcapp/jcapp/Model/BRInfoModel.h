

#import <Foundation/Foundation.h>

@interface BRInfoModel : NSObject
/** 编号 */
@property (nonatomic, copy) NSString *codeStr;
/** 姓名 */
@property (nonatomic, copy) NSString *nameStr;
/** 部门 */
@property (nonatomic, copy) NSString *deptStr;
/** 开始时间 */
@property (nonatomic, copy) NSString *startdayStr;
/** 结束时间 */
@property (nonatomic, copy) NSString *enddayStr;

/** 结束时间 */
@property (nonatomic, copy) NSString *agentID;
@end
