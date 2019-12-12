//
//  ViewController.m
//  弹框二级选择
//
//  Created by 小菊花 on 17/1/11.
//  Copyright © 2017年 com.qiji.www. All rights reserved.
//

#import "AddWayView.h"
#import "SkyAssociationMenuView.h"
#import "../Model/Group.h"
#import "../MJExtension/MJExtension.h"
#import "../Model/Emp.h"
#import "AppDelegate.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 414
#define kScale kScreenWidth/375.0f

#define kkScale kScreenWidth/414.0f

#define khScale kScreenHeight/667.0f

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) // 获取屏幕宽度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) // 获取屏幕高度


@interface AddWayView ()<SkyAssociationMenuViewDelegate>
{
    
    NSArray *titleArr;
    NSArray *datArr;
    
    UIButton  *btn;
    
}

@property (strong, nonatomic) SkyAssociationMenuView *tagView;
@end

@implementation AddWayView

@synthesize listOfGroup;
@synthesize listOfEmp;
@synthesize lbempname;
@synthesize lbgroupname;
@synthesize lbempid;
@synthesize lbgroupid;


- (void)viewDidLoad {
    
    lbempid.hidden = YES;
    lbgroupid.hidden = YES;
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor  whiteColor];
    
    stringflag = @"group";
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetGroup"];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
    
    _tagView = [[SkyAssociationMenuView alloc] init];
    _tagView.delegate = self;
    
    
    
    
}


-(void)show{

    btn = [UIButton  buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(100, 200, 100, 20);
    
    
    btn.backgroundColor = [UIColor  redColor];
    
    [btn setTitle:@"弹框选择" forState:UIControlStateNormal];
    
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(tan) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)tan{
    
    
    [_tagView showAsFrame:CGRectMake(24, 84, 335, 569)];
    
    
}

-(IBAction)onClickButtonchose:(id)sender {
    
  
     [_tagView showAsDrawDownView:sender];
}

-(IBAction)onClickButtonsave:(id)sender {
    
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.way_groupname =lbgroupname.text;
    myDelegate.way_groupid =lbgroupid.text;
    
    myDelegate.way_empid =lbempid.text;
    myDelegate.way_empname =lbempname.text;
    
    
     [self dismissViewControllerAnimated:YES completion:nil];//返回上一页面
    
}


-(void)selectFindex:(NSInteger)f Tindex:(NSInteger)t {
    
    //这个方法 z暂时不管
    //NSString *string = datArr[f][t];
    //[btn  setTitle:string forState:UIControlStateNormal];
}

#pragma mark SkyAssociationMenuViewDelegate
- (NSInteger)assciationMenuView:(SkyAssociationMenuView*)asView countForClass:(NSInteger)idx section:(NSInteger)section{
    
    if (idx == 0) {
        //return titleArr.count;
        
        if(!listOfEmp.count > 0)
        {
            stringflag = @"emp";
            NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetEmpname?groupid=%@",@"123"];
            NSURL *url = [NSURL URLWithString:strURL];
            //进行请求
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
            
            NSURLConnection *connection = [[NSURLConnection alloc]
                                           initWithRequest:request
                                           delegate:self];
        }
        NSLog(@"bumengeshu %ld", listOfGroup.count);
        return listOfGroup.count;;
        
    }else if (idx == 1){
        if(listOfGroup.count > 0)
        {
            if(listOfEmp.count > 0)
            {
                NSLog(@"%@", @"给数组赋值");
                Group *n =self.listOfGroup[section];
                NSString *Gcode =n.Code;
                NSMutableArray *imageData = [[NSMutableArray alloc] init];
                
                NSLog(@"%@", Gcode);
                
                for (NSInteger i = 0; i < listOfEmp.count; i++)
                {
                    
                    Emp *m =self.listOfEmp[i];
                    if([m.GCode isEqualToString:Gcode])
                    {
                        [imageData addObject:m.Name];
                    }
                }
                //NSLog(@"%@",imageData);
                NSLog(@"yuangonggeshu %ld", imageData.count);
                return imageData.count;
            }
        
        }
    }
    return 10;
}

- (NSString*)assciationMenuView:(SkyAssociationMenuView*)asView titleForClass_1:(NSInteger)idx_1 {
    //NSLog(@"title %ld", idx_1);
    //return titleArr[idx_1];
    
    if(listOfGroup.count > 0)
    {
        Group *m =self.listOfGroup[idx_1];//取出数据元素
        NSLog(@"%@", m.Name);
        return m.Name;
    }
    else
    {
        NSLog(@"%@", @"123");
        return @"123";
    }
    
    
}

- (NSString*)assciationMenuView:(SkyAssociationMenuView*)asView titleForClass_1:(NSInteger)idx_1 class_2:(NSInteger)idx_2 {

    if(listOfGroup.count > 0)
    {
        if(listOfEmp.count > 0)
        {
            NSLog(@"%@", @"给数组赋值");
            Group *n =self.listOfGroup[idx_1];
            NSString *Gcode =n.Code;
            
            lbgroupname.text = n.Name;
            lbgroupid.text = n.Code;
            
            NSMutableArray *imageData = [[NSMutableArray alloc] init];
            NSLog(@"%@", Gcode);
            for (NSInteger i = 0; i < listOfEmp.count; i++)
            {
                Emp *m =self.listOfEmp[i];
                if([m.GCode isEqualToString:Gcode])
                {
                    [imageData addObject:m.Name];
                }
            }
            NSLog(@"%@",imageData);
            return imageData[idx_2];
        }
        return @"false";
    }
    return  @"false";
    //return datArr[idx_1][idx_2];
}
- (BOOL)assciationMenuView:(SkyAssociationMenuView*)asView idxChooseInClass1:(NSInteger)idx_1 class2:(NSInteger)idx_2 {
   
    NSLog(@"%@", @"xuanz");
    
    if(listOfGroup.count > 0)
    {
        if(listOfEmp.count > 0)
        {
            NSLog(@"%@", @"给数组赋值");
            Group *n =self.listOfGroup[idx_1];
            NSString *Gcode =n.Code;
            
            
            
            NSMutableArray *imageData = [[NSMutableArray alloc] init];
            NSMutableArray *imageData2 = [[NSMutableArray alloc] init];
            
            NSLog(@"%@", Gcode);
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
            lbempname.text =   empname ;
            lbempid.text = empid;
            return NO;
        }
       return NO;
    }
    
    //lbgroupname.text =n.Name;
    
    //AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    //myDelegate.leaveid =m.LeaveID;
    //myDelegate.processid =m.ProcessID;
    
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//以下为调用ws相关方法

//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    
    NSLog(@"%@",@"connection1-begin");
    
    
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", data);
    
    NSLog(@"%@", xmlString);
    
    
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
    NSRange endRagne = [xmlString rangeOfString:@"</string>"];
    NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
    NSString *resultString = [xmlString substringWithRange:reusltRagne];
    
    NSLog(@"%@", resultString);
    
    NSString *requestTmp = [NSString stringWithString:resultString];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    
    if([stringflag isEqualToString:@"group"])
    {
        listOfGroup = [Group mj_objectArrayWithKeyValuesArray:resultDic];
        
        if(listOfGroup.count > 0)
        {
            
            Group *m =self.listOfGroup[0];//取出数据元素
            
            
            NSLog(@"%@", m.Name);
            
        }
        
    }
    else
    {
        listOfEmp = [Emp mj_objectArrayWithKeyValuesArray:resultDic];
        
        if(listOfEmp.count > 0)
        {
            
            Emp *m =self.listOfEmp[0];//取出数据元素
            
            
            NSLog(@"%@", m.Name);
            
        }
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
    
    NSLog(@"%@", @"test2");
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [error localizedDescription]
                               message: [error localizedFailureReason]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    //[errorAlert release];
    
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
    //[errorAlert release];
}

//解析返回xml的节点elementName
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
    //NSLog(@"%@", @"test6");
    //NSLog(@"value: %@\n", elementName);
    //NSLog(@"value: %@\n", qualifiedName);
    //NSLog(@"%@", @"jiedian1");    //设置标记查看解析到哪个节点
    
}

//取得我们需要的节点的数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    
    
    //此处解析出来全部为单个的字段
    NSLog(@"%@", @"test7");
    
}




@end
