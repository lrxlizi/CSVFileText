//
//  CSVFileManager.h
//  CSVFileText
//
//  Created by 栗子 on 2018/11/21.
//  Copyright © 2018年 http://www.cnblogs.com/Lrx-lizi/    https://github.com/lrxlizi/     https://blog.csdn.net/qq_33608748. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^stringBlock) (NSString *result);
typedef void(^voidBlock)(void);

@interface CSVFileManager : NSObject

/**
 * 在沙盒cache目录下创建一个文件夹
 * @param name 文件夹的名字
 * @return     文件夹的路径
 */
+(NSString *)createCacheFile:(NSString *)name;

/**
 * 生成本地文件的路径
 * @param name 文件的名字
 * @return     文件的沙盒路径
 */
+ (NSString *)documentSandboxPath:(NSString *)name;

/**
 * 读取文件里的内容
 * @param filePath 传入路径
 * return          文件里的内容
 */
+(NSArray *)readFileContent:(NSString *)filePath;
/**
 * 写入文件
 * @param name    文件的名字
 * @param arr     待写入的数据
 * @param success 写完成功回调
 */
+ (void)writeFile:(NSString *)name dataSource:(NSArray *)arr complete:(stringBlock)success;

/**
 * 将数据取出 写入文件
 * @param filename 文件路径
 * @param arr      待写入的数据
 * @param success  完成回调
 */
+ (void)exportCsv:(NSString*)filename dataSource:(NSArray *)arr  success:(voidBlock)success;

/**
  * 删除指定的文件
  * @param name 文件名称
  * succ        删除成功Block
  * failure     删除失败Block
  */
+(void)deleteFile:(NSString *)name successBlock:(voidBlock)succ failureBlock:(voidBlock)failure;

/**
 * md5加密
 * @param str 要加密的字符串
 * @return    加密后的串
 */
+ (NSString *)md5Encryption:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
