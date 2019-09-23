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
    WKWebViewConfiguration *_webConfig;
    BOOL isCreated;
}


@end

@implementation ZZWebViewItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
        _webConfig = nil;
        _presentStyle = ZZWebViewPresentStyleNone;
    }
    return self;
}

- (void) initialize {
    _isProgressShow = YES;
    _progressColor = [UIColor greenColor];
    _progressHeight = 1;
    _allHandler = [[NSMutableDictionary alloc] init];
    _cookies = [[NSMutableDictionary alloc] init];
    _headers = [[NSMutableDictionary alloc] init];
    _allPreScript = [[NSMutableArray alloc] init];
    _allPostScript = [[NSMutableArray alloc] init];
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
    [self createViewWithConfig:nil];
}

- (void)createViewWithConfig:(nullable WKWebViewConfiguration *) config {
    NOTEXECUTE(isCreated);
    isCreated = YES;
    _zzView = [[ZZWebView alloc] initWithItem:self andConfig:config];
}

- (void) cookiePersistent {
    [self addLoadedScript:@"function zzwebViewGetCookie() { var cookie = document.cookie; window.webkit.messageHandlers.zzwebViewCookieCallBack.postMessage(cookie); }; zzwebViewGetCookie();"];
    __weak ZZWebViewItem *weakSelf = self;
    [self registName:@"zzwebViewCookieCallBack" forCallBack:^(ZZWebViewItem * item, NSString * name, id cookie) {
        if (weakSelf && item == weakSelf && [name isEqualToString:@"zzwebViewCookieCallBack"] && cookie) {
            NSString *cookieString = cookie;
            if (cookieString.length > 0) {
                [weakSelf resolveCookieString:cookieString];
            }
        }
    }];
}

- (void)resolveCookieString: (NSString *)cookie {
    NSArray<NSString *> *allCookie = [cookie componentsSeparatedByString:@";"];
    for (NSString *one in allCookie) {
        NSArray<NSString *> *kvBind = [one componentsSeparatedByString:@"="];
        if (kvBind.count > 1) {
            [_cookies setObject:kvBind[1] forKey:kvBind[0]];
        } else if (kvBind.count == 1) {
            [_cookies setObject:@"" forKey:kvBind[0]];
        }
    }
}

- (NSString *)getCookies {
    NSMutableString *cookieString = [NSMutableString stringWithString:@""];
    [_cookies enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [cookieString appendFormat:@"%@=%@;",key, obj];
    }];
    return cookieString;
}

- (NSDictionary *)getCookiesDic {
    return _cookies;
}

- (UIView *)getZWebView {
    if (!isCreated) {
        [self createView];
    }
    return _zzView;
}

- (void)destoryView {
    NOTEXECUTE(!isCreated);
    if (!isCreated) {
        return;
    }
    if ([self.cycleDelegate respondsToSelector:@selector(onBeforeDestory:)]) {
        [self.cycleDelegate onBeforeDestory:self];
    }
    isCreated = NO;
    [_zzView removeObserver:self];
    [_zzView removeFromSuperview];
    _zzView = nil;
    if ([self.cycleDelegate respondsToSelector:@selector(onAfterDestory:)]) {
        [self.cycleDelegate onAfterDestory:self];
    }
}

- (BOOL)canGoBack {
    return [_zzView canGoBack];
}

- (BOOL)back {
    return [_zzView goBack];
}

- (BOOL)canGoForward {
    return [_zzView canGoForward];
}

- (BOOL)forward {
    return [_zzView goForward];
}

- (void)load {}

- (BOOL)reload {
    return [_zzView reload];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSNumber *str = [change objectForKey:NSKeyValueChangeNewKey];
        if ([self.cycleDelegate respondsToSelector:@selector(onProgressChange:progress:)]) {
            [self.cycleDelegate onProgressChange:self progress:[str stringValue]];
        }
        if (self.isProgressShow) {
            [_zzView updateProgress:[str stringValue]];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

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

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    if ([self.alertDelegate respondsToSelector:@selector(item:receiveAlertMessage:byFrame:completionHandler:)]) {
        [self.alertDelegate item:self receiveAlertMessage:message byFrame:frame completionHandler:completionHandler];
    } else {
        completionHandler();
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    if ([self.alertDelegate respondsToSelector:@selector(item:receiveConfirmAlertMessage:byFrame:completionHandler:)]) {
        [self.alertDelegate item:self receiveConfirmAlertMessage:message byFrame:frame completionHandler:completionHandler];
    } else {
        completionHandler(NO);
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    if ([self.alertDelegate respondsToSelector:@selector(item:receiveTextInputAlertMessage:defaultText:byFrame:completionHandler:)]) {
        [self.alertDelegate item:self receiveTextInputAlertMessage:prompt defaultText:defaultText byFrame:frame completionHandler:completionHandler];
    } else {
        completionHandler(nil);
    }
}

// MARK: WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = [[navigationAction request] URL];
    if ([self.linkerDelegate linkFromWebItem:self toURL:url.absoluteString]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    decisionHandler(WKNavigationActionPolicyCancel);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction preferences:(WKWebpagePreferences *)preferences decisionHandler:(void (^)(WKNavigationActionPolicy, WKWebpagePreferences * _Nonnull))decisionHandler  API_AVAILABLE(ios(13.0)){
    NSURL *url = [[navigationAction request] URL];
    if ([self.linkerDelegate linkFromWebItem:self toURL:url.absoluteString]) {
        decisionHandler(WKNavigationActionPolicyAllow, preferences);
        return;
    }
    decisionHandler(WKNavigationActionPolicyCancel, preferences);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
//    if ([navigationResponse.response.MIMEType isEqualToString:@"application/octet-stream"]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (@available(iOS 11.0, *)) {
//                [[[[webView configuration] websiteDataStore] httpCookieStore] getAllCookies:^(NSArray<NSHTTPCookie *> * all) {
//                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:navigationResponse.response.URL];
//                    for (NSHTTPCookie *cookieOne in all) {
//                        [self->_cookies setObject:cookieOne.value forKey:cookieOne.name];
//                    }
//                    [request addValue:[self getCookies] forHTTPHeaderField:@"Cookie"];
//                    NSURLSession *session = [NSURLSession sharedSession];
//                    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [webView loadData:data MIMEType:@"application/pdf" characterEncodingName:@"UTF-8" baseURL:nil];
//                            //[webView loadHTMLString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] baseURL:nil];
//                        });
//                    }];
//                    [task resume];
//                }];
//            } else {
//                // Fallback on earlier versions
//            }
//
//        });
//
//        decisionHandler(WKNavigationResponsePolicyCancel);
//        return;
//    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self.cycleDelegate onLoadSuccess:self];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [_zzView updateProgress:@"1"];
    [self.cycleDelegate onLoadFail:self error:error];
}

@end
