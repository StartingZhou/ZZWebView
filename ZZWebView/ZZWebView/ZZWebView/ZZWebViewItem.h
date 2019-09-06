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

typedef NS_ENUM(NSUInteger, ZZWebViewPresentStyle) {
    ZZWebViewPresentStylePresent,
    ZZWebViewPresentStylePush,
    ZZWebViewPresentStyleNone,
};
@protocol ZZWebViewItemCycleDelegate <NSObject>
- (void)onLoadSuccess: ( ZZWebViewItem * _Nonnull )webItem;
- (void)onLoadFail: ( ZZWebViewItem * _Nonnull )webItem;
- (void)onClose: ( ZZWebViewItem * _Nonnull )webItem;
@end

@protocol ZZWebViewItemNewFrameDelegate <NSObject>
- (void)createNewWebViewWith:(WKWebViewConfiguration *_Nonnull)configuration fromWebItem:(ZZWebViewItem *_Nonnull)webItem targetURL:(NSString *_Nonnull)targetURL;
@end

@protocol ZZWebViewItemLinkDelegate <NSObject>
- (BOOL)linkFromWebItem:(ZZWebViewItem *_Nonnull)item toURL:(NSString *_Nonnull)toURL;
@end

@protocol ZZWebViewItemAlertDelegate <NSObject>
// TODO: Alert panel should call delegate
@end

typedef  void (^ZZWebViewMessageHandlerCallback)(ZZWebViewItem *_Nonnull, NSString *_Nonnull, id _Nullable );
NS_ASSUME_NONNULL_BEGIN

@interface ZZWebViewItem : NSObject<WKUIDelegate, WKNavigationDelegate>

@property(nonatomic, copy)NSString* urlString;
@property(nonatomic, assign) ZZWebViewPresentStyle presentStyle;
@property(nonatomic, strong, readonly)NSDictionary *headers;
@property(nonatomic, strong, readonly)NSDictionary *extraCookies;
@property(nonatomic, strong, readonly)NSDictionary *registCallBacks;
@property(nonatomic, strong, readonly)NSArray *allPreUserScripts;
@property(nonatomic, strong, readonly)NSArray *allPostUserScripts;
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

- (void)createView;

- (void)createViewWithConfig:(nullable WKWebViewConfiguration *) config;

- (UIView *)getZWebView;

- (void)destoryView;

- (void)load;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL API_AVAILABLE(macosx(10.11), ios(9.0));

- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL API_AVAILABLE(macosx(10.11), ios(9.0));
@end
NS_ASSUME_NONNULL_END
