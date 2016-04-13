//
//  LyricManager.m
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/15.
//  Copyright © 2016年 shang. All rights reserved.
//

#import "LyricManager.h"
#import "ListModel.h"
#import "LyricModel.h"
//@class只是告诉这是一个类，无法访问属性
//但是import可以访问属性 安全性不高,比如在.h中声明的时候，只是声明，不访问，@class声明一下就可以了，
//还可以防止循环引入的问题
static LyricManager *manager = nil;

@interface LyricManager ()

//用来存储数据模型
@property (nonatomic, strong)NSMutableArray *allDataArr;


@end



@implementation LyricManager


+(instancetype)shareInstance{
    
   static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LyricManager alloc] init];
     });
     return manager;
    
}

-(NSMutableArray *)allDataArr{
    
    if (!_allDataArr) {
        _allDataArr = [[NSMutableArray alloc] init];
    }
    return _allDataArr;
}


- (void)initLyricWithModel:(ListModel *)moodel{
   
    //先将数组中的数据删除掉， 否则一直增加
    [self.allDataArr removeAllObjects];//============
    //获取歌词
    NSString *sourceLyric = moodel.lyric;
    //将歌词切割成行
    NSArray *lyricArr = [sourceLyric componentsSeparatedByString:@"\n"];
    //将时间与歌词切割开

    for (NSString *item in lyricArr) {
        //根据“]”进行切割
        NSString *copyItem = item;
      
        if ([copyItem isEqualToString:@""]) {
            copyItem = @"[05:00]该句歌词为空";
        }
        
        NSArray *itemArr = [copyItem componentsSeparatedByString:@"]"];
            //创建模型，给模型赋值
            //对时间进行处理 转化成秒
        float seconds = [self FormateTime:[itemArr firstObject ]];
        NSString *lyric = [itemArr lastObject];
        //组建模型
        LyricModel *model = [[LyricModel alloc] initWithLyric:lyric time:seconds];
        //将创建的模型装入数组
        
        [self.allDataArr addObject:model];
            
    }
    
}




#pragma mark - 转化时间为秒
-(float)FormateTime:(NSString *)time{
    //[00:00
    NSString *str = [time substringFromIndex:1];
    NSArray *arr = [str componentsSeparatedByString:@":"];
    float s1 = [[arr firstObject] floatValue];
    float s2 = [[arr lastObject] floatValue];
    float s3 = s1*60 +s2;
    
    return s3;
 
}




-(NSInteger)countOfArray{
    return self.allDataArr.count;
    
}





- (LyricModel *)modelAtIndex:(NSInteger)index{
    
    LyricModel *model = self.allDataArr[index];
    
    return model;
}



-(NSInteger)indexForProgress:(float)progress{
        NSInteger result = 0;
    //取出模型数组,取出播放时间
    //将当前模型播放时间和当前时间进行对比
    //对比规则，前一句歌词< 当前播放时间 < 后一句歌词时间
    //取前一句显示
    for (int i = 0 ; i< self.allDataArr.count-1 ; i++) {
    //如果是最后一行，不做判断
        if (i == self.allDataArr.count -1) {
            return i;
        }
        
        LyricModel *model1 = self.allDataArr[i];
        LyricModel *model2 = self.allDataArr[i+1];
        float time1 = model1.time;
        float time2 = model2.time;
        
        if ((time1 < progress)&&(progress < time2)) {
            return i;
        }
    }
    
    
    
    
        return result;

}


@end
