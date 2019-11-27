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
#import "ZDYTTabBarViewController.h"
#import "userinfo.h"
@interface UsersViewController
()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblname;
@property (weak, nonatomic) IBOutlet UILabel *lblcode;
@property (weak, nonatomic) IBOutlet UILabel *lbldept;
@property (weak, nonatomic) IBOutlet UILabel *lblimagename;
@property (weak, nonatomic) IBOutlet UITableView *userslist;
@property (weak, nonatomic) IBOutlet UIImageView *myHeadPortrait;
@property (weak, nonatomic) IBOutlet UIButton *btnloginout;
@property (nonatomic, strong) NSMutableData *mResponseData;
@end
NSString *infoString;
NSMutableDictionary *userinfo;
NSString *infocurrentTagName;
NSString *infocurrentValue;
NSString *inforesultString;
NSString *allString;
@implementation UsersViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.edgesForExtendedLayout=0;
    self.view.backgroundColor=[UIColor colorWithRed:(242.0/255.0) green:(242.0/255.0) blue:(242.0/255.0) alpha:(1)];
    //初始化一个UIImageView的对象
    self.myHeadPortrait.userInteractionEnabled = YES;//打开用户交互
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseImage:)];
    [self.myHeadPortrait addGestureRecognizer:tap];
   
    CGFloat headimageX = self.view.frame.size.width * 0.08;
    CGFloat headimageY = self.view.frame.size.height * 0.06;
    CGFloat headimageW = self.view.frame.size.width * 0.25;
    CGFloat headimageH = headimageW;
    self.myHeadPortrait.frame = CGRectMake(headimageX, headimageY, headimageW, headimageH);
    //这句必须写
    self.myHeadPortrait.layer.masksToBounds = YES;
    self.myHeadPortrait.layer.cornerRadius = headimageW * 0.5;
    self.myHeadPortrait.image = [UIImage imageNamed:@"1"];
    self.myHeadPortrait.backgroundColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
    
    self.lblimagename.frame = CGRectMake(headimageX, headimageY, headimageW, headimageH);
    self.lblimagename.text=@"用户名";
    
    self.userslist.delegate=self;
    self.userslist.dataSource=self;
    self.userslist.bounces = NO;
    headimageX = 0;
    headimageY = self.view.frame.size.height*0.25;
    headimageW = self.view.frame.size.width;
    headimageH = 132;
    self.userslist.frame = CGRectMake(headimageX, headimageY, headimageW, headimageH);
    self.btnloginout.frame=CGRectMake(0,  self.view.frame.size.height*0.5, self.view.frame.size.width, 44);
    
    headimageX = self.view.frame.size.width * 0.5;
    headimageY = self.view.frame.size.height * 0.025;
    headimageW = self.view.frame.size.width * 0.25;
    headimageH =  headimageW;
    self.lblname.frame=CGRectMake(headimageX, headimageY, headimageW, headimageH);
    headimageY = self.view.frame.size.height * 0.07;
    self.lblcode.frame=CGRectMake(headimageX, headimageY, headimageW, headimageH);
    headimageY = self.view.frame.size.height * 0.10;
    self.lbldept.frame=CGRectMake(headimageX, headimageY, headimageW, headimageH);
    
   
    [self loadinfo];
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
    return 132/3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
       
        if(indexPath.row==0)
        {
            cell.textLabel.text=[NSString stringWithFormat:@"修改账户密码"];
            cell.textLabel.textColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row==1)
        {
            cell.textLabel.text=[NSString stringWithFormat:@"消息推送通知"];
            cell.textLabel.textColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
        }
        else if(indexPath.row==2)
        {
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
    UIAlertView * Alert=[[UIAlertView alloc]initWithTitle:@"请选择获取方式" message:@""
                                                 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:
                         @"打开照相机",@"从手机相册获取", nil];
    Alert.delegate=self;
    [Alert show ];
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
    ViewController * valueView = [[ViewController alloc] initWithNibName:@"ViewController"bundle:[NSBundle mainBundle]];
    
    //跳转
    [self presentModalViewController:valueView animated:YES];
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
            self.lblimagename.hidden=YES;
            [self updateImage:img];
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
    [body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@.png\"\r\n",self.lblcode.text];
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

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    infoString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", infoString);
    if(infoString.length>0)
    {
        [GroupRoomModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"roomGroup":@"roomgroup",
                     };
        }];
        
        
        NSString *urlString =[NSString stringWithFormat:@"http://47.94.85.101:8095/APP/Image/%@.png",self.lblcode.text];
        NSData *imgdata = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
        UIImage *image = [UIImage imageWithData:imgdata]; // 取得图片
        // 本地沙盒目录
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // 得到本地沙盒中名为"MyImage"的路径，"MyImage"是保存的图片名
        NSString *imageFilePath = [path stringByAppendingPathComponent:self.lblcode.text];
        // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
        BOOL success = [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath  atomically:YES];
        if (success){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            
            NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                                  [NSString stringWithFormat:self.lblcode.text]];
            // 保存文件的名称
            UIImage *img = [UIImage imageWithContentsOfFile:filePath];
            // 保存文件的名称
            [self.myHeadPortrait setImage:img];
            self.lblimagename.hidden=YES;
            [self updateImage:img];
        }
    }
}
-(void)loadinfo{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"username"];
    //设置需要访问的ws和传入参数
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/GetUserInfo?id=%@",user];
    //id,password,oldPassword
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self];
}
@end

