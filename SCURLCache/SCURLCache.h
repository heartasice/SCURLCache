//  Created by daiming on 2016/11/11.
/*
 功能：缓存网络请求
 */

#import <Foundation/Foundation.h>
#import "SCURLCacheMk.h"

@interface SCURLCache : NSURLCache

@property (nonatomic, strong) SCURLCacheMk *mk;

+ (SCURLCache *)create:(void(^)(SCURLCacheMk *mk))mk;  //初始化并开启缓存
- (SCURLCache *)update:(void (^)(SCURLCacheMk *mk))mk;

- (SCURLCache *)preLoadByWebViewWithUrls:(NSArray *)urls; //使用WebView进行预加载缓存
- (SCURLCache *)preLoadByRequestWithUrls:(NSArray *)urls; //使用
- (void)stop; //关闭缓存

@end
