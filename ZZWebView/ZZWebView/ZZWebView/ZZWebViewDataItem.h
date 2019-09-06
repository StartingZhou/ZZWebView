//
//  ZZWebViewDataItem.h
//  ZZWebView
//
//  Created by developer on 2019/9/6.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebViewItem.h"
NS_ASSUME_NONNULL_BEGIN
@interface ZZWebViewDataItem : ZZWebViewItem
- (ZZWebViewDataItem *)initWithData: (NSData *)data MIMEType:(NSString *)MIMEType encodingName: (NSString *) encodeName  baseURL: (NSURL *)baseURL;
@end
NS_ASSUME_NONNULL_END
