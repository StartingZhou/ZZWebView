//
//  ZZWebView.h
//  ZZWebView
//
//  Created by developer on 2019/9/5.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class ZZWebViewItem;
@class ZZWebViewManager;
NS_ASSUME_NONNULL_BEGIN
@interface ZZWebView : UIView<WKNavigationDelegate, WKUIDelegate>

- (ZZWebView *)initWithItem:(ZZWebViewItem *)item andConfig:(nullable WKWebViewConfiguration *)config;

- (void)removeUserScript;

- (void)removeRegistHandler:(NSString *)handler;

- (BOOL)reload;

- (BOOL)canGoBack;

- (BOOL)goBack;

- (BOOL)canGoForward;

- (BOOL)goForward;

- (void)updateProgress:(nonnull NSString *)progress;

- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request;

- (nullable WKNavigation *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(nullable NSURL *)readAccessURL API_AVAILABLE(macosx(10.11), ios(9.0));

- (nullable WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;

- (nullable WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL API_AVAILABLE(macosx(10.11), ios(9.0));

- (void)removeObserver:(ZZWebViewItem *)item;
@end
NS_ASSUME_NONNULL_END
