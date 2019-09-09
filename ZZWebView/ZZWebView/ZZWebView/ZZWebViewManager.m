//
//  ZZWebViewManager.m
//  ZZWebView
//
//  Created by developer on 2019/9/5.
//  Copyright © 2019 Nextop. All rights reserved.
//
#import "ZZWebViewManager.h"
#import "ZZWebViewDataItem.h"
#import "ZZWebRequestViewItem.h"
#import "ZZWebViewHtmlItem.h"
#import "ZZWebViewFileURLItem.h"
#import "ZZWebViewConfigureItem.h"

@interface UIView(ZZWebViewManagerEx)

@end

@interface ZZWebViewManager()<ZZWebViewItemLinkDelegate, ZZWebViewItemCycleDelegate, ZZWebViewItemNewFrameDelegate>
@property(nonatomic, strong)NSMutableArray<ZZWebViewItem *>* items;
@property(nonatomic, weak)UIView* baseView;
@property(nonatomic, strong)ZZWebViewItem *currentItem;
@end

@implementation ZZWebViewManager

+ (ZZWebViewManager *)managerWithView:(UIView *)view {
    ZZWebViewManager *manager = [[ZZWebViewManager alloc] init];
    manager.baseView = view;
    manager.baseView.clipsToBounds = YES;
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
    [self loadRequest:request withStyle:ZZWebViewPresentStyleNone];
}

- (void)loadRequest:(NSURLRequest *)request withStyle: (ZZWebViewPresentStyle) style {
    ZZWebRequestViewItem *item = [[ZZWebRequestViewItem alloc] initWithRequest:request];
    item.presentStyle = style;
    [self install:item];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    [self loadHTMLString:string baseURL:baseURL withStyle:ZZWebViewPresentStyleNone];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL withStyle: (ZZWebViewPresentStyle) style {
    ZZWebViewHtmlItem *item = [[ZZWebViewHtmlItem alloc] initWithHTMLString:string baseURL:baseURL];
    item.presentStyle = style;
    [self install:item];
}

- (void)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL {
    [self loadFileURL:URL allowingReadAccessToURL:readAccessURL withStyle:ZZWebViewPresentStyleNone];
}

- (void)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL withStyle: (ZZWebViewPresentStyle) style {
    ZZWebViewFileURLItem *item = [[ZZWebViewFileURLItem alloc] initWithFile:URL allowingReadAccessToURL:readAccessURL];
    item.presentStyle = style;
    [self install:item];
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL {
    [self loadData:data MIMEType:MIMEType characterEncodingName:characterEncodingName baseURL:baseURL withStyle:ZZWebViewPresentStyleNone];
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL withStyle: (ZZWebViewPresentStyle) style {
    ZZWebViewDataItem *item = [[ZZWebViewDataItem alloc] initWithData:data MIMEType:MIMEType encodingName:characterEncodingName baseURL:baseURL];
    item.presentStyle = style;
    [self install:item];
}

- (void)install:(ZZWebViewItem *) item {
    item.cycleDelegate = self;
    item.frameDelegate = self;
    item.linkerDelegate = self;
    [self.items addObject:item];
    [item createView];
    if (item.presentStyle == ZZWebViewPresentStyleNone) {
        UIView *wView = [item getZWebView];
        [wView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
        wView.frame = self.baseView.bounds;
        [self.baseView addSubview:[item getZWebView]];
    } else if (item.presentStyle == ZZWebViewPresentStylePush) {
        [self pushItem:item];
    } else {
        [self presentItem:item];
    }
    if ([self.delegate respondsToSelector:@selector(manager:beginLoadItem:)]) {
        [self.delegate manager:self beginLoadItem:item];
    }
    [item load];
}

- (void)uninstall:(ZZWebViewItem *)item {
    UIView *targetView;
    if (!item) { item = self.currentItem; }
    if (item == self.currentItem) {
        NSUInteger indexOfCurrent = [self.items indexOfObject:item];
        if(indexOfCurrent == 0) {
            if ([self.items count] > 1) {
                self.currentItem = [self.items objectAtIndex:1];
                targetView = [self.currentItem getZWebView];
            } else {
                self.currentItem = nil;
            }
        } else {
            self.currentItem = [self.items objectAtIndex: indexOfCurrent - 1];
        }
    }
    targetView.frame = self.baseView.bounds;
    [item destoryView];
    [self.items removeObject:item];
}

- (void)uninstallALL {
    for (ZZWebViewItem *item in self.items) {
        [item destoryView];
    }
    [self.items removeAllObjects];
    self.currentItem = nil;
}

- (void)pushItem:(ZZWebViewItem *)item {
    if (!item) {
        return;
    }
    [self animationWith:self.currentItem targetItem:item style:ZZWebViewPresentStylePush isAddTarget:YES isRemoveSource:NO];
}

- (void)popToItem:(ZZWebViewItem *)item {
    if (![self.items containsObject:item] || self.currentItem == nil) {
        return;
    }
    NSUInteger indexOftarget = [self.items indexOfObject:item];
    NSUInteger indexOfCurrent = [self.items indexOfObject:self.currentItem];
    if (indexOfCurrent <= indexOftarget) {
        return;
    }
    if(indexOftarget == 0) {
        [self popToRootItem];
        return;
    }
    if (!item || indexOfCurrent - indexOftarget == 1) {
        [self popItem];
        return;
    }
    
    for (NSUInteger index = indexOftarget + 1; index < [self.items count]; index++) {
        if (index != indexOfCurrent) {
            [[self.items objectAtIndex:index] destoryView];
        }
    }
    ZZWebViewItem *target = item;
    if (indexOfCurrent < self.items.count) {
        [self.items removeObjectsInRange:NSMakeRange(indexOfCurrent, self.items.count - indexOfCurrent)];
    }
    [self animationWith:self.currentItem targetItem:target style:ZZWebViewPresentStylePush isAddTarget:YES isRemoveSource:YES];
}

- (void)popItem {
    if([self.items count] < 1 || self.currentItem == nil) {
        return;
    }
    
    if ([self.items count] == 1) {
        [self.items removeAllObjects];
        ZZWebViewItem *item = self.currentItem;
        self.currentItem = nil;
        [self animationWith:item targetItem:nil style:ZZWebViewPresentStylePush isAddTarget:NO isRemoveSource:YES];
        return;
    }
    
    NSUInteger indexOfCurrent = [self.items indexOfObject:self.currentItem];
    if (indexOfCurrent < 2) {
        [self popToRootItem];
        return;
    }
    ZZWebViewItem *target = [self.items objectAtIndex:indexOfCurrent - 1];
    for (NSUInteger index = indexOfCurrent + 1; index < [self.items count]; index++) {
        [[self.items objectAtIndex:index] destoryView];
    }
    if (indexOfCurrent < self.items.count) {
        [self.items removeObjectsInRange:NSMakeRange(indexOfCurrent, self.items.count - indexOfCurrent)];
    }
    [self animationWith:self.currentItem targetItem:target style:ZZWebViewPresentStylePush isAddTarget:NO isRemoveSource:YES];
}

- (void)popToRootItem {
    if([self.items count] < 2 || self.currentItem == nil) {
        return;
    }
    ZZWebViewItem *target = [self.items firstObject];
    for (ZZWebViewItem *item in self.items) {
        if (item != target && item != self.currentItem) {
            [item destoryView];
        }
    }
    [self.items removeAllObjects];
    [self.items addObject:target];
    [self animationWith:self.currentItem targetItem:target style:ZZWebViewPresentStylePush isAddTarget:NO isRemoveSource:YES];
}

- (void)presentItem:(ZZWebViewItem *)item {
    if (!item) {
        return;
    }
    UIView *targetView = [item getZWebView];
    targetView.frame = CGRectMake(0, self.baseView.frame.size.height, self.baseView.frame.size.width, self.baseView.frame.size.height);
    [self.baseView addSubview:targetView];
    [self animationWith:nil targetItem:item style:ZZWebViewPresentStylePresent isAddTarget:YES isRemoveSource:NO];
}

- (void)dismissItem {
    if (!self.currentItem || self.currentItem == nil || [self.items count] == 0) {
        return;
    }
    NSUInteger indexOfCurrent = [self.items indexOfObject:self.currentItem];
    if (indexOfCurrent == 0) {
        for (int index = indexOfCurrent + 1; index < [self.items count]; index++) {
            [self.items[index] destoryView];
        }
        [self.items removeAllObjects];
        ZZWebViewItem *sourceItem = self.currentItem;
        self.currentItem = nil;
        [self animationWith:sourceItem targetItem:nil style:ZZWebViewPresentStylePresent isAddTarget:NO isRemoveSource:YES];
        return;
    }
    NSUInteger indexOfTarget = indexOfCurrent - 1 ;
    ZZWebViewItem *target = [self.items objectAtIndex:indexOfTarget];
    [self animationWith:self.currentItem targetItem:target style: ZZWebViewPresentStylePresent isAddTarget:NO isRemoveSource:YES];
}

- (void)animationWith:(ZZWebViewItem *)sourceItem targetItem:(ZZWebViewItem *)targetItem style:(ZZWebViewPresentStyle) style isAddTarget:(BOOL) isAddTarget isRemoveSource:(BOOL) removeSource {
    CGRect baseViewFrame = CGRectMake(0, 0, self.baseView.frame.size.width, self.baseView.frame.size.height);
    BOOL containSourceItem = sourceItem != nil;
    BOOL containTargetItem = targetItem != nil;
    UIView *targetView = [targetItem getZWebView];
    UIView *currentView = [sourceItem getZWebView];
    CGRect targetEndFrame = CGRectZero;
    CGRect targetBeginFrame = CGRectZero;
    if (style == ZZWebViewPresentStylePush) {
        targetBeginFrame = CGRectMake(baseViewFrame.size.width, 0, baseViewFrame.size.width, baseViewFrame.size.height);
        targetEndFrame = CGRectMake(-baseViewFrame.size.width / 3, 0, baseViewFrame.size.width, baseViewFrame.size.height);
        if (removeSource) {
            targetEndFrame = CGRectMake(baseViewFrame.size.width , 0, baseViewFrame.size.width, baseViewFrame.size.height);
        }
    } else {
        targetBeginFrame = CGRectMake(0, baseViewFrame.size.height, baseViewFrame.size.width, baseViewFrame.size.height);
        targetEndFrame = CGRectMake(0, baseViewFrame.size.height, baseViewFrame.size.width, baseViewFrame.size.height);
    }
    if (containTargetItem) {
        self.currentItem = nil;
        if (isAddTarget) {
            [self.baseView addSubview:targetView];
            targetView.frame = targetBeginFrame;
        }
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        targetView.frame = baseViewFrame;
        currentView.frame = targetEndFrame;
    } completion:^(BOOL finished) {
        if(finished) {
            if (containTargetItem) {
                self.currentItem = targetItem;
            }
            if (removeSource && containSourceItem) {
                [sourceItem destoryView];
                [self.items removeObject:sourceItem];
                if(sourceItem == targetItem && sourceItem == self.currentItem) {
                    self.currentItem = nil;
                }
            }
        }
    }];
}

- (ZZWebViewItem *)goBack {
    if (!self.currentItem || self.items.count <= 1 || [self.items indexOfObject:self.currentItem] == 0) { return nil; }
    if ([self.currentItem canGoBack]) {
        [self.currentItem back];
    } else {
        CGRect baseViewFrame = CGRectMake(0, 0, self.baseView.frame.size.width, self.baseView.frame.size.height);
        NSUInteger indexOfCurrent = [self.items indexOfObject:self.currentItem];
        ZZWebViewItem *previous = [self.items objectAtIndex:indexOfCurrent - 1];
        UIView *sourceView = [self.currentItem getZWebView];
        UIView *targetView = [previous getZWebView];
        CGRect targetFrame = CGRectMake(0, 0, baseViewFrame.size.width, baseViewFrame.size.height);
        CGRect sourceFrame = CGRectZero;
        if (self.currentItem.presentStyle == ZZWebViewPresentStylePush) {
            sourceFrame = CGRectMake(baseViewFrame.size.width, 0, baseViewFrame.size.width, baseViewFrame.size.height);
        } else if (self.currentItem.presentStyle == ZZWebViewPresentStylePresent) {
            sourceFrame = CGRectMake(0, baseViewFrame.size.height, baseViewFrame.size.width, baseViewFrame.size.height);
        } else {
            sourceView.frame = sourceFrame;
            self.currentItem = previous;
            return self.currentItem;
        }
        targetView.frame = targetFrame;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            sourceView.frame = sourceFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                self.currentItem = previous;
            }
        }];
    }
    return self.currentItem;
}

- (ZZWebViewItem *)goForward {
    if (!self.currentItem || self.items.count <= 1 || [self.items indexOfObject:self.currentItem] == [self.items count] - 1) { return nil; }
    if  ([self.currentItem canGoForward]) {
        [self.currentItem forward];
    } else {
        CGRect baseViewFrame = CGRectMake(0, 0, self.baseView.frame.size.width, self.baseView.frame.size.height);
        NSUInteger indexOfCurrent = [self.items indexOfObject:self.currentItem];
        ZZWebViewItem *next = [self.items objectAtIndex:indexOfCurrent + 1];
        UIView *sourceView = [self.currentItem getZWebView];
        UIView *targetView = [next getZWebView];
        CGRect targetFrame = CGRectMake(0, 0, baseViewFrame.size.width, baseViewFrame.size.height);
        CGRect sourceFrame = CGRectZero;
        if (next.presentStyle == ZZWebViewPresentStylePush) {
            sourceFrame = CGRectMake(-baseViewFrame.size.width / 3, 0, baseViewFrame.size.width, baseViewFrame.size.height);
        } else if (next.presentStyle == ZZWebViewPresentStylePresent) {
            sourceFrame = CGRectMake(0, 0, baseViewFrame.size.width, baseViewFrame.size.height);
        } else {
            sourceView.frame = sourceFrame;
            self.currentItem = next;
            return self.currentItem;
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            targetView.frame = targetFrame;
            sourceView.frame = sourceFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                self.currentItem = next;
            }
        }];
    }
    return self.currentItem;
}

- (ZZWebViewItem *)current {
    return self.currentItem;
}

- (BOOL)reload {
    return [self.currentItem reload];
}

// MARK: Item delegates
- (BOOL)linkFromWebItem:(ZZWebViewItem *)item toURL:(NSString *)toURL {
    if([self.delegate respondsToSelector:@selector(manager:shouldRedirectFrom:toURL:)]) {
        return [self.delegate manager:self shouldRedirectFrom:item toURL:toURL];
    }
    return YES;
}

- (void)createNewWebViewWith:(WKWebViewConfiguration *)configuration fromWebItem:(ZZWebViewItem *)webItem targetURL:(NSString *)targetURL {
    ZZWebViewItem *item = nil;
    if([self.delegate respondsToSelector:@selector(manager:ShouldCreateNewPage:with:to:)]) {
        item = [self.delegate manager:self ShouldCreateNewPage:webItem with:configuration to:targetURL];
    } else {
        item = [[ZZWebViewConfigureItem alloc] initWithConfig:configuration fromWebItem:webItem targetURL:targetURL];
    }
    item.presentStyle = ZZWebViewPresentStylePush;
    [self install:item];
}

- (void)onLoadSuccess:(ZZWebViewItem *)webItem {
    if([self.delegate respondsToSelector:@selector(manager:finishLoadItem:)]) {
        [self.delegate manager:self finishLoadItem:webItem];
    }
}

- (void)onLoadFail:(ZZWebViewItem *)webItem error:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(manager:failLoadItem:error:)]) {
        [self.delegate manager:self failLoadItem:webItem error:error];
    }
}

- (void)onClose:(ZZWebViewItem *)webItem {
    [self uninstall:webItem];
}

- (void)onProgressChange:(ZZWebViewItem * _Nonnull)webItem progress:(NSString *)progress {
    if ([self.delegate respondsToSelector:@selector(manager:progressChange:)]) {
        [self.delegate manager:self progressChange:progress];
    }
}

- (void)dealloc
{
    [self uninstallALL];
}
@end
