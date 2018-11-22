//
//  ViewController.m
//  CSVFileText
//
//  Created by 栗子 on 2018/11/21.
//  Copyright © 2018年 http://www.cnblogs.com/Lrx-lizi/    https://github.com/lrxlizi/     https://blog.csdn.net/qq_33608748. All rights reserved.
//

#import "ViewController.h"
#import "CSVFileManager.h"
#import "CSVFileModel.h"

@interface ViewController ()

@property(nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)writebtn:(id)sender {
    
    [CSVFileManager writeFile:@"scvtexts" dataSource:self.dataSource complete:^(NSString * _Nonnull result) {
    }];
}

- (IBAction)readBtn:(id)sender {
    NSString *path = [NSString stringWithFormat:@"%@",[CSVFileManager documentSandboxPath:@"scvtexts"]];//获取文件的路径
     NSArray *arr = [CSVFileManager readFileContent:path];//取出的内容用数组接收
    NSString *allData =@"";
    for (NSDictionary *dic in arr) {
        //字典转字符串
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        allData = [NSString stringWithFormat:@"%@\n%@",allData,str];
    }
    self.contentTV.text = allData;
    
}

- (IBAction)deleteBtn:(id)sender {
    [CSVFileManager deleteFile:@"scvtexts" successBlock:^{
        self.contentTV.text = @"";
    } failureBlock:^{
        
    }];
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:[CSVFileModel willSaveData]];
    }
    return _dataSource;
}

@end
