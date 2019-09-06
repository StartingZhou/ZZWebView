//
//  ZZWebViewManager.h
//  ZZWebView
//
//  Created by developer on 2019/9/5.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ZZWebViewItem.h"

@class ZZWebViewItem;
NS_ASSUME_NONNULL_BEGIN
@interface ZZWebViewManager : NSObject

@property(nonatomic, assign)NSInteger maxCaches;

+ (ZZWebViewManager *)managerWithView:(UIView *)view;

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadRequest:(NSURLRequest *)request withStyle: (ZZWebViewPresentStyle) style;

- (void)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL API_AVAILABLE(macosx(10.11), ios(9.0));
- (void)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL withStyle: (ZZWebViewPresentStyle) style API_AVAILABLE(macosx(10.11), ios(9.0));

- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL withStyle: (ZZWebViewPresentStyle) style;

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL API_AVAILABLE(macosx(10.11), ios(9.0));
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL withStyle: (ZZWebViewPresentStyle) style API_AVAILABLE(macosx(10.11), ios(9.0));

- (void)popToItem:(ZZWebViewItem *)item;
- (void)popItem;
- (void)popToRootItem;
- (void)dismissItem;

- (nullable ZZWebViewItem *)goBack;

- (nullable ZZWebViewItem *)current;

- (nullable ZZWebViewItem *)goForward;

@end
NS_ASSUME_NONNULL_END
