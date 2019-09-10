//
//  ZZWebViewManager.h
//  ZZWebView
//
//  Created by developer on 2019/9/5.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ZZWebViewItem.h"
#import "ZZWebViewAnimatable.h"
@class ZZWebViewManager;


@protocol ZZWebViewManagerDelegate <NSObject>
- (BOOL)manager:(nonnull ZZWebViewManager *) manager shouldRedirectFrom:(nonnull ZZWebViewItem *)item toURL:(nonnull NSString *)url;
- (nullable ZZWebViewItem *)manager:(nonnull ZZWebViewManager *) manager ShouldCreateNewPage:(nonnull ZZWebViewItem *) ofItem with:(nonnull WKWebViewConfiguration *)config to:(nonnull NSString *)url;
- (void)manager:(nonnull ZZWebViewManager *)manager beginLoadItem:(nonnull ZZWebViewItem *)item;
- (void)manager:(nonnull ZZWebViewManager *)manager failLoadItem:(nonnull ZZWebViewItem *)item error: (nonnull NSError *)error;
- (void)manager:(nonnull ZZWebViewManager *)manager finishLoadItem:(nonnull ZZWebViewItem *)item;
- (void)manager:(nonnull ZZWebViewManager *)manager progressChange:(nonnull NSString *)progress;
@end
NS_ASSUME_NONNULL_BEGIN
@interface ZZWebViewManager : NSObject

@property(nonatomic, assign)NSInteger maxCaches;
@property(nonatomic, weak) id<ZZWebViewManagerDelegate> delegate;

+ (ZZWebViewManager *)managerWithView:(UIView *)view;

- (void)loadItem:(ZZWebViewItem *)item;

- (ZZWebViewItem *)loadRequest:(NSURLRequest *)request;
- (ZZWebViewItem *)loadRequest:(NSURLRequest *)request withStyle: (ZZWebViewPresentStyle) style;

- (ZZWebViewItem *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL API_AVAILABLE(macosx(10.11), ios(9.0));
- (ZZWebViewItem *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL withStyle: (ZZWebViewPresentStyle) style API_AVAILABLE(macosx(10.11), ios(9.0));

- (ZZWebViewItem *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
- (ZZWebViewItem *)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL withStyle: (ZZWebViewPresentStyle) style;

- (ZZWebViewItem *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL API_AVAILABLE(macosx(10.11), ios(9.0));
- (ZZWebViewItem *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL withStyle: (ZZWebViewPresentStyle) style API_AVAILABLE(macosx(10.11), ios(9.0));

- (void)popToItem:(ZZWebViewItem *)item;
- (void)popItem;
- (void)popToRootItem;
- (void)dismissItem;

- (nullable ZZWebViewItem *)goBack;

- (nullable ZZWebViewItem *)current;

- (nullable ZZWebViewItem *)goForward;

- (BOOL)reload;

@end
NS_ASSUME_NONNULL_END
