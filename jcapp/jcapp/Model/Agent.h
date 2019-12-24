//
//  Agent.h
//  jcapp
//
//  Created by zhaodan on 2019/12/23.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Agent : NSObject

@property (nonatomic,copy) NSString * AgentG_Cname;
@property (nonatomic,copy) NSString * AgentEmpCName;
@property (nonatomic,copy) NSString * AgentDate;
@property (nonatomic,copy) NSString * AgentStartDate;
@property (nonatomic,copy) NSString * AgentEndDate;
@property (nonatomic,copy) NSString * DocumentTypeNM;
@property (nonatomic,copy) NSString * AgentStatusNM;
@property (nonatomic,copy) NSString * ApplyManPhoto;


@end

NS_ASSUME_NONNULL_END
