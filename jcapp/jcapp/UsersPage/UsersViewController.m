//
//  UsersViewController.m
//  jcapp
//
//  Created by lh on 2019/11/20.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "UsersViewController.h"

@interface UsersViewController
()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lblname;
@property (weak, nonatomic) IBOutlet UILabel *lblcode;
@property (weak, nonatomic) IBOutlet UILabel *lbldept;
@property (weak, nonatomic) IBOutlet UIImageView *myHeadPortrait;
@property (weak, nonatomic) IBOutlet UITableView *userslist;
@end

@implementation UsersViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.edgesForExtendedLayout=0;
    self.view.backgroundColor=[UIColor colorWithRed:(242.0/255.0) green:(242.0/255.0) blue:(242.0/255.0) alpha:(1)];
    //头像
    
    self.myHeadPortrait = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    _myHeadPortrait.backgroundColor = [UIColor magentaColor];
    
    [self.view addSubview:self.myHeadPortrait];
    [self setHeadPortrait];
    
    //_userslist=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _userslist.delegate=self;
    _userslist.dataSource=self;
    _userslist.bounces = NO;
   
    /*UITableView * userslist=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    userslist.delegate=self;
    userslist.dataSource=self;
    userslist.bounces=NO;
    [self.view addSubview:userslist];
    
    /*UIImageView * userimage = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, 50.f, 160.f, 160.f) ];// 数据为float类型
    userimage.layer.masksToBounds = YES;
    // 层.角半径
    // 如果要坐一个APP那样圆角的正方形 只要调节这个数据就可以  角半径设为小于半径比较多的数据
    userimage.layer.cornerRadius = 80;// 层.角半径
    userimage.layer.borderWidth = 1;
    userimage.layer.borderColor = [UIColor whiteColor].CGColor;
    userimage.backgroundColor = [UIColor grayColor]; // 在没有设置图片的时候观察位置
    userimage.image = [UIImage imageNamed:@"yxlm"];
    userimage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:userimage];*/
   
}
//  方法：设置头像样式
-(void)setHeadPortrait{
    //  把头像设置成圆形
    self.myHeadPortrait.layer.cornerRadius=self.myHeadPortrait.frame.size.width/2;
    self.myHeadPortrait.layer.masksToBounds=YES;
    //  给头像加一个圆形边框
    self.myHeadPortrait.layer.borderWidth = 1.5f;
    self.myHeadPortrait.layer.borderColor = [UIColor blackColor].CGColor;
    /**
     *  添加手势：也就是当用户点击头像了之后，对这个操作进行反应
     */
    //允许用户交互
     self.myHeadPortrait.layer.backgroundColor = [UIColor grayColor].CGColor; // 在没有设置图片的时候观察位置
    _myHeadPortrait.userInteractionEnabled = YES;
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
    action:@selector(alterHeadPortrait:)];
    //给imageView添加手势
    [_myHeadPortrait addGestureRecognizer:singleTap];
}

//  方法：alterHeadPortrait
-(void)alterHeadPortrait:(UITapGestureRecognizer *)gesture{
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _myHeadPortrait.image = newPhoto;
    [self dismissViewControllerAnimated:YES completion:nil];
}


//清除缓存按钮的点击事件
- (void)clearRAM{
    CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
    
    NSString *message = size > 1 ? [NSString stringWithFormat:@"缓存%.0fM, 删除缓存", size] : [NSString stringWithFormat:@"缓存%.0fK, 删除缓存", size * 1024.0];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSTemporaryDirectory()];
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
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
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
        NSString *messagenew =[NSString stringWithFormat:@"清除缓存%@",message];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:messagenew];
        NSRange range1 = [[str string] rangeOfString:@"清除缓存"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1] range:range1];
        NSRange range2 = [[str string] rangeOfString:message];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:((float)30/255.0f) green:((float)144/255.0f) blue:((float)255/255.0f) alpha:1] range:range2 ];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.alignment = NSTextAlignmentRight;
        [str addAttribute:NSParagraphStyleAttributeName value:style range:range2];
        cell.textLabel.attributedText = str;
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
@end

