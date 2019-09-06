//
//  ZZWebViewManager.m
//  ZZWebView
//
//  Created by developer on 2019/9/5.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebViewManager.h"
#import <UIKit/UIKit.h>
@interface UIView(ZZWebViewManagerEx)

@end

@interface ZZWebViewManager()
@property(nonatomic, strong)NSMutableArray* webViews;
@property(nonatomic, weak)UIView* baseView;
@end

@implementation ZZWebViewManager

+(ZZWebViewManager *)manager {
    return [[ZZWebViewManager alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.webViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadRequest:(NSURLRequest *)request onView:(UIView *)view animated:(BOOL) animation {
    self.baseView = view;
}

- (void)loadHTMLFile:(NSURL *)htmlFile onView:(UIView *)view animated:(BOOL) animation {
    self.baseView = view;
}

- (void)loadData:(NSData *)data onView:(UIView *)view animated:(BOOL) animation {
    self.baseView = view;
}

- (ZZWebViewItem *)goBack {
    return nil;
}

- (ZZWebViewItem *)goForward {
    return nil;
}

- (ZZWebViewItem *)current {
    return nil;
}

@end
