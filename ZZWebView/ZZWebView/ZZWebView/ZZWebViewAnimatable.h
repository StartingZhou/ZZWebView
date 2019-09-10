//
//  ZZWebViewAnimatable.h
//  ZZWebView
//
//  Created by developer on 2019/9/10.
//  Copyright © 2019 Nextop. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ZZWebViewItem.h"

@interface ZZWebViewAnimatable : NSObject
+ (void)pushItem:(nonnull ZZWebViewItem *)targetItem atCurrentItem:(nullable ZZWebViewItem *)currentItem andBaseView:(nonnull UIView *)baseView completion:(void (^)(BOOL)) completion;
+ (void)popItem:(nullable ZZWebViewItem *)targetItem atCurrentItem:(nonnull ZZWebViewItem *)currentItem andBaseView:(nonnull UIView *)baseView completion:(void(^)(BOOL)) completion;

+ (void)presentItem:(nonnull ZZWebViewItem *)targetItem andBaseView:(nonnull UIView *)baseView completion:(void (^)(BOOL)) completion;
+ (void)dismissItem:(nullable ZZWebViewItem *)targetItem atCurrentItem:(nonnull ZZWebViewItem *)currentItem andBaseView:(nonnull UIView *)baseView completion:(void(^)(BOOL)) completion;

+ (void)installItem:(nonnull ZZWebViewItem *)targetItem andBaseView:(nonnull UIView *)baseView completion:(void (^)(BOOL)) completion;
+ (void)uninstallItem:(nullable ZZWebViewItem *)targetItem atCurrentItem:(nonnull ZZWebViewItem *)currentItem andBaseView:(nonnull UIView *)baseView completion:(void (^)(BOOL)) completion;

+ (void)addAnimation:(nonnull ZZWebViewItem *)targetItem atCurrentItem:(nullable ZZWebViewItem *)currentItem andBaseView:(nonnull UIView *)baseView completion:(void(^)(BOOL)) completion;
+ (void)removeAnimaion:(nullable ZZWebViewItem *)targetItem atCurrentItem:(nonnull ZZWebViewItem *)currentItem andBaseView:(nonnull UIView *)baseView completion:(void(^)(BOOL)) completion;
@end

