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
    UIView *viLeftBarItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
    viLeftBarItem.backgroundColor = [UIColor clearColor];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 35)];
    UIButton *prevButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 30, 35)];
    [backButton setImage:[UIImage imageNamed:@"ic_btn_back"] forState:UIControlStateNormal];
    [prevButton setImage:[UIImage imageNamed:@"ic_btn_prev"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backWeb:) forControlEvents:UIControlEventTouchUpInside];
    [prevButton addTarget:self action:@selector(prevWeb:) forControlEvents:UIControlEventTouchUpInside];
    [viLeftBarItem addSubview:backButton];
    [viLeftBarItem addSubview:prevButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viLeftBarItem];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Script" style:UIBarButtonItemStylePlain target:self action:@selector(toScriptVC)];
    self.manager = [ZZWebViewManager managerWithView:self.contentView];
    self.manager.progressColor = [UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   // [self.manager loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]] withStyle:ZZWebViewPresentStylePresent];
}

- (void)toScriptVC {
    [self performSegueWithIdentifier:@"scriptID" sender:nil];
}

- (void)backWeb:(id)sender {
    [self.manager goBack];
}

- (void)prevWeb:(id)sender {
    [self.manager goForward];
}

- (void)presentThis {
    [self.manager loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]] withStyle:ZZWebViewPresentStylePresent];
}
- (IBAction)present:(id)sender {
    [self.manager loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]] withStyle:ZZWebViewPresentStylePresent];
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
    [self.manager popToRootItem];
}

@end
