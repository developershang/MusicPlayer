//
//  LyricModel.h
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/15.
//  Copyright © 2016年 shang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ListModel;
@interface LyricModel : NSObject

//歌词属性
@property (nonatomic, copy)NSString *lyric;

//歌词对应的时间属性
@property (nonatomic, assign)float time;

/*
 * 重写初始化方法
 *
 */

//instancetype 自动返回当前类

- (LyricModel *)initWithLyric:(NSString *)lyric
                         time:(float)time;

@end
