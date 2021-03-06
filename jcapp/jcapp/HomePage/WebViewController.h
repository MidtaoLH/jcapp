//
//  WebViewController.h
//  jcapp
//
//  Created by youkare on 2019/11/26.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (retain) NSURLRequest *request;
@end

NS_ASSUME_NONNULL_END
