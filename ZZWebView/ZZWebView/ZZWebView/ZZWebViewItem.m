//
//  ZZWebViewItem.m
//  ZZWebView
//
//  Created by developer on 2019/9/5.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebViewItem.h"
#import "ZZWebView.h"

#define NOTEXECUTE(x) NSAssert(!x, @"ZZWebViewItem Error"); \
                    if(x) { return; }

@interface ZZWebViewMessageHandler: NSObject<WKScriptMessageHandler>
@property(nonatomic, weak)ZZWebViewItem *currentItem;
@property(nonatomic, strong)ZZWebViewMessageHandlerCallback callBack;
- (ZZWebViewMessageHandler *)initWithItem:(ZZWebViewItem *)item andCallBack:(ZZWebViewMessageHandlerCallback) call;
@end

@implementation ZZWebViewMessageHandler

- (ZZWebViewMessageHandler *)initWithItem:(ZZWebViewItem *)item andCallBack:(ZZWebViewMessageHandlerCallback)call {
    self = [super init];
    if(self) {
        self.currentItem = item;
        self.callBack = call;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    _callBack(_currentItem, message.name, message.body);
}

@end


@interface ZZWebViewItem()
{
    NSMutableDictionary<NSString *, NSString *>* _headers;
    NSMutableDictionary<NSString *, NSString *>* _cookies;
    NSMutableArray<NSString *>* _allPreScript;
    NSMutableArray<NSString *>* _allPostScript;
    NSMutableArray<NSString *>* _allowDomain;
    NSMutableDictionary<NSString *, ZZWebViewMessageHandler *>* _allHandler;
    ZZWebView *_zzView;
    WKNavigation *_currentNavi;
    BOOL isCreated;
}


@end

@implementation ZZWebViewItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        _allHandler = [[NSMutableDictionary alloc] init];
        _cookies = [[NSMutableDictionary alloc] init];
        _headers = [[NSMutableDictionary alloc] init];
        _allPreScript = [[NSMutableArray alloc] init];
        _allPostScript = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSDictionary *)headers {
    return _headers;
}

- (NSDictionary *)extraCookies {
    return _cookies;
}

- (NSDictionary *)registCallBacks {
    return _allHandler;
}

- (NSArray *)allPostUserScripts {
    return _allPostScript;
}

- (NSArray *)allPreUserScripts {
    return _allPreScript;
}

- (void)addCookie:(NSString *)value forKey:(NSString *)key {
    NOTEXECUTE(isCreated);
    [_cookies setObject:value forKey:key];
}

- (void)setRequestHeader:(NSString *)value forKey:(NSString *)key {
    NOTEXECUTE(isCreated);
    [_headers setObject:value forKey:key];
}

- (void)addLoadedScript:(NSString *)jsCode {
    NOTEXECUTE(isCreated);
    [_allPostScript addObject:jsCode];
}

- (void)addBeforeLoadScript:(NSString *)jsCode {
    NOTEXECUTE(isCreated);
    [_allPreScript addObject:jsCode];
}

- (void)registName:(NSString *)name forCallBack:(ZZWebViewMessageHandlerCallback)callBack {
    NOTEXECUTE(isCreated);
    ZZWebViewMessageHandler *handler = [[ZZWebViewMessageHandler alloc] initWithItem:self andCallBack:callBack];
    [_allHandler setObject:handler forKey:name];
}

- (void)removeScript {
    NOTEXECUTE(isCreated);
    if (_zzView) {
        [_zzView removeUserScript];
    }
    [_allPreScript removeAllObjects];
    [_allPostScript removeAllObjects];
    
}

- (void)removeRegistName:(NSString *)name {
    NOTEXECUTE(isCreated);
    if (_zzView) {
        [_zzView removeRegistHandler:name];
    }
    [_allHandler removeAllObjects];
}

- (void)createView {
    NOTEXECUTE(isCreated);
    isCreated = YES;
    _zzView = [[ZZWebView alloc] initWithItem:self];
}

- (UIView *)getZWebView {
    if (!isCreated) {
        [self createView];
    }
    return _zzView;
}

- (void)destoryView {
    NOTEXECUTE(!isCreated);
    isCreated = NO;
    [_zzView removeFromSuperview];
    _zzView = nil;
}

- (void)load {}

- (void)loadRequest:(NSURLRequest *)request {
    NOTEXECUTE(!isCreated);
    self.urlString = request.URL.absoluteString;
    _currentNavi = [_zzView loadRequest:request];
}

- (void)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL API_AVAILABLE(macosx(10.11), ios(9.0)) {
    NOTEXECUTE(!isCreated);

    _currentNavi = [_zzView loadFileURL:URL allowingReadAccessToURL:readAccessURL];
}

- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL {
    NOTEXECUTE(!isCreated);

    _currentNavi = [_zzView loadHTMLString:string baseURL:baseURL];
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL API_AVAILABLE(macosx(10.11), ios(9.0)) {
    NOTEXECUTE(!isCreated);

    _currentNavi = [_zzView loadData:data MIMEType:MIMEType characterEncodingName:characterEncodingName baseURL:baseURL];
}

// MARK: WKUIDelegate

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSURL *url = [[navigationAction request] URL];
    [self.frameDelegate createNewWebViewWith:configuration fromWebItem:self targetURL:url.absoluteString];
    return nil;
}

- (void)webViewDidClose:(WKWebView *)webView {
    [self.cycleDelegate onClose:self];
}

//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//
//}
//
//
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
//
//}
//
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
//
//}

//- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo  API_AVAILABLE(ios(10.0)){
//    return NO;
//}
//
//- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions  API_AVAILABLE(ios(10.0)){
//    return nil;
//}
//
//
//- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(ios(10.0)) {
//
//}

// MARK: WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = [[navigationAction request] URL];
    if ([self.linkerDelegate linkFromWebItem:self toURL:url.absoluteString]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    decisionHandler(WKNavigationActionPolicyCancel);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self.cycleDelegate onLoadSuccess:self];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.cycleDelegate onLoadFail:self];
}

//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
//
//}
//
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
//
//}
@end
