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
#import "ZZWebViewAnimatable.h"

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

- (void)addNewItemView:(ZZWebViewItem *)item {
    item.cycleDelegate = self;
    item.frameDelegate = self;
    item.linkerDelegate = self;
    [item createView];
    UIView *wView = [item getZWebView];
    wView.frame = CGRectZero;
    [self.baseView addSubview:wView];
}

- (void)install:(ZZWebViewItem *) item {
    [self addNewItemView:item];
    [self.items addObject:item];
    ZZWebViewItem *previous = self.currentItem;
    self.currentItem = item;
    [ZZWebViewAnimatable addAnimation:item atCurrentItem:previous andBaseView:self.baseView completion:^(BOOL finish) {
        if (finish) {
            if ([self.delegate respondsToSelector:@selector(manager:beginLoadItem:)]) {
                [self.delegate manager:self beginLoadItem:item];
            }
            [item load];
        }
    }];
}

- (void)uninstall:(ZZWebViewItem *)item {
    ZZWebViewItem *previousItem = nil;
    if (item && item == self.currentItem) {
        NSUInteger index = [self.items indexOfObject:item];
        [self.items removeObject:item];
        if ( index > 0) {
            previousItem = self.items[index - 1];
            self.currentItem = previousItem;
        }
        [ZZWebViewAnimatable removeAnimaion:previousItem atCurrentItem:item andBaseView:self.baseView completion:^(BOOL finish) {
            if (finish) {
                [item destoryView];
            }
        }];
    } else {
        [self.items removeObject:item];
        [item destoryView];
    }
}

- (void)uninstallALL {
    for (ZZWebViewItem *item in self.items) {
        [item destoryView];
    }
    [self.items removeAllObjects];
    self.currentItem = nil;
}

- (void)pushItem:(ZZWebViewItem *)item {
    [self addNewItemView:item];
    NSUInteger indexOfCurrent = [self.items indexOfObject:self.currentItem] ;
    if (indexOfCurrent == NSNotFound) {
        [self.items addObject:item];
    } else {
        [self.items insertObject:item atIndex:indexOfCurrent];
    }
    ZZWebViewItem *hideItem = self.currentItem;
    self.currentItem = item;
    [ZZWebViewAnimatable pushItem:item atCurrentItem:hideItem andBaseView:self.baseView completion:nil];
}

- (void)popToItem:(ZZWebViewItem *)item {
    NSUInteger indexOftarget = [self.items indexOfObject:item];
    if (indexOftarget == NSNotFound || self.currentItem == nil) {
        return;
    }
    NSUInteger indexOfCurrent = [self.items indexOfObject:self.currentItem];
    if (indexOfCurrent <= indexOftarget) {
        return;
    }
    
    for (NSUInteger index = indexOftarget + 1; index < [self.items count]; index++) {
        if (index != indexOfCurrent) {
            [[self.items objectAtIndex:index] destoryView];
        }
    }
    ZZWebViewItem *target = item;
    ZZWebViewItem *popItem = self.currentItem;
    self.currentItem = target;
    if (indexOfCurrent < self.items.count) {
        [self.items removeObjectsInRange:NSMakeRange(indexOftarget + 1, self.items.count - indexOftarget)];
    }
    [ZZWebViewAnimatable popItem:target atCurrentItem:popItem andBaseView:self.baseView completion:^(BOOL finish) {
        if (finish) {
            [popItem destoryView];
        }
    }];
}

- (void)popItem {
    [self disappearItem:ZZWebViewPresentStylePush];
}

- (void)popToRootItem {
    if([self.items count] < 2 || self.currentItem == nil) {
        return;
    }
    ZZWebViewItem *target = [self.items firstObject];
    ZZWebViewItem *popItem = self.currentItem;
    self.currentItem = target;
    for (ZZWebViewItem *item in self.items) {
        if (item != target && item != popItem) {
            [item destoryView];
        }
    }
    self.items = [NSMutableArray arrayWithObject:target];
    [ZZWebViewAnimatable popItem:target atCurrentItem:popItem andBaseView:self.baseView completion:^(BOOL finish) {
        if (finish) {
            [popItem destoryView];
        }
    }];
}

- (void)presentItem:(ZZWebViewItem *)item {
    if (!item) {
        return;
    }
    [self addNewItemView:item];
    [ZZWebViewAnimatable presentItem:item andBaseView:self.baseView completion:nil];
}

- (void)dismissItem {
    [self disappearItem:ZZWebViewPresentStylePresent];
}

- (void)disappearItem:(ZZWebViewPresentStyle)style {
    if (!self.currentItem || [self.items count] == 0) {
        return;
    }
    NSUInteger indexOfDisItem = [self.items indexOfObject:self.currentItem];
    if (indexOfDisItem == NSNotFound) {
        return;
    }
    
    ZZWebViewItem *targetItem = nil;
    ZZWebViewItem *disItem = self.currentItem;
    
    if (indexOfDisItem > 0) {
        targetItem = [self.items objectAtIndex:indexOfDisItem - 1];
    }
    NSMutableArray *arrDeletes = [[NSMutableArray alloc] init];
    for (NSUInteger index = indexOfDisItem ; index < self.items.count; index ++) {
        ZZWebViewItem *current = self.items[index];
        if (current != targetItem && current != disItem) {
            [current destoryView];
        }
        if (current != targetItem) {
            [arrDeletes addObject:current];
        }
    }
    self.currentItem = targetItem;
    [self.items removeObjectsInArray:arrDeletes];
    if (style == ZZWebViewPresentStylePush) {
        [ZZWebViewAnimatable popItem:targetItem atCurrentItem:disItem andBaseView:self.baseView completion:^(BOOL finish) {
            [disItem destoryView];
        }];
    } else {
        [ZZWebViewAnimatable dismissItem:targetItem atCurrentItem:disItem andBaseView:self.baseView completion:^(BOOL finish) {
            [disItem destoryView];
        }];
    }
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
