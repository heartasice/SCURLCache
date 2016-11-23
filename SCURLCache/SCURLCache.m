//  Created by daiming on 2016/11/11. 

#import "SCURLCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "SCURLProtocol.h"

@interface SCURLCache()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *wbView; //用于预加载的webview
@property (nonatomic, strong) NSMutableArray *preLoadWebUrls; //预加载的webview的url列表

@end

@implementation SCURLCache
#pragma mark - Interface
+ (SCURLCache *)create:(void (^)(SCURLCacheMk *))mk {
    SCURLCache *c = [[self alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    SCURLCacheMk *cMk = [[SCURLCacheMk alloc] init];
    cMk.isDownloadMode(YES);
    mk(cMk);
    c.mk = cMk;
    c = [c configWithMk];
    return c;
}

- (SCURLCache *)configWithMk {
    
    self.mk.cModel.isSavedOnDisk = YES;
    
    if (self.mk.cModel.isUsingURLProtocol) {
        SCURLCacheModel *sModel = [SCURLCacheModel shareInstance];
        sModel.cacheTime = self.mk.cModel.cacheTime;
        sModel.diskCapacity = self.mk.cModel.diskCapacity;
        sModel.diskPath = self.mk.cModel.diskPath;
        sModel.cacheFolder = self.mk.cModel.cacheFolder;
        sModel.subDirectory = self.mk.cModel.subDirectory;
        sModel.whiteUserAgent = self.mk.cModel.whiteUserAgent;
        sModel.whiteListsHost = self.mk.cModel.whiteListsHost;
        [NSURLProtocol registerClass:[SCURLProtocol class]];
    } else {
        [NSURLCache setSharedURLCache:self];
    }
    return self;
}

- (SCURLCache *)update:(void (^)(SCURLCacheMk *))mk {
    mk(self.mk);
    [self configWithMk];
    return self;
}

- (void)stop {
    
    if (self.mk.cModel.isUsingURLProtocol) {
        [NSURLProtocol unregisterClass:[SCURLProtocol class]];
    } else {
        NSURLCache *c = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
        [NSURLCache setSharedURLCache:c];
    }
    [self.mk.cModel checkCapacity];
}

#pragma mark - Interface PreLoad by Webview
- (SCURLCache *)preLoadByWebViewWithUrls:(NSArray *)urls {
    if (!(urls.count > 0)) {
        return self;
    }
    self.wbView = [[UIWebView alloc] init];
    self.wbView.delegate = self;
    self.preLoadWebUrls = [NSMutableArray arrayWithArray:urls];
    [self requestWebWithFirstPreUrl];
    return self;
}
//web view delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.preLoadWebUrls.count > 0) {
        [self.preLoadWebUrls removeObjectAtIndex:0];
        [self requestWebWithFirstPreUrl];
        if (self.preLoadWebUrls.count == 0) {
            self.wbView = nil;
            [self stop];
        }
    } else {
        self.wbView = nil;
        [self stop];
    }
}
- (void)requestWebWithFirstPreUrl {
    NSURLRequest *re = [NSURLRequest requestWithURL:[NSURL URLWithString:self.preLoadWebUrls.firstObject]];
    [self.wbView loadRequest:re];
}

#pragma mark - Interface Preload by Request
- (SCURLCache *)preLoadByRequestWithUrls:(NSArray *)urls {
    NSUInteger i = 1;
    for (NSString *urlString in urls) {
        NSMutableURLRequest *re = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        re.HTTPMethod = @"GET";
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:re completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        }];
        [task resume];
        i++;
    }
    
    return self;
}


#pragma mark - NSURLCache Method
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    SCURLCacheModel *cModel = self.mk.cModel;
    //对于模式的过滤
    if (!cModel.isDownloadMode) {
        return nil;
    }
    //对于域名白名单的过滤
    if (self.mk.cModel.whiteListsHost.count > 0) {
        id isExist = [self.mk.cModel.whiteListsHost objectForKey:[self hostFromRequest:request]];
        if (!isExist) {
            return nil;
        }
    }
    //只允许GET方法通过
    if ([request.HTTPMethod compare:@"GET"] != NSOrderedSame) {
        return nil;
    }
    //User-Agent来过滤
    if (self.mk.cModel.whiteUserAgent.length > 0) {
        NSString *uAgent = [request.allHTTPHeaderFields objectForKey:@"User-Agent"];
        if (uAgent) {
            if (![uAgent hasSuffix:self.mk.cModel.whiteUserAgent]) {
                return nil;
            }
        }
    }
    //开始缓存
    NSCachedURLResponse *cachedResponse =  [cModel localCacheResponeWithRequest:request];
    if (cachedResponse) {
        [self storeCachedResponse:cachedResponse forRequest:request];
        return cachedResponse;
    }
    return nil;
}

#pragma mark - Cache Capacity

- (void)removeCachedResponseForRequest:(NSURLRequest *)request {
    [super removeCachedResponseForRequest:request];
    [self.mk.cModel removeCacheFileWithRequest:request];
}
- (void)removeAllCachedResponses {
    [super removeAllCachedResponses];
}

#pragma mark - Helper
- (NSString *)hostFromRequest:(NSURLRequest *)request {
    return [NSString stringWithFormat:@"%@",request.URL.host];
}

#pragma mark - Life
- (void)dealloc {
    NSURLCache *c = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:c];
}

@end
