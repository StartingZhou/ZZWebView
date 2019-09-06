//
//  ZZWebViewConfigureItem.h
//  ZZWebView
//
//  Created by Zhou Xiaoyu on 9/6/19.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebViewItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZWebViewConfigureItem : ZZWebViewItem

- (ZZWebViewConfigureItem *)initWithConfig:(WKWebViewConfiguration *_Nonnull)configuration fromWebItem:(ZZWebViewItem *_Nonnull)webItem targetURL:(NSString *_Nonnull)targetURL;
@end

NS_ASSUME_NONNULL_END
