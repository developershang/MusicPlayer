//
//  LyricModel.m
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/15.
//  Copyright © 2016年 shang. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel



- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

#pragma mark 初始化
-(LyricModel *)initWithLyric:(NSString *)lyric time:(float)time{
    
    self = [super init];
    if (self) {
        
     self.lyric = lyric;
     self.time = time;   
    }
    return self;
    
}










@end
