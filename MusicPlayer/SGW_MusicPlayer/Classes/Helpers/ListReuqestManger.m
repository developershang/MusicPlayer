//
//  ListReuqestManger.m
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/13.
//  Copyright © 2016年 shang. All rights reserved.
//

#import "ListReuqestManger.h"
#import "ListModel.h"

static ListReuqestManger *manger = nil;


@interface ListReuqestManger ()
//用来存放所有数据
@property (nonatomic, strong)NSMutableArray *modelsArrray;

@end



@implementation ListReuqestManger


#pragma mark - 单例初始化
+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger =[[ListReuqestManger alloc] init];
    });
    
    return manger;
}


#pragma mark - 数组初始化的懒加载
- (NSMutableArray *)modelsArrray{
    
    if (!_modelsArrray) {
        
        _modelsArrray = [NSMutableArray array];
    }
    return _modelsArrray;
}


#pragma mark - 数据url请求数据 - 数据处理
-(void)requestWithUrl:(NSString *)url didFinsh:(void(^)())finish{
    //开辟子线程请求数据，避免阻塞主线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //请求完毕数据才可以访问 在子线程中请求
        //真正开发先了解数据结构，这里已经知道数据结构是歌曲数组
      NSArray *dataArray = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:url]];
        //进行数据解析 保护性代码
        if (!dataArray) {
            return ;
        }
       //遍历数组 取出字典
        for (NSDictionary *dict in dataArray) {
            //创建模型
            ListModel *model = [[ListModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            //将模型存在数组
            [self.modelsArrray addObject:model];
        } 
        //回到主线程处理UI 刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            finish();
        });
 });
    
}


#pragma mark  - 返回数组个数
- (NSInteger)countOfArray{
    
    return self.modelsArrray.count;
}


#pragma mark - 根据下标返回模型
-(ListModel *)modelWinthIndex:(NSInteger)index{
    ListModel *model = self.modelsArrray[index];
    return model;
}


@end
