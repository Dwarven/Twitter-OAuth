//
//  ViewController.m
//  Twitter-OAuth
//
//  Created by 杨建亚 on 15/1/12.
//  Copyright (c) 2015年 Dwarven. All rights reserved.
//

#import "ViewController.h"
#import "TwitterOAuthViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (IBAction)login:(id)sender {
    TwitterOAuthViewController * twitterOAuthVC = [[TwitterOAuthViewController alloc] initWithCompletion:^(BOOL succeeded, id object) {
        [_textView setText:[NSString stringWithFormat:@"%@",object]];
    }];
    [self presentViewController:twitterOAuthVC animated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
