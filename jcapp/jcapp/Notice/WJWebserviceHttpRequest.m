#import "WJWebserviceHttpRequest.h"

@implementation WJWebserviceHttpRequest

static WJWebserviceHttpRequest * instance = nil;

+ (instancetype)shareHttpRequest
{
    
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        instance = [[WJWebserviceHttpRequest alloc] init];
    });
    return instance;
}

-(void)webserviceHttpRequestWithUrl:(NSString *)path andWithBodyStr:(NSString *)bodyStr andWithMethodNmae:(NSString *)requestMethodName andSuccessBlock:(requestSuccessBlock)success andFailureBlcok:(requestFailureBlock)failure
{
    NSURL * pathUrl = [NSURL URLWithString:path];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:pathUrl];
    request.HTTPMethod = @"POST";
    
    NSString * soapMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body>%@</soap:Body></soap:Envelope>",bodyStr];
    NSData * soapMsgData = [soapMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    // 命名空间
    NSString *nameSpace=@"http://microsoft.com/webservices/";
    // 方法名
    NSString *methodname=requestMethodName;
    
    NSString *msgLength = [NSString stringWithFormat:@"%ld", [soapMsg length]];
    NSString *soapAction=[NSString stringWithFormat:@"%@%@",nameSpace,methodname];
    NSDictionary *headField=[NSDictionary dictionaryWithObjectsAndKeys:[pathUrl host],@"Host",
                             @"text/xml; charset=utf-8",@"Content-Type",
                             msgLength,@"Content-Length",
                             soapAction,@"SOAPAction",nil];
    [request setAllHTTPHeaderFields:headField];
    request.HTTPBody = soapMsgData;
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }
        else{
            success(data);
        }
    }];
    [dataTask resume];
}

@end
