//
//  ZZWebViewHtmlItem.h
//  ZZWebView
//
//  Created by developer on 2019/9/6.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebViewItem.h"

NS_ASSUME_NONNULL_BEGIN
@interface ZZWebViewHtmlItem : ZZWebViewItem
- (ZZWebViewHtmlItem *)initWithHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
@end
NS_ASSUME_NONNULL_END
