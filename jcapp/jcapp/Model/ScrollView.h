//
//  ScrollView.h
//  jcapp
//
//  Created by youkare on 2019/11/26.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollView : NSObject
/** 图片地址 */
@property (copy, nonatomic) NSString *ScrollImage;

/** 对应网址 */
@property (copy, nonatomic) NSString *ScrollURL;
@end

NS_ASSUME_NONNULL_END
