//
//  ZZWebViewConfigureItem.m
//  ZZWebView
//
//  Created by Zhou Xiaoyu on 9/6/19.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebViewConfigureItem.h"

@interface ZZWebViewConfigureItem()

@property(nonatomic, strong) WKWebViewConfiguration *configuration;
@property(nonatomic, strong) ZZWebViewItem *webItem;
@property(nonatomic, strong) NSString *targetURL;

@end

@implementation ZZWebViewConfigureItem
- (ZZWebViewConfigureItem *)initWithConfig:(WKWebViewConfiguration *_Nonnull)configuration fromWebItem:(ZZWebViewItem *_Nonnull)webItem targetURL:(NSString *_Nonnull)targetURL {
    if (self = [super init]) {
        _configuration = configuration;
        _webItem = webItem;
        _targetURL = targetURL;
    }
    return self;
}

- (void)load {
    [self loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:self.targetURL]]];
}
@end
