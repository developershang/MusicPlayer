//
//  MusicPlayManger.h
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/14.
//  Copyright © 2016年 shang. All rights reserved.
//

/*
 * 用于管理音乐播放和相关操作
 */


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ListModel.h"
@class ListModel;


@protocol AVplayerProtocol <NSObject>

/**    播放过程中一直执行
 *@param  播放进度
 *@return
 */
- (void)playerPlayingWinthProgress:(float)progress;

- (void)playEndTotime;

@end



@interface MusicPlayManger : NSObject
/**
 *@param  单例
 *@return 管理
 */
@property (nonatomic, assign)BOOL state; //记录播放状态
@property (nonatomic, assign)id<AVplayerProtocol>playDelegate;
@property (nonatomic, assign) float vloum;

+(instancetype)shareInstance;

/**
 *@param  model 音乐模型
 *@return 设置唱片
 */

- (void)prePareToplayerWithModel:(ListModel *)model;

//播放
- (void)play;
//暂停
- (void)pause;
//停止
- (void)stop;


/**
 *@param  声音的值
 *@return float
 */

- (void)setVloum:(float)vloum;
/**
 *@param  从指定的时间进行播放
 *@return 
 */
- (void)seekTimeToPlay:(float)value;




@end
