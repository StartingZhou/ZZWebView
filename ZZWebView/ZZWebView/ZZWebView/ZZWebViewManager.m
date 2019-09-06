//
//  ZZWebViewManager.m
//  ZZWebView
//
//  Created by developer on 2019/9/5.
//  Copyright © 2019 Nextop. All rights reserved.
//
#import "ZZWebViewManager.h"
#import "ZZWebViewItem.h"


@interface UIView(ZZWebViewManagerEx)

@end

@interface ZZWebViewManager()<ZZWebViewItemLinkDelegate, ZZWebViewItemCycleDelegate, ZZWebViewItemNewFrameDelegate>
@property(nonatomic, strong)NSMutableArray<ZZWebViewItem *>* items;
@property(nonatomic, weak)UIView* baseView;
@end

@implementation ZZWebViewManager

+ (ZZWebViewManager *)managerWithView:(UIView *)view {
    ZZWebViewManager *manager = [[ZZWebViewManager alloc] init];
    manager.baseView = view;
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadRequest:(NSURLRequest *)request {
    
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    
}

- (void)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL {
    
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL {
    
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

// MARK: Item delegates
- (BOOL)linkFromWebItem:(ZZWebViewItem *)item toURL:(NSString *)toURL {
    return YES;
}

- (void)createNewWebViewWith:(WKWebViewConfiguration *)configuration fromWebItem:(ZZWebViewItem *)webItem targetURL:(NSString *)targetURL {
    
}

- (void)onLoadSuccess:(ZZWebViewItem *)webItem {
    
}

- (void)onLoadFail:(ZZWebViewItem *)webItem {
    
}

- (void)onClose:(ZZWebViewItem *)webItem {
    
}
@end
