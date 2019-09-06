//
//  UIView+ZZWebView.h
//  ZZWebView
//
//  Created by developer on 2019/9/5.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZWebViewManager;

@interface UIView ()
- (ZZWebViewManager *)loadRequest:(NSURLRequest *)request;
- (ZZWebViewManager *)loadHtmlFileAt:(NSURL *)htmlFile;
- (ZZWebViewManager *)loadData:(NSData *)data;
@end

