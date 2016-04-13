//
//  LyricManager.h
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/15.
//  Copyright © 2016年 shang. All rights reserved.
//

/*
 * 处理歌词
 */
#import <Foundation/Foundation.h>
@class ListModel;
@class LyricModel;
@interface LyricManager : NSObject

/**解析歌词
 *@param  model 歌曲模型
 *@return void
 */

- (void)initLyricWithModel:(ListModel *)moodel;


+(instancetype)shareInstance;
/**
 *@param  NSInteger
 *@return 返回个数
 */

//返回数组个数
-(NSInteger)countOfArray;


//根据下标返回模型
- (LyricModel *)modelAtIndex:(NSInteger)index;

/**
 *@param  播放时间
 *@return nsinteger 应该显示歌词下标
 */

-(NSInteger)indexForProgress:(float)progress;

@end
