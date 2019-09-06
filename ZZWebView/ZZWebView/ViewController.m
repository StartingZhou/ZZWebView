//
//  ViewController.m
//  ZZWebView
//
//  Created by developer on 2019/9/5.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ViewController.h"
#import "ZZWebView/ZZWebViewManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property(nonatomic, strong) ZZWebViewManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightBtn addTarget:self action:@selector(presentThis) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.backgroundColor = [UIColor blueColor];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"Present" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.manager = [ZZWebViewManager managerWithView:self.contentView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.manager loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]] withStyle:ZZWebViewPresentStylePresent];
}

- (void)presentThis {
    [self.manager loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.taobao.com"]] withStyle:ZZWebViewPresentStylePresent];
}
- (IBAction)present:(id)sender {
    [self.manager loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.taobao.com"]] withStyle:ZZWebViewPresentStylePresent];
}

- (IBAction)dismiss:(id)sender {
    [self.manager dismissItem];
}

- (IBAction)push:(id)sender {
    [self.manager loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com"]] withStyle:ZZWebViewPresentStylePush];
}

- (IBAction)pop:(id)sender {
    [self.manager popItem];
}

- (IBAction)unins:(id)sender {
}

@end
