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

@class ZZWebViewItem;

@interface ZZWebViewManager : NSObject

@property(nonatomic, assign)NSInteger maxCaches;

+ (ZZWebViewManager *)manager;

- (void)loadRequest:(NSURLRequest *)request onView:(UIView *)view animated:(BOOL) animation;

- (void)loadHTMLFile:(NSURL *)htmlFile onView:(UIView *)view animated:(BOOL) animation;

- (void)loadData:(NSData *)data onView:(UIView *)view animated:(BOOL) animation;

- (nullable ZZWebViewItem *)goBack;

- (nullable ZZWebViewItem *)current;

- (nullable ZZWebViewItem *)goForward;

@end

