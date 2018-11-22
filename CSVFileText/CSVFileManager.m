//
//  CSVFileManager.m
//  CSVFileText
//
//  Created by 栗子 on 2018/11/21.
//  Copyright © 2018年 http://www.cnblogs.com/Lrx-lizi/    https://github.com/lrxlizi/     https://blog.csdn.net/qq_33608748. All rights reserved.
//

#import "CSVFileManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CSVFileManager


/**
 * 在沙盒cache目录下创建一个文件夹
 * @param name 文件夹的名字
 * @return     文件夹的路径
 */
+(NSString *)createCacheFile:(NSString *)name{
    
    NSString *filePathStr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    filePathStr = [NSString stringWithFormat:@"%@/%@",filePathStr,name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePathStr]) {//判断该文件夹是否存在
        [fileManager createDirectoryAtPath:filePathStr withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePathStr;
    
}

/**
 * 生成本地文件的路径
 * @param name 文件的名字
 * @return     文件的沙盒路径
 */
+ (NSString *)documentSandboxPath:(NSString *)name{
    //对name加密
    NSString *encryName  = [self md5Encryption:name];
    NSString *documentPath  = [self createCacheFile:name];
    NSString *path = [NSString stringWithFormat:@"%@/%@.csv",documentPath,encryName];
    return path;
    
}

/**
 * 读取文件里的内容
 * @param filePath 传入路径(沙盒路径)
 * return          文件里的内容
 */
+(NSArray *)readFileContent:(NSString *)filePath{
    NSMutableArray *array = [NSMutableArray array];
    NSString *filepath=filePath;
    FILE *fp = fopen([filepath UTF8String], "r");
    if (fp) {
        char buf[BUFSIZ];
        fgets(buf, BUFSIZ, fp);
        NSString *a = [[NSString alloc] initWithUTF8String:(const char *)buf];
        NSString *aa = [a stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        aa = [aa stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //获取的是表头的字段
        NSArray *b = [aa componentsSeparatedByString:@","];
        
        while (!feof(fp)) {
            char buff[BUFSIZ];
            fgets(buff, BUFSIZ, fp);
            //获取的是内容
            NSString *s = [[NSString alloc] initWithUTF8String:(const char *)buff];
            NSString *ss = [s stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            ss = [ss stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSArray *a = [ss componentsSeparatedByString:@","];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (int i = 0; i < b.count ; i ++) {
                //组成字典数组
                dic[b[i]] = a[i];
            }
            
            [array addObject:dic];
        }
    }
    return array;
}


/**
 * 写入文件
 * @param name    文件的名字
 * @param arr     待写入的数据
 * @param success 写完成功回调
*/
+ (void)writeFile:(NSString *)name dataSource:(NSArray *)arr complete:(stringBlock)success{
    
    NSString *csvPath = [self documentSandboxPath:name];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self exportCsv:csvPath dataSource:arr success:^{
            success(csvPath);
        }];
    });
    
}
/**
 * 将数据 写入文件
 * @param filename 文件路径(沙盒路径)
 * @param arr      待写入的数据
 * @param success  完成回调
 */
+ (void)exportCsv:(NSString*)filename dataSource:(NSArray *)arr  success:(voidBlock)success
{
    NSOutputStream* output = [[NSOutputStream alloc] initToFileAtPath: filename append: YES];
    [output open];
    if (![output hasSpaceAvailable])
    {
        NSLog(@"No space available in %@", filename);
    }else
    {
        for (int i = 0; i < arr.count; i++)
        {
            NSDictionary *dic = arr[i];
            NSString *name = [NSString stringWithFormat:@"%@",dic[@"name"]];
            NSString *age  = [NSString stringWithFormat:@"%@",dic[@"age"]];
            NSString *sex  = [NSString stringWithFormat:@"%@",dic[@"sex"]];
            
            NSString  *str = [[NSString alloc]initWithFormat:@"%@,%@,%@\n",name,age,sex];
            if (i == arr.count - 1)
            {
                 str  = [[NSString alloc]initWithFormat:@"%@,%@,%@",name,age,sex];
            }
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [output write:data.bytes maxLength:data.length];
        }
    }
    [output close];
    success();
}

/**
 * 删除指定的文件
 * @param name 文件名称
 * succ        删除成功Block
 * failure     删除失败Block
 */
+(void)deleteFile:(NSString *)name successBlock:(voidBlock)succ failureBlock:(voidBlock)failure{
    NSString *pathString = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    pathString = [NSString stringWithFormat:@"%@/%@",pathString,name];
    BOOL isExist = [[NSFileManager defaultManager]fileExistsAtPath:pathString];
    if (isExist) {
        NSFileManager *files = [NSFileManager defaultManager];
        if ([files removeItemAtPath:pathString error:nil]) {
            succ();
        }
    }else{
        failure();
    }
    
}

/**
 * md5加密
 * @param str 要加密的字符串
 * @return    加密后的串
 */
+ (NSString *)md5Encryption:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr,(CC_LONG)strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

@end
