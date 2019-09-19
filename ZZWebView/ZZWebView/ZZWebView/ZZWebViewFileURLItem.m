//
//  ZZWebViewFileURLItem.m
//  ZZWebView
//
//  Created by developer on 2019/9/6.
//  Copyright © 2019 Nextop. All rights reserved.
//

#import "ZZWebViewFileURLItem.h"
@interface ZZWebViewFileURLItem()
@property(nonatomic, strong)NSURL *fileURL;
@property(nonatomic, strong)NSURL *accessURL;
@end
@implementation ZZWebViewFileURLItem
- (ZZWebViewFileURLItem *)initWithFile:(NSURL *)url allowingReadAccessToURL:(NSURL *)readAccessURL {
    if(self = [super init]) {
        _fileURL = url;
        _accessURL = readAccessURL;
    }
    return self;
}

- (void)load {
    [self loadFileURL:self.fileURL allowingReadAccessToURL:self.accessURL];
}
@end
