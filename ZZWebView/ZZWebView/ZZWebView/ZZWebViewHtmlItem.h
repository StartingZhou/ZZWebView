//
//  ZZWebViewHtmlItem.h
//  ZZWebView
//
//  Created by developer on 2019/9/6.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebViewItem.h"

//- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
@interface ZZWebViewHtmlItem : ZZWebViewItem
- (ZZWebViewHtmlItem *)initWithHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
@end

