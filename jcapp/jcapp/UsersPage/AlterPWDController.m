//
//  AlterPWDController.m
//  jcapp
//
//  Created by lh on 2019/11/24.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "AlterPWDController.h"
#import "UsersViewController.h"
#import "../Model/pwdInfo.h"
#import "PwdInfoCell.h"
#import "Masonry.h"
@interface AlterPWDController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@end

@implementation AlterPWDController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initUI];
    [self loadstyle];
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)loadData {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"username"];
    self.infoModel.userid = user;
    self.infoModel.oldpwd = @"";
    self.infoModel.newpwd = @"";
    self.infoModel.enterpwd = @"";
}

- (void)initUI {
    self.tableView.hidden = NO;
}
- (void)loadstyle {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarAndNavigationBarHeight);
        
        make.left.mas_equalTo(0);
        // 添加大小约束
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,Common_UserTableHeight*2));
    }];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
 
}
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"用户编号", @"* 旧密码", @"* 新密码", @"* 确认密码",@"修改"];
        return _titleArr;
    }
    return _titleArr;
}
- (pwdInfo *)infoModel {
    if (!_infoModel) {
        _infoModel = [[pwdInfo alloc]init];
    }
    return _infoModel;
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"pwdCell";
    PwdInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[PwdInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *arr= self.titleArr[indexPath.row];
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:arr];
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    cell.isNext = NO;
    switch (indexPath.row) {
        case 0:
        {
            
            cell.titleLabel.text = arr;
            cell.textField.placeholder = @"用户名";
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.text = self.infoModel.userid;
        }
            break;
        case 1:
        {
            [strAtt addAttribute:NSForegroundColorAttributeName value:kColor_Red range:NSMakeRange(0, 1)];
            cell.titleLabel.attributedText = strAtt;
            cell.textField.placeholder = @"请输入旧密码";
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.text = self.infoModel.oldpwd;
            cell.textField.secureTextEntry = YES;
        }
            break;
        case 2:
        {
            [strAtt addAttribute:NSForegroundColorAttributeName value:kColor_Red range:NSMakeRange(0, 1)];
            cell.titleLabel.attributedText = strAtt;
            cell.textField.placeholder = @"请输入新密码";
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.text = self.infoModel.newpwd;
            cell.textField.secureTextEntry = YES;
        }
            break;
        case 3:
        {
            [strAtt addAttribute:NSForegroundColorAttributeName value:kColor_Red range:NSMakeRange(0, 1)];
            cell.titleLabel.attributedText = strAtt;
            cell.textField.placeholder = @"请确认密码";
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.text = self.infoModel.enterpwd;
            cell.textField.secureTextEntry = YES;
        }
        case 4:
        {
            cell.btnUpdate.titleLabel.text=@"修改";
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}


#pragma mark - 处理点击事件
- (void)handlerTextFieldSelect:(UITextField *)textField {
    switch (textField.tag) {
       
        default:
            break;
    }
}
#pragma mark - UITextFieldDelegate 返回键
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1|| textField.tag == 2|| textField.tag == 3) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 1|| textField.tag == 2|| textField.tag == 3) {
        [textField addTarget:self action:@selector(handlerTextFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
        return YES; // 当前 textField 可以编辑
    }
    else {
        [self.view endEditing:YES];
        [self handlerTextFieldSelect:textField];
        return NO; // 当前 textField 不可编辑，可以响应点击事件
    }
}
#pragma mark - 处理编辑事件
- (void)handlerTextFieldEndEdit:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
        {
            self.infoModel.oldpwd = textField.text;
        }
            break;
        case 2:
        {
            self.infoModel.newpwd = textField.text;
        }
            break;
        case 3:
        {
            self.infoModel.enterpwd = textField.text;
        }
        case 4:
        {
            [self btnupdateClick];
        }
            break;
        default:
            break;
    }
}

-(void)btnupdateClick{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"username"];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if(self.infoModel.oldpwd.length==0)
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
    else if(self.infoModel.newpwd.length==0)
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
    else if(self.infoModel.enterpwd.length==0)
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
    else if(self.infoModel.newpwd!=self.infoModel.enterpwd)
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
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/UpdatePassWord?id=%@&password=%@&oldPassword=%@",user,self.infoModel.enterpwd,self.infoModel.oldpwd];
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
    //upateData = [[NSData alloc] initWithData:data];
    //默认对于中文的支持不好
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *gbkNSString = [[NSString alloc] initWithData:data encoding: enc];
    //如果是非UTF－8  NSXMLParser会报错。
    xmlString = [[NSString alloc] initWithString:[gbkNSString stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"gbk\"?>"
                                                                                        withString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"]];
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
            [self loadData];
            [self loadstyle];
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
        }
        else if ([string isEqualToString:@"2"]) {
            message = [[NSString alloc] initWithFormat:@"%@", @"旧密码无效，请重新输入！"];
        }
        else{
            message = [[NSString alloc] initWithFormat:@"%@", @"修改失败！"];
        }
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
@end
