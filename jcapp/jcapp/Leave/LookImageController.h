//
//  LookImageController.h
//  jcapp
//
//  Created by zclmac on 2019/12/11.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LookImageController : UIViewController

    @property (weak, nonatomic) IBOutlet UIScrollView *imagescrolview;

    @property(nonatomic,strong) NSDictionary* multiParamDic;

@end

NS_ASSUME_NONNULL_END
