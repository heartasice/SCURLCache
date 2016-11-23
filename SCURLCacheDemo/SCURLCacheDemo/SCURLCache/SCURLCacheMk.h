//  Created by daiming on 2016/11/11.

#import <UIKit/UIKit.h>
#import "SCURLCacheModel.h"

@interface SCURLCacheMk : NSObject

@property (nonatomic, strong) SCURLCacheModel *cModel;

- (SCURLCacheMk *(^)(NSUInteger)) memoryCapacity;   //内存容量
- (SCURLCacheMk *(^)(NSUInteger)) diskCapacity;     //本地存储容量
- (SCURLCacheMk *(^)(NSUInteger)) cacheTime;        //缓存时间
- (SCURLCacheMk *(^)(NSString *)) subDirectory;     //子目录
- (SCURLCacheMk *(^)(BOOL)) isDownloadMode;         //是否启动下载模式
- (SCURLCacheMk *(^)(NSArray *)) whiteListsHost;    //域名白名单
- (SCURLCacheMk *(^)(NSString *)) whiteUserAgent;   //WebView的user-agent白名单

- (SCURLCacheMk *(^)(NSString *)) addHostWhiteList;        //添加一个域名白名单
- (SCURLCacheMk *(^)(NSString *)) addRequestUrlWhiteList;  //添加请求白名单

//NSURLProtocol相关设置
- (SCURLCacheMk *(^)(BOOL)) isUsingURLProtocol; //是否使用NSURLProtocol，默认使用NSURLCache



@end
