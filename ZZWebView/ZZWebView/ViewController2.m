//
//  ViewController2.m
//  ZZWebView
//
//  Created by developer on 2019/9/19.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ViewController2.h"
#import "ZZWebViewManager.h"
#import "ZZWebRequestViewItem.h"
@interface ViewController2 ()<ZZWebViewManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *viContent;
@property(nonatomic, strong) ZZWebViewManager *manager;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [ZZWebViewManager managerWithView:self.viContent];
    self.manager.delegate = self;
    // Do any additional setup after loading the view.
}

- (IBAction)clickScriptBtn:(id)sender {
    NSString *jsCallBackFunction = @"var messageBody = {\"name\": \"Tom\"} ;function alertWithString() { window.webkit.messageHandlers.callName.postMessage(messageBody) }";
    NSString *changeSubmitAction = @"document.getElementById(\"index-bn\").onclick = function(event) { event.preventDefault(); alertWithString(); alert(messageBody.name)}";
    ZZWebViewItem *item = [[ZZWebRequestViewItem alloc] initWithRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    item.presentStyle = ZZWebViewPresentStylePush;
    [item addLoadedScript:@"document.getElementsByClassName(\"se-input adjust-input\")[0].value = \"Chrome 浏览器\""];
    [item addLoadedScript:jsCallBackFunction];
    [item addLoadedScript:changeSubmitAction];
    [item registName:@"callName" forCallBack:^(ZZWebViewItem * _Nonnull item, NSString * _Nonnull name, id _Nullable body) {
        NSLog(@"%@", body);
    }];
    [self.manager loadItem:item];
}

- (void)manager:(ZZWebViewManager *)manager ofItem:(ZZWebViewItem *)webItem receiveAlertMessage:(NSString *)message byFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"WKWebView Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
