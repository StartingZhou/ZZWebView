//
//  ZZWebViewDataItem.m
//  ZZWebView
//
//  Created by developer on 2019/9/6.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebViewDataItem.h"
@interface ZZWebViewDataItem()
@property(nonatomic, strong) NSData* data;
@property(nonatomic, strong) NSString* MIMEType;
@property(nonatomic, strong) NSString* encodeName;
@property(nonatomic, strong) NSURL* baseURL;
@end
@implementation ZZWebViewDataItem
- (ZZWebViewDataItem *)initWithData: (NSData *)data MIMEType:(NSString *)MIMEType encodingName: (NSString *) encodeName  baseURL: (NSURL *)baseURL {
    if (self = [super init]) {
        _data = data;
        _MIMEType = MIMEType;
        _encodeName = encodeName;
        _baseURL = baseURL;
    }
    return self;
}

- (void)load {
    [self loadData:self.data MIMEType:self.MIMEType characterEncodingName:self.encodeName baseURL:self.baseURL];
}
@end
