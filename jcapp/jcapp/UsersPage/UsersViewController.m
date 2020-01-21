//
//  UsersViewController.m
//  jcapp
//
//  Created by lh on 2019/11/20.
//  Copyright © 2019 midtao. All rights reserved.
//
#import "ViewController.h"
#import "UsersViewController.h"
#import "AlterPWDController.h" 
#import "UserInfo.h"
#import "MJExtension.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "../SDWebImage/UIImageView+WebCache.h"
@interface UsersViewController
()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end
NSString *unloadflag = @"";
@implementation UsersViewController
- (void)viewDidLoad {    
    [super viewDidLoad];
    //self.edgesForExtendedLayout=0;
    //self.view.backgroundColor=[UIColor colorWithRed:(242.0/255.0) green:(242.0/255.0) blue:(242.0/255.0) alpha:(1)];
    //初始化一个UIImageView的对象
    self.myHeadPortrait.userInteractionEnabled = YES;//打开用户交互
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseImage:)];
    [self.myHeadPortrait addGestureRecognizer:tap];
    //这句必须写
    self.myHeadPortrait.layer.masksToBounds = YES;
    self.myHeadPortrait.layer.cornerRadius = Common_UserImageSize * 0.5;
    self.userslist.delegate=self;
    self.userslist.dataSource=self;
    self.userslist.bounces = NO;
    [self loadinfo];
    self.userslist.scrollEnabled  = NO;
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
    if ([_userslist respondsToSelector:@selector(setSeparatorInset:)]) {
        [_userslist setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_userslist respondsToSelector:@selector(setLayoutMargins:)]) {
        [_userslist setLayoutMargins:UIEdgeInsetsZero];
    }
}

//清除缓存按钮的点击事件
- (void)clearRAM{
    NSString *message =@"删除缓存";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSTemporaryDirectory()];
        //缓存
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        UITableViewCell *cell=[self.userslist cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = @"0.00K";
        cell.detailTextLabel.textColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self showDetailViewController:alert sender:nil];
}
// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}
//userstable
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //列表高度
    return Common_UserTableHeight/3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        AlterPWDController * VCCollect = [[AlterPWDController alloc] init];
        [self.navigationController pushViewController:VCCollect animated:YES];
    }
    else if(indexPath.row==1)
    {
        
    }
    else if(indexPath.row==2)
    {
        [self clearRAM];
    }
}
//点击事件
 -(void)choseImage:(UITapGestureRecognizer*)sender{
    //显示弹出框列表选择
    UIAlertController *alert = [[UIAlertController alloc]init];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
    handler:^(UIAlertAction * action) {
           NSLog(@"action = %@", action);
    }];
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDestructive
    handler:^(UIAlertAction * action) {
    //响应事件
    NSLog(@"action = %@", action);
    [self getAvatatFormPhotoLibrary:self];//调用相册
    }];
     UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault
     handler:^(UIAlertAction * action) {
    //响应事件
     NSLog(@"action = %@", action);
     [self getAvatatFormCamera:self];//调用相机
     }];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self getAvatatFormCamera:self];//调用相机
    }
    if (buttonIndex ==2) {
        [self getAvatatFormPhotoLibrary:self];//调用相册
    }
}
-(IBAction)btnreturnClick:(id)sender {
    
    //gengxin denglu zhuangtai
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"username"];
    NSString *adId = [defaults objectForKey:@"adId"];
    unloadflag = @"UnloadUser";
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/UnloadUser?User=%@&macid=%@", user,adId];
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];
    
    
   
}
- (void)getAvatatFormPhotoLibrary:(UIViewController *)controller
{
    //这里可以判断类型是相册还是相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        //加上下面这句会有编辑框
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (void)getAvatatFormCamera:(UIViewController *)controller
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.showsCameraControls = YES;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma - mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //这里可以选择image类型,
    //原图:UIImagePickerControllerOriginalImage
    //获取编辑框里的图:UIImagePickerControllerEditedImage
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        CGSize newSize = CGSizeMake(300.0f, 300.0f);
        UIGraphicsBeginImageContext(newSize);
        UIImage *imagechuansong = image;
        [imagechuansong drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *imagename=[NSString stringWithFormat:@"%d.png",self.lblname.text];
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imagename];
        BOOL result =[UIImagePNGRepresentation(newImage) writeToFile:filePath atomically:YES];
        if (result == YES) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            
            NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                                  [NSString stringWithFormat:imagename]];
            // 保存文件的名称
            UIImage *img = [UIImage imageWithContentsOfFile:filePath];
            // 保存文件的名称
            [self.myHeadPortrait setImage:img];
            [self updateImage:img];
            

           // UIImageView *imageView = [[UIImageView alloc] init];
            //NSString *userurlString =[NSString stringWithFormat:Common_UserPhotoUrl,username];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString] placeholderImage:nil options:SDWebImageRefreshCached];
            //[[SDImageCache sharedImageCache] clearDisk];
           // [[SDImageCache sharedImageCache] clearMemory];
           // [imageView sd_setImageWithURL:[NSURL URLWithString:userurlString] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
             //   AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
           //     myDelegate.userPhotoimageView=imageView;
          //  }];
            
        }
        UIGraphicsEndImageContext();
        //上传图片,以文件形式,还是base64在这调用就ok
    }];
}
/**
 *  请求返回数据
 */

-(void)updateImage:(UIImage *)image{
   
    //字典里面装的是你要上传的内容
    NSDictionary *parameters = @{};
    
    //上传的接口
    NSString* urlstring = @"http://47.94.85.101:8095/UploadHandler.ashx";
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlstring]
                                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                        timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //    //要上传的图片
    //    UIImage *image=[params objectForKey:@"pic"];
    //得到图片的data
    NSData *data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [parameters allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"pic"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
        }
    }
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    NSString *imagename = [self CharacterStringMainString:username AddDigit:30 AddString:@" "];
    NSString *name = [self CharacterStringMainString:@"pic" AddDigit:20 AddString:@" "];
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.png\"\r\n",name,imagename];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", (int)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    //建立连接，设置代理
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //设置接受response的data
    if (conn) {
        _mResponseData = [[NSMutableData alloc] init];
    }
}
- (NSString*)CharacterStringMainString:(NSString*)MainString AddDigit:(int)AddDigit AddString:(NSString*)AddString
{
    NSString*ret = [[NSString alloc]init];
    
    ret = MainString;
    for(int y =0;y < (AddDigit - MainString.length) ;y++ ){
        ret = [NSString stringWithFormat:@"%@%@",ret,AddString];
    }
    return ret;
}
#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    @try {
        
        infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if([infoString containsString:@"成功"])
        {
            
        }
        else if([infoString containsString:@"OK"])
        {
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            myDelegate.userPhotoimageView=self.myHeadPortrait;
        }
        else if([infoString containsString:@"NO"])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @""
                                  message: @"头像上传失败，请重新上传！"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if([unloadflag isEqualToString: @"UnloadUser"])
            {
                unloadflag = @"";
                
                
                NSRange startRange = [infoString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
                NSRange endRagne = [infoString rangeOfString:@"</string>"];
                NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
                NSString *resultString = [infoString substringWithRange:reusltRagne];
                
                
                NSLog(@"%@", resultString);
                if([resultString isEqualToString:@"1"])
                {
                    //tuichu denglu chenggong
                    ViewController * valueView = [[ViewController alloc] initWithNibName:@"ViewController"bundle:[NSBundle mainBundle]];
                    [[SDImageCache sharedImageCache] clearDisk];
                    [[SDImageCache sharedImageCache] clearMemory];
                    //跳转
                    [self presentModalViewController:valueView animated:YES];
                }
            }
            else
            {
                // 字符串截取
                NSRange startRange = [infoString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">["];
                NSRange endRagne = [infoString rangeOfString:@"]</string>"];
                NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
                NSString *resultString = [infoString substringWithRange:reusltRagne];
                
                NSLog(@"%@", resultString);
                
                NSString *requestTmp = [NSString stringWithString:resultString];
                NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSMutableDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                UserInfo *userinfo = [UserInfo mj_objectWithKeyValues:resultDic];
                self.lblname.text=userinfo.name;
                self.lblcode.text=userinfo.code;
                self.lbldept.text=userinfo.dept;
                
                AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [self.myHeadPortrait setImage: myDelegate.userPhotoimageView.image];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
}
-(void)loadinfo{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    userID = [defaults objectForKey:@"userid"];
    empID = [defaults objectForKey:@"EmpID"];
    empname = [defaults objectForKey:@"empname"];
    groupname = [defaults objectForKey:@"GroupName"];
    code= [defaults objectForKey:@"UserNO"];
    username= [defaults objectForKey:@"username"];
    isNotice= [defaults objectForKey:@"IsNotice"];
    self.lblcode.text=code;
    self.lblname.text=empname;
    self.lbldept.text=groupname;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    [self.myHeadPortrait setImage: myDelegate.userPhotoimageView.image];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        
        if(indexPath.row==0)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.textLabel.text=[NSString stringWithFormat:@"修改账户密码"];
            cell.textLabel.textColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row==1)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch * mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
            [mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            if ([isNotice isEqual:@"1"]) {
                 [mySwitch setOn:YES];
            }
            else {
                 [mySwitch setOn:NO];
            }
           
            cell.accessoryView = mySwitch;
            cell.textLabel.text=[NSString stringWithFormat:@"消息推送通知"];
            cell.textLabel.textColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
        }
        else if(indexPath.row==2)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            //缓存
            CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
            NSString *message = size > 1 ? [NSString stringWithFormat:@"%.2fM", size] : [NSString stringWithFormat:@"%.2fK", size * 1024.0];
            NSString *messagenew =[NSString stringWithFormat:@"清除缓存"];
            cell.textLabel.text = messagenew;
            cell.textLabel.textColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
            cell.detailTextLabel.text = message;
            cell.detailTextLabel.textColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (isButtonOn) {        
        [defaults setObject:@"1" forKey:@"IsNotice"];
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/SetIsNotice?id=%@&isNotice=%@",username,@"1"];
        NSURL *url = [NSURL URLWithString:strURL];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
    }else {
        [defaults setObject:@"0" forKey:@"IsNotice"];
        NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/SetIsNotice?id=%@&isNotice=%@",username,@"0"];
        NSURL *url = [NSURL URLWithString:strURL];
        //进行请求
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
    }
    
}


@end


