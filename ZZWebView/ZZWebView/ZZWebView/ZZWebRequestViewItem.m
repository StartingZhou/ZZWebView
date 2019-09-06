//
//  ZZWebRequestViewItem.m
//  ZZWebView
//
//  Created by developer on 2019/9/6.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebRequestViewItem.h"
@interface ZZWebRequestViewItem()
@property(nonatomic, strong)NSURLRequest *request;
@end

@implementation ZZWebRequestViewItem
- (ZZWebRequestViewItem *)initWithRequest:(NSURLRequest *)request {
    if (self = [super init]) {
        self.request = request;
    }
    return self;
}

- (void)load {
    [self loadRequest: self.request];
}
@end
