//
//  CSVFileModel.m
//  CSVFileText
//
//  Created by 栗子 on 2018/11/22.
//  Copyright © 2018年 http://www.cnblogs.com/Lrx-lizi/    https://github.com/lrxlizi/     https://blog.csdn.net/qq_33608748. All rights reserved.
//

#import "CSVFileModel.h"

@implementation CSVFileModel

+(NSArray *)willSaveData{
    
    NSMutableArray *dataSource = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        NSString *name = [NSString stringWithFormat:@"%d小明",i];
        NSString *age  = [NSString stringWithFormat:@"%d",i+10];
        NSString *sex  = [NSString stringWithFormat:@"男"];
        if (i==0) {
            name = @"姓名";
            age = @"年龄";
            sex = @"性别";
        }
        NSDictionary *dic = @{@"name":name,
                              @"age" :age,
                              @"sex" :sex
                              };
        [dataSource addObject:dic];
    }
    
    return dataSource;
}

@end
