//
//  ZZWebViewHtmlItem.m
//  ZZWebView
//
//  Created by developer on 2019/9/6.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebViewHtmlItem.h"
@interface ZZWebViewHtmlItem()
@property(nonatomic, strong)NSString *string;
@property(nonatomic, strong)NSURL *baseURL;
@end
@implementation ZZWebViewHtmlItem
- (ZZWebViewHtmlItem *)initWithHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL {
    if(self = [super init]) {
        _string = string;
        _baseURL = baseURL;
    }
    return self;
}

- (void)load {
    [self loadHTMLString:self.string baseURL:self.baseURL];
}
@end
