//
//  TwitterOAuthViewController.h
//  Twitter-OAuth
//
//  Created by 杨建亚 on 15/1/12.
//  Copyright (c) 2015年 Dwarven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterOAuthViewController : UIViewController

- (id)initWithCompletion:(void(^)(BOOL succeeded, id object))completion;

@end
