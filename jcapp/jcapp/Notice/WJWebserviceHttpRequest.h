#import <Foundation/Foundation.h>

/// 请求成功回调block
typedef void(^requestSuccessBlock)(id responseObject);
/// 请求失败回调block
typedef void(^requestFailureBlock)(NSError * error);

@interface WJWebserviceHttpRequest : NSObject

+(instancetype)shareHttpRequest;

-(void)httpRequestWithUrl:(NSString *)path andWithBodyStr:(NSString *)bodyStr andWithMethodNmae:(NSString *)requestMethodName andSuccessBlock:(requestSuccessBlock)success andFailureBlcok:(requestFailureBlock)failure;

@end
