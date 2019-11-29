#import "ViewController.h"
#import "WJWebserviceHttpRequest.h"
#import "Masonry.h"
#import "MJExtension.h"

@interface ViewController ()

@property (nonatomic, weak) UIButton *mButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    
    UIButton *mButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mButton setTitle:@"NB你就点我呀" forState:UIControlStateNormal];
    [mButton setTitle:@"算你NB" forState:UIControlStateHighlighted];
    [mButton setBackgroundColor:[UIColor redColor]];
    [mButton addTarget:self action:@selector(mButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mButton];
    self.mButton = mButton;
    
    [self.mButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200, 50));
        
    }];
}

/**
 *  获取webservice数据
 *
 *  @param btn 参数
 */
- (void)mButtonClick:(UIButton *)btn
{
    [self setUpCustOrder];           // 订单查询
}

/**
 *  订单查询
 */
- (void)setUpCustOrder
{
    
    // 请求请求对象
    HJHttpRequest *hjRequest = [HJHttpRequest shareHttpRequest];
    // 设置请求路径
    NSString *serverUrl = @"http://***.***.***.***/testsdk/SDKService.asmx";
    // 设置请求体（这里获取参数是我写死的）
    NSString *bodyStr = @"<cus_order xmlns=\"http://microsoft.com/webservices/\"><cus_no>13</cus_no><order_date>2016-11-22</order_date></cus_order>";
    // 设置方法名
    NSString *methodName = @"cus_order";
    
    
    // 开始请求
    [hjRequest httpRequestWithUrl:serverUrl andWithBodyStr:bodyStr andWithMethodNmae:methodName andSuccessBlock:^(id responseObject) {
        NSLog(@"请求成功");
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //        NSLog(@"看看里面的JSON\n%@",jsonString);
        
        // 字符串截取
        NSRange startRange = [jsonString rangeOfString:@"<cus_orderResult>"];
        NSRange endRagne = [jsonString rangeOfString:@"</cus_orderResult>"];
        NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
        NSString *resultString = [jsonString substringWithRange:reusltRagne];
        //        NSLog(@"看看截取的内容\n%@",resultString);
        
        // 翻译一下，字符串转NSData
        NSString *requestTmp = [NSString stringWithString:resultString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        NSMutableArray *dingdanArray = [DingDanBen mj_objectArrayWithKeyValuesArray:resultDic];
        for (DingDanBen *dingdan in dingdanArray) {
            NSLog(@"name = %@",dingdan.prd_name);
            NSLog(@"no = %@",dingdan.prd_no);
            NSLog(@"yh = %@",dingdan.qty_yh);
            NSLog(@"sh = %@",dingdan.qty_sh);
            NSLog(@"sal_name = %@",dingdan.sal_name);
            NSLog(@"sh_name = %@",dingdan.sh_name);
            NSLog(@"ut = %@",dingdan.ut);
        }
        
    } andFailureBlcok:^(NSError *error) {
        NSLog(@"请求失败%@",error);
    }];
}

@end
