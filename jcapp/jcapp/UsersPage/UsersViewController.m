//
//  UsersViewController.m
//  jcapp
//
//  Created by lh on 2019/11/20.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "UsersViewController.h"

@interface UsersViewController
()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblname;
@property (weak, nonatomic) IBOutlet UILabel *lblcode;
@property (weak, nonatomic) IBOutlet UILabel *lbldept;
@property (weak, nonatomic) IBOutlet UIImageView *myHeadPortrait;
@property (weak, nonatomic) IBOutlet UILabel *lblimagename;
@property (weak, nonatomic) IBOutlet UITableView *userslist;
@end

@implementation UsersViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.edgesForExtendedLayout=0;
    self.view.backgroundColor=[UIColor colorWithRed:(242.0/255.0) green:(242.0/255.0) blue:(242.0/255.0) alpha:(1)];
    _userslist.delegate=self;
    _userslist.dataSource=self;
    _userslist.bounces = NO;
    //初始化一个UIImageView的对象
    self.myHeadPortrait.userInteractionEnabled = YES;//打开用户交互
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseImage:)];
    [self.myHeadPortrait addGestureRecognizer:tap];
   
    CGFloat headimageX = self.view.frame.size.width * 0.12;
    CGFloat headimageY = self.view.frame.size.height * 0.105;
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
    return 44.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(indexPath.row==0)
        {
            cell.textLabel.text=[NSString stringWithFormat:@"修改账户密码"];
            cell.textLabel.textColor=[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1];
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
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
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
        }
        UIGraphicsEndImageContext();
        //上传图片,以文件形式,还是base64在这调用就ok
    }];
}
@end

