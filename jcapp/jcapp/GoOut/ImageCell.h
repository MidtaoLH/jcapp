//
//  ImageCell.h
//  jcapp
//
//  Created by zclmac on 2019/12/18.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCell : UITableViewCell
   @property (nonatomic, copy) NSString *str;
   @property (strong,nonatomic) NSMutableArray *listAnnex;
@end

NS_ASSUME_NONNULL_END
