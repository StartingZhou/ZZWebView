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

@interface ZZWebView : UIView<WKNavigationDelegate, WKUIDelegate>

- (ZZWebView *)initWithItem:(ZZWebViewItem *)item;

- (void)removeUserScript;

- (void)removeRegistHandler:(NSString *)handler;

- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request;

- (nullable WKNavigation *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL API_AVAILABLE(macosx(10.11), ios(9.0));

- (nullable WKNavigation *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;

- (nullable WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL API_AVAILABLE(macosx(10.11), ios(9.0));
@end

