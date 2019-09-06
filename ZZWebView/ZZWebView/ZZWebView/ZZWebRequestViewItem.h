//
//  ZZWebRequestViewItem.h
//  ZZWebView
//
//  Created by developer on 2019/9/6.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZWebViewItem.h"

@interface ZZWebRequestViewItem : ZZWebViewItem
- (ZZWebRequestViewItem *)initWithRequest: (NSURLRequest *)request;
@end

