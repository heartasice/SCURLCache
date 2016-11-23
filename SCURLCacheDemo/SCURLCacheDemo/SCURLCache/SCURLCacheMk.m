//  Created by daiming on 2016/11/11.

#import "SCURLCacheMk.h"

@interface SCURLCacheMk()

@end

@implementation SCURLCacheMk

- (instancetype)init {
    if (self = [super init]) {
        self.cModel = [[SCURLCacheModel alloc] init];
    }
    return self;
}
- (SCURLCacheMk *(^)(NSString *)) whiteUserAgent {
    return ^SCURLCacheMk *(NSString *v) {
        self.cModel.whiteUserAgent = v;
        UIWebView *wb = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString *defaultAgent = [wb stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *agentForWhite = [defaultAgent stringByAppendingString:v];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:agentForWhite, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        return self;
    };
}
- (SCURLCacheMk *(^)(NSString *))addRequestUrlWhiteList {
    return ^SCURLCacheMk *(NSString *v) {
        [self.cModel.whiteListsRequestUrl setObject:[NSNumber numberWithBool:TRUE] forKey:v];
        return self;
    };
}

- (SCURLCacheMk *(^)(NSString *))addHostWhiteList {
    return ^SCURLCacheMk *(NSString *v) {
        [self.cModel.whiteListsHost setObject:[NSNumber numberWithBool:TRUE] forKey:v];
        return self;
    };
}
- (SCURLCacheMk *(^)(NSUInteger))memoryCapacity {
    return ^SCURLCacheMk *(NSUInteger v) {
        self.cModel.memoryCapacity = v;
        return self;
    };
}
- (SCURLCacheMk *(^)(NSUInteger))diskCapacity {
    return ^SCURLCacheMk *(NSUInteger v) {
        self.cModel.diskCapacity = v;
        return self;
    };
}

- (SCURLCacheMk *(^)(NSUInteger))cacheTime {
    return ^SCURLCacheMk *(NSUInteger v) {
        self.cModel.cacheTime = v;
        return self;
    };
}
- (SCURLCacheMk *(^)(NSString *))subDirectory {
    return ^SCURLCacheMk *(NSString *v) {
        self.cModel.subDirectory = v;
        return self;
    };
}
- (SCURLCacheMk *(^)(NSArray *))whiteListsHost {
    return ^SCURLCacheMk *(NSArray *v) {
        if (v.count > 0) {
            for (NSString *aV in v) {
                [self.cModel.whiteListsHost setObject:[NSNumber numberWithBool:YES] forKey:aV];
            }
        }
        return self;
    };
}
- (SCURLCacheMk *(^)(BOOL)) isDownloadMode {
    return ^SCURLCacheMk *(BOOL v) {
        self.cModel.isDownloadMode = v;
        return self;
    };
}
- (SCURLCacheMk *(^)(BOOL)) isUsingURLProtocol {
    return ^SCURLCacheMk *(BOOL v) {
        self.cModel.isUsingURLProtocol = v;
        return self;
    };
}

@end
