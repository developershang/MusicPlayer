//
//  MusicPlayManger.m
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/14.
//  Copyright © 2016年 shang. All rights reserved.
//

#import "MusicPlayManger.h"
static MusicPlayManger *manager = nil;


@interface MusicPlayManger ()

//播放器
@property (nonatomic, strong)AVPlayer *musicPlayer;



@end

NSTimer *timer;
@implementation MusicPlayManger

#pragma mark - 单例
+(instancetype)shareInstance{
    
    if (manager == nil) {
        manager = [[MusicPlayManger alloc] init];
    }
    return manager;
}



#pragma  mark- 初始化方法
-(instancetype)init{
   //设置播放状态为暂停
    self.state = NO;
    self.musicPlayer = [AVPlayer new];
    //默认的音量
    
    //音量属性赋值
    self.vloum = 0.5;
    self.musicPlayer.volume = 0.5;
 
    //注册一个通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    return self;
}




- (void)playEnd{
    if (self.playDelegate && [self.playDelegate respondsToSelector:@selector(playEndTotime)]) {
        [self.playDelegate playEndTotime];
    }

}


#pragma mark - 设置唱片 准备播放
-(void)prePareToplayerWithModel:(ListModel *)model{
    
    //获取音乐播放地址 创建唱片
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.mp3Url]];
    //.h 出引入为@class.m中也需要引入（提示）安全性判断
    [self.musicPlayer  replaceCurrentItemWithPlayerItem:item];
    
}

#pragma mark 播放
-(void)play{
    if (self.state) {
        return;
    }
   timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playing) userInfo:nil repeats:YES];
   [self.musicPlayer play];
    self.state = YES;
}

#pragma mark 播放过程中持续执行
-(void)playing {
    //播放过程中让代理操作UI
    //获取当前播放时间
    CGFloat seconds  = self.musicPlayer.currentTime.value / self.musicPlayer.currentTime.timescale;
    //让代理去执行协议方法
    if (self.playDelegate && [self.playDelegate respondsToSelector:@selector(playerPlayingWinthProgress:)]) {
          [self.playDelegate playerPlayingWinthProgress:seconds];
    }
}

#pragma mark 暂停
- (void)pause{
    if (!self.state) {
        return;
    }
    
    [timer invalidate];
     timer = nil;
    [self.musicPlayer pause];
     self.state = NO;
}


#pragma mark 停止
- (void)stop{
    
    [self.musicPlayer pause];
}


#pragma mark 调整音量
-(void)setVloum:(float)vloum{
    
    self.musicPlayer.volume = vloum;
}

#pragma mark 根据进度条播放歌曲
- (void)seekTimeToPlay:(float)value{
    [self pause];
  
    //当前需要播放的时间  //将比例value转化为播放timeValue
    CMTime timeValue =CMTimeMakeWithSeconds(value, self.musicPlayer.currentTime.timescale);
    //这里得到的是帧数
    //CMTime timeValue= CMTimeMake((int)value, self.musicPlayer.currentTime.timescale);
    
    [self.musicPlayer seekToTime:timeValue completionHandler:^(BOOL finished) {
        //再播放
        if (finished == YES) {
        [self play];
        }
    }];
    

    
}


@end
