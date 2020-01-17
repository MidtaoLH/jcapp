//
//  main.m
//  jcapp
//
//  Created by lh on 2019/11/15.
//  Copyright © 2019 midtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        @try {
            @autoreleasepool
            {
                return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
            }
        }
        @catch (NSException* exception)
        {
            //NSDebugLog(@"Exception=%@\nStack Trace:%@", exception, [exception callStackSymbols]);
        }
    }
}
