//
//  ZZWebViewAnimatable.m
//  ZZWebView
//
//  Created by developer on 2019/9/10.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebViewAnimatable.h"
#import "ZZWebViewItem.h"

#define POPITEMFRAMERATIO 3
#define ANIMATIONDURATION 0.4
#define ANIMATIONDELAY 0

@implementation ZZWebViewAnimatable
+ (void)pushItem:(ZZWebViewItem *)targetItem atCurrentItem:(ZZWebViewItem *)currentItem andBaseView:(UIView *)baseView completion:(void (^)(BOOL)) completion {
    CGRect pushItemFromFrame = CGRectMake(baseView.frame.size.width, 0, baseView.frame.size.width, baseView.frame.size.height);
    CGRect pushItemFrame = CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height);
    CGRect currentItemFrame = CGRectMake(- baseView.frame.size.width / POPITEMFRAMERATIO, 0, baseView.frame.size.width, baseView.frame.size.height);
    UIView *pushView = [targetItem getZWebView];
    UIView *currentView = [currentItem getZWebView];
    pushView.frame = pushItemFromFrame;
    [UIView animateWithDuration:ANIMATIONDURATION delay:ANIMATIONDELAY options:UIViewAnimationOptionCurveEaseOut animations:^{
        pushView.frame = pushItemFrame;
        if (currentView) {
            currentView.frame = currentItemFrame;
        }
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

+ (void)popItem:(ZZWebViewItem *)targetItem atCurrentItem:(ZZWebViewItem *)currentItem andBaseView:(UIView *)baseView completion:(void(^)(BOOL)) completion {
    CGRect popItemFromFrame = CGRectMake(- baseView.frame.size.width / POPITEMFRAMERATIO, 0, baseView.frame.size.width, baseView.frame.size.height);
    CGRect popItemFrame = CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height);
    CGRect currentItemFrame = CGRectMake(baseView.frame.size.width , 0, baseView.frame.size.width, baseView.frame.size.height);
    UIView *popView = [targetItem getZWebView];
    UIView *currentView = [currentItem getZWebView];
    popView.frame = popItemFromFrame;
    [UIView animateWithDuration:ANIMATIONDURATION delay:ANIMATIONDELAY options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (popView) {
            popView.frame = popItemFrame;
        }
        currentView.frame = currentItemFrame;
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

+ (void)presentItem:(ZZWebViewItem *)targetItem andBaseView:(UIView *)baseView completion:(void (^)(BOOL)) completion {
    CGRect presentItemFromFrame = CGRectMake(0, baseView.frame.size.height, baseView.frame.size.width, baseView.frame.size.height);
    CGRect presentItemFrame = CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height);
    UIView *presentView = [targetItem getZWebView];
    presentView.frame = presentItemFromFrame;
    [UIView animateWithDuration:ANIMATIONDURATION delay:ANIMATIONDELAY options:UIViewAnimationOptionCurveEaseOut animations:^{
        presentView.frame = presentItemFrame;
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

+ (void)dismissItem:(ZZWebViewItem *)targetItem atCurrentItem:(ZZWebViewItem *)currentItem andBaseView:(UIView *)baseView completion:(void(^)(BOOL)) completion {
    CGRect targetItemFrame = CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height);
    CGRect currentItemFrame = CGRectMake(0 , baseView.frame.size.height, baseView.frame.size.width, baseView.frame.size.height);
    UIView *targetView = [targetItem getZWebView];
    UIView *currentView = [currentItem getZWebView];
    [UIView animateWithDuration:ANIMATIONDURATION delay:ANIMATIONDELAY options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (targetView) {
            targetView.frame = targetItemFrame;
        }
        currentView.frame = currentItemFrame;
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

+ (void)installItem:(ZZWebViewItem *)targetItem andBaseView:(UIView *)baseView completion:(void (^)(BOOL)) completion {
    UIView *targetView = [targetItem getZWebView];
    targetView.frame = CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height);
    completion(true);
}

+ (void)uninstallItem:(ZZWebViewItem *)targetItem atCurrentItem:(ZZWebViewItem *)currentItem andBaseView:(UIView *)baseView completion:(void (^)(BOOL)) completion {
    UIView *targetView = [targetItem getZWebView];
    UIView *currentView = [currentItem getZWebView];
    currentView.frame = CGRectMake(0, baseView.frame.size.width, baseView.frame.size.width, baseView.frame.size.height);
    targetView.frame = CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height);
    completion(true);
}

+ (void)addAnimation:(ZZWebViewItem *)targetItem atCurrentItem:(ZZWebViewItem *)currentItem andBaseView:(UIView *)baseView completion:(void(^)(BOOL)) completion {
    if (targetItem.presentStyle == ZZWebViewPresentStylePush) {
        [self pushItem:targetItem atCurrentItem:currentItem andBaseView:baseView completion:completion];
    } else if (targetItem.presentStyle == ZZWebViewPresentStylePresent) {
        [self presentItem:targetItem andBaseView:baseView completion:completion];
    } else {
        [self installItem:targetItem andBaseView:baseView completion:completion];
    }
}

+ (void)removeAnimaion:(ZZWebViewItem *)targetItem atCurrentItem:(ZZWebViewItem *)currentItem andBaseView:(UIView *)baseView completion:(void(^)(BOOL)) completion {
    if (currentItem.presentStyle == ZZWebViewPresentStylePush) {
        [self popItem:targetItem atCurrentItem:currentItem andBaseView:baseView completion:completion];
    } else if (currentItem.presentStyle == ZZWebViewPresentStylePresent) {
        [self dismissItem:targetItem atCurrentItem:currentItem andBaseView:baseView completion:completion];
    } else {
        [self uninstallItem:targetItem atCurrentItem:currentItem andBaseView:baseView completion:completion];
    }
}

@end
