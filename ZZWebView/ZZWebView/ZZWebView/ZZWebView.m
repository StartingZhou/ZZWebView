//
//  ZZWebView.m
//  ZZWebView
//
//  Created by developer on 2019/9/5.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebView.h"
#import "ZZWebViewManager.h"
#import "ZZWebViewItem.h"
@interface ZZWebView()
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) NSDictionary<NSString *, NSString *> *headers;
@property(nonatomic, strong) NSDictionary<NSString *, NSString *> *cookies;
@property(nonatomic, strong) UIView *progressView;
@end

@implementation ZZWebView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configWKWebView: nil andConfig: nil];
    }
    return self;
}

- (ZZWebView *)initWithItem:(ZZWebViewItem *)item andConfig:(nullable WKWebViewConfiguration *)config {
    self = [super init];
    if (self) {
        [self configWKWebView: item andConfig:config];
    }
    return self;
}

- (void)configWKWebView:(ZZWebViewItem *)item andConfig:(WKWebViewConfiguration *)_config {
    self.backgroundColor = [UIColor clearColor];
    self.layer.shadowRadius = 5;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(5, 5);
    self.layer.shadowOpacity = 0.8f;
    self.layer.masksToBounds = NO;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    if (_config) {
        config = config;
    }
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    [item.allPreUserScripts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WKUserScript *script = [[WKUserScript alloc] initWithSource:obj injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:true];
        [config.userContentController addUserScript:script];
    }];
    
    [item.allPostUserScripts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WKUserScript *script = [[WKUserScript alloc] initWithSource:obj injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:true];
        [config.userContentController addUserScript:script];
    }];
    
    [item.registCallBacks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [config.userContentController addScriptMessageHandler:obj name:key];
    }];
    self.headers = item.headers;
    self.cookies = item.extraCookies;
    config.websiteDataStore = WKWebsiteDataStore.defaultDataStore;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [self.webView addObserver:item forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView setUIDelegate:item];
    [self.webView setNavigationDelegate:item];
    [self addSubview:self.webView];
    if (item.isProgressShow) {
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, item.progressHeight)];
        self.progressView.backgroundColor = [item progressColor];
        [self addSubview:self.progressView];
    }
}

- (void)updateProgress:(NSString *)progress {
    if(!self.progressView) { return; }
    [UIView animateWithDuration:0.3 animations:^{
        self.progressView.frame = CGRectMake(0, 0, [progress doubleValue] * self.frame.size.width, self.progressView.frame.size.height);
        if(self.progressView.alpha == 0) {
            self.progressView.alpha = 1;
        }
    }];
    if ([progress doubleValue] == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
        } completion:^(BOOL finished) {
            self.progressView.frame = CGRectMake(0, 0, 0, self.progressView.frame.size.height);
        }];
    }
}

- (void)dealloc
{
    [self.webView setUIDelegate: nil];
    [self.webView setNavigationDelegate: nil];
    [self.webView removeFromSuperview];
    self.webView = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.webView.frame = self.bounds;
}

- (BOOL)reload {
    return [self.webView reload] != nil;
}

- (BOOL)canGoBack {
    return [self.webView canGoBack];
}

- (BOOL)goBack {
    BOOL can = [self canGoBack];
    [self.webView goBack];
    return can;
}

- (BOOL)canGoForward {
    return [self.webView canGoForward];
}

- (BOOL)goForward {
    BOOL can = [self canGoForward];
    [self.webView goForward];
    return can;
}

- (void)removeUserScript {
    [self.webView.configuration.userContentController removeAllUserScripts];
}

- (void)removeRegistHandler:(NSString *)handler {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:handler];
}

- (nullable WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL API_AVAILABLE(macosx(10.11), ios(9.0)) {
    return [self.webView loadData:data MIMEType:MIMEType characterEncodingName:characterEncodingName baseURL:baseURL];
}

- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request {
    NSMutableURLRequest *muRequest = [request mutableCopy];
    [muRequest setAllHTTPHeaderFields:self.headers];
    NSString *cookieOrigin = [muRequest valueForHTTPHeaderField:@"Cookie"];
    if(!cookieOrigin) { cookieOrigin = @""; }
    NSMutableString *cookieStr = [[NSMutableString alloc] init];
    [self.cookies enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [cookieStr appendFormat:@"%@=%@;",key, obj];
    }];
    if ([cookieStr length] > 0 && [cookieOrigin hasPrefix:@";"]) {
        [cookieStr deleteCharactersInRange:NSMakeRange([cookieStr length], 1)];
    }
    [cookieStr appendString:cookieOrigin];
    [muRequest setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    return [self.webView loadRequest:muRequest];
}

- (nullable WKNavigation *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(nullable NSURL *)readAccessURL {
    return [self.webView loadFileURL:URL allowingReadAccessToURL:readAccessURL];
}

- (nullable WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL {
    return [self.webView loadHTMLString:string baseURL:baseURL];
}

- (void)removeObserver:(ZZWebViewItem *)item {
    [self.webView removeObserver:item forKeyPath:@"estimatedProgress"];
}
@end
