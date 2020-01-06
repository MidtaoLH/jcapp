//
//  LeaveDetailCell.m
//  jcapp
//
//  Created by zclmac on 2019/12/3.
//  Copyright © 2019 midtao. All rights reserved.
//

#import "LeaveDetailCell.h"
#import "MultiParamButton.h"
#import "MJExtension.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#define kMargin 10

@interface LeaveDetailCell()

@property (nonatomic, strong) UILabel *lblleaveDate;
@property (nonatomic, strong) UILabel *lblempname;
@property (nonatomic, strong) UILabel *lblgroupname;
@property (nonatomic, strong) UILabel *lbllevelname;
@property (nonatomic, strong) UILabel *lblremark;

@property (nonatomic, strong) MultiParamButton *btnemail;

// (nonatomic, strong)   (nonatomic,weak)
@end

@implementation LeaveDetailCell

- (MultiParamButton *)btnemail {
    
    if (!_btnemail) {
        _btnemail = [[MultiParamButton alloc] init];
       [_btnemail setTitle:@"提醒他" forState:UIControlStateNormal];
        _btnemail.backgroundColor = [UIColor orangeColor];
        // 一行代码给按钮添加事件
       [_btnemail addTarget:self action:@selector(action:)   forControlEvents:UIControlEventTouchUpInside];
 
    }
    return _btnemail;
}
-(void)action:(id)sender{
    MultiParamButton* multiParamButton = (MultiParamButton* )sender;
    
    NSLog(@"Vvvverify : %@", multiParamButton.multiParamDic);
 
    NSString * obj1 = [multiParamButton.multiParamDic objectForKey:@"taskid"];
 
    NSString *strURL = [NSString stringWithFormat:@"http://47.94.85.101:8095/AppWebService.asmx/AdmitUrge?userID=%@&taskID=%@", @"1",obj1 ];
    NSLog(@"%@", strURL);
    NSURL *url = [NSURL URLWithString:strURL];
    //进行请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request
                                   delegate:self];

}
//系统自带方法调用ws后进入将gbk转为utf-8如果确认是utf-8可以不转，因为ios只认utf-8 一
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%@    ",@"connection1-begin");
    //upateData = [[NSData alloc] initWithData:data];
    //默认对于中文的支持不好
    //   NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //   NSString *gbkNSString = [[NSString alloc] initWithData:data encoding: enc];
    //如果是非UTF－8  NSXMLParser会报错。
    //   xmlString = [[NSString alloc] initWithString:[gbkNSString stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"gbk\"?>"
    //                                                                                       withString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"]];
    
    xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", @"kaishidayin");
    NSLog(@"%@", xmlString);
    
    // 字符串截取
    NSRange startRange = [xmlString rangeOfString:@"<string xmlns=\"http://tempuri.org/\">"];
    NSRange endRagne = [xmlString rangeOfString:@"</string>"];
    NSRange reusltRagne = NSMakeRange(startRange.location + startRange.length, endRagne.location - startRange.location - startRange.length);
    NSString *resultString = [xmlString substringWithRange:reusltRagne];
    
    NSLog(@"%@", resultString);
 
    NSLog(@"%@",@"connection1-end");
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
    NSLog(@"%@",@"connection2-end");
}

//解析返回的xml系统自带方法不需要h中声明 二s
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    
    NSLog(@"%@", @"kaishijiex");    //开始解析XML
    
    NSXMLParser *ipParser = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    ipParser.delegate = self;
    [ipParser parse];
    NSLog(@"%@",@"connectionDidFinishLoading-end");
 
}

//解析xml回调方法 六
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    info = [[NSMutableDictionary alloc] initWithCapacity: 1];
    
    NSLog(@"%@",@"parserDidStartDocument-end");
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
    NSLog(@"%@",@"parser-end");
}

//解析返回xml的节点elementName 三
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
    NSLog(@"value2: %@\n", elementName);
    //NSLog(@"%@", @"jiedian1");    //设置标记查看解析到哪个节点
    currentTagName = elementName;
    
    NSLog(@"%@",@"parser2-end");
}

//取得我们需要的节点的数据 四
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSLog(@"%@",@"parser3-begin");
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
}

//循环解析d节点 五
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    NSLog(@"%@",@"parserDidEndDocument-begin");
    
    NSMutableString *outstring = [[NSMutableString alloc] initWithCapacity: 1];
    for (id key in info) {
        [outstring appendFormat: @"%@: %@\n", key, [info objectForKey:key]];
    }
    
    //[outstring release];
    //[xmlString release];
}



- (UILabel *)lblleaveDate {
    
    if (!_lblleaveDate) {
        _lblleaveDate = [[UILabel alloc] init];
        _lblleaveDate.font = [UIFont systemFontOfSize:15];
        _lblleaveDate.textColor = [UIColor grayColor];
    }
    return _lblleaveDate;
}

- (UILabel *)lblgroupname {
    
    if (!_lblgroupname) {
        _lblgroupname = [[UILabel alloc] init];
        _lblgroupname.font = [UIFont systemFontOfSize:15];
        _lblgroupname.textColor = [UIColor grayColor];
    }
    return _lblgroupname;
}
- (UILabel *)lbllevelname {
    
    if (!_lbllevelname) {
        _lbllevelname = [[UILabel alloc] init];
        _lbllevelname.font = [UIFont systemFontOfSize:15];
        _lbllevelname.textColor = [UIColor grayColor];
    }
    return _lbllevelname;
}

- (UILabel *)lblremark {
    
    if (!_lblremark) {
        _lblremark = [[UILabel alloc] init];
        _lblremark.font = [UIFont systemFontOfSize:15];
        _lblremark.textColor = [UIColor grayColor];
        _lblremark.height = 1;
        
        //设置换行
        _lblremark.lineBreakMode = UILineBreakModeWordWrap;
        _lblremark.numberOfLines = 0;
    }
    return _lblremark;
}
- (UILabel *)lblempname {
    
    if (!_lblempname) {
        _lblempname = [[UILabel alloc] init];
        _lblempname.font = [UIFont systemFontOfSize:15];
        _lblempname.textColor = [UIColor grayColor];
    }
    return _lblempname;
}


//自定义cell 需要重写的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.lblremark];
        [self.contentView  addSubview:self.lblempname];
        [self.contentView  addSubview:self.lblleaveDate];
        [self.contentView  addSubview:self.lblgroupname];
        [self.contentView  addSubview:self.lbllevelname];
        [self.contentView  addSubview:self.btnemail];
    }
    return self;
}


-(void)setLeavedetail:(LeaveDeatil *)leavedetail
{
    _leavedetail =leavedetail;
    
    self.textLabel.text = _leavedetail.name;
    
    self.lbllevelname.text = _leavedetail.levelname;
 
    self.lblgroupname.text = _leavedetail.groupname;
    
    self.imageView.image =[UIImage imageNamed:@"01.jpg"];

    self.lblremark.text =  _leavedetail.Remark;
 
 
        /*
         NSString * strremark = [[NSString alloc]initWithFormat:@"%@\n%@",[_leavedetail.Remark  substringToIndex:5],[_leavedetail.Remark substringFromIndex:_leavedetail.Remark.length- 5]];
         
         self.lblremark.text =  strremark;
         
         CGSize size = [self sizeThatFits:CGSizeMake(self.lblremark.frame.size.height, MAXFLOAT)];
         CGRect frame = self.lblremark.frame;
         frame.size.height = size.height;
         [self.lblremark setFrame:frame];
         
         */

  
    
     self.lblleaveDate.text = _leavedetail.TaskDate;
    
    self.btnemail.hidden = YES;
    if([_leavedetail.TaskNodeOperateType isEqualToString: @"2"])
    {
        if([_leavedetail.TaskAuditeStatus isEqualToString: @"1"] || [_leavedetail.TaskAuditeStatus isEqualToString: @"2"] )
        {
            if([_leavedetail.ProcessStutas isEqualToString: @"2"] || [_leavedetail.ProcessStutas isEqualToString: @"3"]  || [_leavedetail.ProcessStutas isEqualToString: @"4"] )
            {
                self.btnemail.hidden = NO;
                NSDictionary* paramDic = @{@"taskid":_leavedetail.TaskInstanceID};
                self.btnemail.multiParamDic= paramDic;
 
            }
        }
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat imageWH= width/6;
    
    CGFloat leaveDateWidth = 80;
    
    //每行的文本的高度
    CGFloat txtH =  (height - 3*kMargin)/4;
    
    //先设置图片大小和位置
    self.imageView.frame = CGRectMake(kMargin,(height -kMargin-imageWH)/2, imageWH, imageWH );
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = imageWH * 0.5;
    
    //设置日期未知
    self.lblleaveDate.frame = CGRectMake(width-leaveDateWidth-kMargin,kMargin, leaveDateWidth, txtH);
    
    //设置名称
    self.textLabel.frame =CGRectMake(2 * kMargin + imageWH, kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    
    //s设置部门
    self.lblgroupname.frame = CGRectMake(2*kMargin+imageWH, txtH+2*kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    
    //级别名称和 员工名
    self.lbllevelname.frame = CGRectMake(2*kMargin+imageWH + 80,  kMargin, width - leaveDateWidth - kMargin - imageWH, txtH);
    
    self.lblremark.frame = CGRectMake(2*kMargin+imageWH  + 80 ,  txtH+kMargin, width - leaveDateWidth - kMargin - imageWH, 3*txtH);
    
    self.btnemail.frame = CGRectMake(width-leaveDateWidth-kMargin,4*kMargin, leaveDateWidth, txtH);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
