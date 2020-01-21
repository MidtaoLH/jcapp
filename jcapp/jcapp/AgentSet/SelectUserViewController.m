#import "SelectUserViewController.h"
#import "SkyAssociationMenuView.h"
#import "../Model/Group.h"
#import "../MJExtension/MJExtension.h"
#import "../Model/Emp.h"
#import "AppDelegate.h"
#import "SetAgentViewController.h"
#import "../TabBar/TabBarViewController.h"
#import "Masonry.h"
#import "../ViewController.h"

@interface SelectUserViewController ()<SkyAssociationMenuViewDelegate>
{
    NSArray *titleArr;
    NSArray *datArr;
    UIButton  *btn;
}
@property (strong, nonatomic) SkyAssociationMenuView *tagView;
@end

@implementation SelectUserViewController

@synthesize listOfGroup;
@synthesize listOfEmp;
@synthesize lbempname;
@synthesize lbgroupname;
@synthesize lbempid;
@synthesize lbgroupid;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    iosid = [defaults objectForKey:@"adId"];
    userid = [defaults objectForKey:@"userid"];
    [_tagView showAsFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight)];
    self.view.backgroundColor = [UIColor  whiteColor];
    stringflag = @"group";
    NSString *strPara = [NSString stringWithFormat:@"AppWebService.asmx/GetGroup"];
    
    NSString *strURL = [NSString stringWithFormat:Common_WSUrl,strPara];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    _tagView = [[SkyAssociationMenuView alloc] init];
    _tagView.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gotoback)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.title=@"选择员工";
}
-(void)show{
    btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 200, 100, 20);
    btn.backgroundColor = [UIColor  redColor];
    [btn setTitle:@"弹框选择" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(tan) forControlEvents:UIControlEventTouchUpInside];
}

-(void)gotoback {
    [_tagView dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)save {
    if(lbempid.length > 0)
    {
        [_tagView dismiss];
        AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        myDelegate.way_groupname =lbgroupname;
        myDelegate.way_groupid =lbgroupid;
        myDelegate.way_empid =lbempid;
        myDelegate.way_empname =lbempname;
        myDelegate.agentType = @"true";
        myDelegate.agent_refresh = @"true";
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
        //显示信息。正式环境时改为跳转
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"提示信息"
                              message: @"必须选择一个员工！"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
  
}
-(void)selectFindex:(NSInteger)f Tindex:(NSInteger)t {
    //这个方法 z暂时不管
}
#pragma mark SkyAssociationMenuViewDelegate
- (NSInteger)assciationMenuView:(SkyAssociationMenuView*)asView countForClass:(NSInteger)idx section:(NSInteger)section{
    if (idx == 0) {
        //return titleArr.count;
        if(!listOfEmp.count > 0)
        {
            stringflag = @"emp";
            NSString *urlstring = [NSString stringWithFormat:Common_WSUrl,@"AppWebService.asmx/GetEmpname?groupid=%@&AuditUsedFlag=%@&iosid=%@&userid=%@"];
            NSString *strURL = [NSString stringWithFormat:urlstring,@"123",@"1" ,iosid,userid];
            NSURL *url = [NSURL URLWithString:strURL];
            //进行请求
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
            
            NSURLConnection *connection = [[NSURLConnection alloc]
                                           initWithRequest:request
                                           delegate:self];
        }
        return listOfGroup.count;;
        
    }else if (idx == 1){
        if(listOfGroup.count > 0)
        {
            if(listOfEmp.count > 0)
            {
                Group *n =self.listOfGroup[section];
                NSString *Gcode =n.Code;
                NSMutableArray *imageData = [[NSMutableArray alloc] init];
                for (NSInteger i = 0; i < listOfEmp.count; i++)
                {
                    
                    Emp *m =self.listOfEmp[i];
                    if([m.GCode isEqualToString:Gcode])
                    {
                        [imageData addObject:m.Name];
                    }
                }
                return imageData.count;
            }
        }
    }
    return 10;
}

- (NSString*)assciationMenuView:(SkyAssociationMenuView*)asView titleForClass_1:(NSInteger)idx_1 {
    if(listOfGroup.count > 0)
    {
        Group *m =self.listOfGroup[idx_1];//取出数据元素
        return m.Name;
    }
    else
    {
        return @"123";
    }
}
- (NSString*)assciationMenuView:(SkyAssociationMenuView*)asView titleForClass_1:(NSInteger)idx_1 class_2:(NSInteger)idx_2 {
    
    if(listOfGroup.count > 0)
    {
        if(listOfEmp.count > 0)
        {
            Group *n =self.listOfGroup[idx_1];
            NSString *Gcode =n.Code;
            lbgroupname = n.Name;
            lbgroupid = n.Code;
            NSMutableArray *imageData = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < listOfEmp.count; i++)
            {
                Emp *m =self.listOfEmp[i];
                if([m.GCode isEqualToString:Gcode])
                {
                    [imageData addObject:m.Name];
                }
            }
            return imageData[idx_2];
        }
        return @"false";
    }
    return  @"false";
}
- (BOOL)assciationMenuView:(SkyAssociationMenuView*)asView idxChooseInClass1:(NSInteger)idx_1 class2:(NSInteger)idx_2 {
    if(listOfGroup.count > 0)
    {
        if(listOfEmp.count > 0)
        {
            Group *n =self.listOfGroup[idx_1];
            NSString *Gcode =n.Code;
            NSMutableArray *imageData = [[NSMutableArray alloc] init];
            NSMutableArray *imageData2 = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < listOfEmp.count; i++)
            {
                Emp *m =self.listOfEmp[i];
                if([m.GCode isEqualToString:Gcode])
                {
                    [imageData addObject:m.Name];
                    [imageData2 addObject:m.Code];
                }
            }
            NSString *empname =imageData[idx_2] ;
            NSString *empid =imageData2[idx_2] ;
            lbempname =   empname ;
            lbempid = empid;
            return NO;
        }
        return NO;
    }
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//以下为调用ws相关方法

//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    @try {
        
        xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if([xmlString containsString: Common_MoreDeviceLoginFlag])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"" message: Common_MoreDeviceLoginErrMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            ViewController * valueView = [[ViewController alloc] initWithNibName:@"ViewController"bundle:[NSBundle mainBundle]];
            //跳转
            [self presentModalViewController:valueView animated:YES];
        }
        else
        {
            NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
            NSRange endRagne = [xmlString rangeOfString:@"</string>"];
            NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
            NSString *resultString = [xmlString substringWithRange:reusltRagne];
            NSString *requestTmp = [NSString stringWithString:resultString];
            NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
            NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
            
            if([stringflag isEqualToString:@"group"])
            {
                listOfGroup = [Group mj_objectArrayWithKeyValuesArray:resultDic];
                if(listOfGroup.count > 0)
                {
                    Group *m =self.listOfGroup[0];//取出数据元素
                    [_tagView showAsDrawDownView:_chosebutton];
                }
            }
            else
            {
                listOfEmp = [Emp mj_objectArrayWithKeyValuesArray:resultDic];
                if(listOfEmp.count > 0)
                {
                    Emp *m =self.listOfEmp[0];//取出数据元素
                }
            }
       }
    }
    @catch (NSException *exception) {
        NSArray *arr = [exception callStackSymbols];
        NSString *reason = [exception reason];
        NSString *name = [exception name];
        NSLog(@"err:\n%@\n%@\n%@",arr,reason,name);
    }
    
}
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    ipParser.delegate = self;
    [ipParser parse];
}
//弹出消息框
-(void) connection:(NSURLConnection *)connection
  didFailWithError: (NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: @""
                               message: Common_NetErrMsg
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    
}
//解析xml回调方法
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    //NSLog(@"%@", @"test4");
    info = [[NSMutableDictionary alloc] initWithCapacity: 1];
}
//回调方法出错弹框
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //NSLog(@"%@", @"test5");
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [parseError localizedDescription]
                               message: [parseError localizedFailureReason]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
}

//解析返回xml的节点elementName
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
    
}

//取得我们需要的节点的数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
}
@end
