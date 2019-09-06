//
//  ViewController.m
//  ZZWebView
//
//  Created by developer on 2019/9/5.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ViewController.h"
#import "ZZWebView/ZZWebViewItem.h"

@interface ViewController ()
@property(nonatomic, strong) ZZWebViewItem *item;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _item = [[ZZWebViewItem alloc] init];
    [_item createView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_item loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"https://www.baidu.com"]]];
    UIView *vi = [_item getZWebView];
    vi.frame = self.view.bounds;
    [self.view addSubview:vi];
}


@end
