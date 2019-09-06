//
//  ZZWebViewItem.h
//  ZZWebView
//
//  Created by developer on 2019/9/5.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class ZZWebViewItem;

@protocol ZZWebViewItemCycleDelegate <NSObject>
- (void)onLoadSuccess: (ZZWebViewItem *)webItem;
- (void)onLoadFail: (ZZWebViewItem *)webItem;
- (void)onClose: (ZZWebViewItem *)webItem;
@end

@protocol ZZWebViewItemNewFrameDelegate <NSObject>
- (void)createNewWebViewWith:(WKWebViewConfiguration *)configuration fromWebItem:(ZZWebViewItem *)webItem targetURL:(NSString *)targetURL;
@end

@protocol ZZWebViewItemLinkDelegate <NSObject>
- (void)linkFromWebItem:(ZZWebViewItem *)item toURL:(NSString *)toURL;
@end

@protocol ZZWebViewItemAlertDelegate <NSObject>
// TODO: Alert panel should call delegate
@end

typedef  void (^ZZWebViewMessageHandlerCallback)(ZZWebViewItem *, NSString *, id);

@interface ZZWebViewItem : NSObject<WKUIDelegate, WKNavigationDelegate>

@property(nonatomic, copy)NSString* urlString;
@property(nonatomic, assign)BOOL canCrossDomain;
@property(nonatomic, strong, readonly)NSDictionary *headers;
@property(nonatomic, strong, readonly)NSDictionary *extraCookies;
@property(nonatomic, strong, readonly)NSDictionary *registCallBacks;
@property(nonatomic, strong, readonly)NSArray *allPreUserScripts;
@property(nonatomic, strong, readonly)NSArray *allPostUserScripts;
@property(nonatomic, strong) NSArray<NSString *> *allowDomain;
@property(nonatomic, weak) id<ZZWebViewItemNewFrameDelegate> frameDelegate;
@property(nonatomic, weak) id<ZZWebViewItemLinkDelegate> linkerDelegate;
@property(nonatomic, weak) id<ZZWebViewItemCycleDelegate> cycleDelegate;

- (void)addLoadedScript:(NSString *)jsCode;

- (void)addBeforeLoadScript:(NSString *)jsCode;

- (void)removeScript;

- (void)setRequestHeader:(NSString *)value forKey:(NSString *)key;

- (void)addCookie:(NSString *)value forKey:(NSString *)key;

- (void)registName:(NSString *)name forCallBack:(ZZWebViewMessageHandlerCallback)callBack;

- (void)removeRegistName:(NSString *)name;

- (void)addAllowDomain:(NSString *)domain;

- (void)createView;

- (UIView *)getZWebView;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL API_AVAILABLE(macosx(10.11), ios(9.0));

- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL API_AVAILABLE(macosx(10.11), ios(9.0));
@end

