//
//  ZZWebViewFileURLItem.h
//  ZZWebView
//
//  Created by developer on 2019/9/6.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebViewItem.h"

NS_ASSUME_NONNULL_BEGIN
@interface ZZWebViewFileURLItem : ZZWebViewItem
- (ZZWebViewFileURLItem *)initWithFile: (NSURL *)url allowingReadAccessToURL: (NSURL *)readAccessURL;
@end
NS_ASSUME_NONNULL_END
