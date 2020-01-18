//
//  AlterPWDController.m
//  jcapp
//
//  Created by lh on 2019/11/24.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AlterPWDController.h"
#import "UsersViewController.h"
#import "SWForm.h"
#import "SWFormHandler.h"
#import "Masonry.h"
#import "TabBarViewController.h"
@interface AlterPWDController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) SWFormItem *enterpwd;
@property (nonatomic, strong) SWFormItem *oldpwd;
@property (nonatomic, strong) SWFormItem *newpwd;
@end

@implementation AlterPWDController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight);
        
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,Common_UserTableHeight*2));
    }];
    [self datas];
}
/**
 数据源处理
 */
- (void)datas {
    
    SWWeakSelf
    NSMutableArray *items = [NSMutableArray array];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"username"];
    SWFormItem *dept = SWFormItem_Info(@"用户编号",user, SWFormItemTypeInput);
    dept.keyboardType = UIReturnKeyDefault;
    [items addObject:dept];
    
    self.oldpwd = SWFormItem_Add(@"旧密码", nil, SWFormItemTypeInput, YES, YES, UIKeyboardTypeNumberPad);
    self.oldpwd.maxInputLength = 32;
    self.oldpwd.itemUnitType = SWFormItemUnitTypeCustom;
    [items addObject:_oldpwd];
    
    self.newpwd = SWFormItem_Add(@"新密码", nil, SWFormItemTypeInput, YES, YES, UIKeyboardTypeNumberPad);
    self.newpwd.maxInputLength = 32;
    self.newpwd.itemUnitType = SWFormItemUnitTypeCustom;
    [items addObject:_newpwd];
    
    self.enterpwd = SWFormItem_Add(@"确认密码", nil, SWFormItemTypeInput, YES, YES, UIKeyboardTypeNumberPad);
    self.enterpwd.maxInputLength = 32;
    self.enterpwd.itemUnitType = SWFormItemUnitTypeCustom;
    [items addObject:_enterpwd];
    
    SWFormSectionItem *sectionItem = SWSectionItem(items);
    //    sectionItem.headerHeight = 10;
    //    sectionItem.footerView = [self footerView];
    //    sectionItem.footerHeight = 80;
    [self.mutableItems addObject:sectionItem];
}
- (void)addAction {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"username"];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if(self.oldpwd.info.length==0)
    {
        if (version.doubleValue >= 9.0) {
            // 针对 9.0 以上的iOS系统进行处理
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"旧密码不能为空！" preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        } else {
            // 针对 9.0 以下的iOS系统进行处理
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息！"
                                  message: @"旧密码不能为空！"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(self.newpwd.info.length==0)
    {
        if (version.doubleValue >= 9.0) {
            // 针对 9.0 以上的iOS系统进行处理
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"新密码不能为空！" preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        } else {
            // 针对 9.0 以下的iOS系统进行处理
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息！"
                                  message: @"新密码不能为空！"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(self.enterpwd.info.length==0)
    {
        if (version.doubleValue >= 9.0) {
            // 针对 9.0 以上的iOS系统进行处理
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"确认密码不能为空！" preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        } else {
            // 针对 9.0 以下的iOS系统进行处理
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息！"
                                  message: @"确认密码不能为空！"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(self.newpwd.info!=self.enterpwd.info)
    {
        if (version.doubleValue >= 9.0) {
            // 针对 9.0 以上的iOS系统进行处理
            //初始化提示框；
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"两次新密码不一致！" preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
        } else {
            // 针对 9.0 以下的iOS系统进行处理
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息！"
                                  message: @"两次新密码不一致！"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        //设置需要访问的ws和传入参数
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/UpdatePassWord?id=%@&password=%@&oldPassword=%@",user,self.enterpwd.info,self.oldpwd.info];
        //id,password,oldPassword
        NSURL *url = [NSURL URLWithString:strURL];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
    }
}
-(IBAction)btnreturnClick:(id)sender {
    UITabBarController *tabBarCtrl = [[UsersViewController alloc]init];
    [self presentViewController:tabBarCtrl animated:NO completion:nil];
}

//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    @try {
        
        //upateData = [[NSData alloc] initWithData:data];
        //默认对于中文的支持不好
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *gbkNSString = [[NSString alloc] initWithData:data encoding: enc];
        //如果是非UTF－8  NSXMLParser会报错。
        xmlString = [[NSString alloc] initWithString:[gbkNSString stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"gbk\"?>"
                                                                                            withString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"]];
    }
    @catch (NSException *exception) {
        
    }
    
}

//弹出消息框
-(void) connection:(NSURLConnection *)connection
  didFailWithError: (NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [error localizedDescription]
                               message: [error localizedFailureReason]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
}

//解析返回的xml系统自带方法不需要h中声明
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    ipParser.delegate = self;
    [ipParser parse];
}

//解析xml回调方法
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    info = [[NSMutableDictionary alloc] initWithCapacity: 1];
}

//回调方法出错弹框
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
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
    currentTagName = elementName;
}

//取得我们需要的节点的数据
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *message =@"";
    if ([currentTagName isEqualToString:@"string"]) {
        if ([string isEqualToString:@"1"]) {
            message = [[NSString alloc] initWithFormat:@"%@", @"修改成功！"];
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息"
                                  message: message
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else if ([string isEqualToString:@"2"]) {
            message = [[NSString alloc] initWithFormat:@"%@", @"旧密码无效，请重新输入！"];
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息"
                                  message: message
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else{
            message = [[NSString alloc] initWithFormat:@"%@", @"修改失败！"];
            //显示信息。正式环境时改为跳转
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"提示信息"
                                  message: message
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITabBarController *tabBarCtrl = [[TabBarViewController alloc]init];
    tabBarCtrl.selectedIndex=1;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarCtrl];
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
}
//循环解析d节点
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSMutableString *outstring = [[NSMutableString alloc] initWithCapacity: 1];
    for (id key in info) {
        [outstring appendFormat: @"%@: %@\n", key, [info objectForKey:key]];
    }
}
//解决tableview线不对的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
//解决tableview线不对的问题
- (void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0, self.view.height-50.0, self.view.width, 50.0)];
    [self.view addSubview:toolBar];
    UIImage* itemImage= [UIImage imageNamed:@"save.png"];
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * addBtn =[[UIBarButtonItem  alloc]initWithImage:itemImage style:UIBarButtonItemStylePlain target:self action:@selector(addAction)];
    addBtn.width=self.view.width;
   
    NSArray *toolbarItems = [NSArray arrayWithObjects:addBtn, nil];
    [toolBar setItems:toolbarItems animated:NO];
}
@end
