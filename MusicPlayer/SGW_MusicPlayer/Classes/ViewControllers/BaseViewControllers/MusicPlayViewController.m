//
//  MusicPlayViewController.m
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/13.
//  Copyright © 2016年 shang. All rights reserved.
//

#import "MusicPlayViewController.h"
#import "MusicPlayManger.h"
#import "ListModel.h"
#import "LyricModel.h"
#import "LyricManager.h"
#import "ListReuqestManger.h"
#import "UIImageView+WebCache.h"



typedef enum {
    
    playModeLoopStyle = 0,
    playModeOrderStyle,
    playModeRandomStyle,
    
}PlayModeltyle;


@interface MusicPlayViewController ()<AVplayerProtocol,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *endLbel;
@property (weak, nonatomic) IBOutlet UIImageView *singerImgView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;
@property (weak, nonatomic) IBOutlet UISlider *timeprogressSlider;
@property (weak, nonatomic) IBOutlet UIButton *VoiceMinButtton;
@property (weak, nonatomic) IBOutlet UIButton *voiceMaxButton;
@property (weak, nonatomic) IBOutlet UISlider *voiceProgressSlider;
@property (weak, nonatomic) IBOutlet UIButton *lastMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *playMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *nextMusicButton;
@property (weak, nonatomic) IBOutlet UITableView *lyricTableview;
@property (nonatomic, assign)PlayModeltyle playStyle;






//当前播放歌曲的下标
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)NSTimer *timer;

@end

@implementation MusicPlayViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.singerImgView.layer.masksToBounds = YES;
   // navigationbar 默认是透明的，tableviw是从其上开始的，关闭了才是从旗下开始
  
    //让约束提前生效
    [self.singerImgView layoutIfNeeded];
    self.singerImgView.layer.cornerRadius =90;
    //CGRectGetHeight(self.singerImgView.frame)/2;
    //避免第一次选择的是第一首歌曲
    self.currentIndex = -1;
    //设置代理
    [MusicPlayManger shareInstance].playDelegate = self;
    //设置时间和voice的slider的最小值
    self.timeprogressSlider.minimumValue = 0.0;
    self.voiceProgressSlider.minimumValue =0.0;
    self.voiceProgressSlider.maximumValue = 1.0;
    self.voiceProgressSlider.value = [MusicPlayManger shareInstance].vloum;
    self.lyricTableview.delegate = self;
    self.lyricTableview.dataSource = self;
    [self.lyricTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"main_cell"];
    self.lyricTableview.separatorStyle  = UITableViewCellSeparatorStyleNone;
  
    self.playStyle = playModeRandomStyle;
    NSLog(@"view Did Load");
    

}


- (void)viewDidAppear:(BOOL)animated{
    
    //约束生效时间
    NSLog(@"view Did Apper");
    
}
#pragma mark - 实现协议方法
- (void)playerPlayingWinthProgress:(float)progress{
    //设置图片旋转
    /* [UIView beginAnimations:@"dsa" context:nil];
    [UIView setAnimationDuration:2];
    self.singerImgView.transform =CGAffineTransformRotate(self.singerImgView.transform, M_PI/180);
    [UIView commitAnimations]; */
    [UIView animateWithDuration:0.1 animations:^{
     self.singerImgView.transform =CGAffineTransformRotate(self.singerImgView.transform, M_PI/30);
    }];
    //设置进度条value
    self.timeprogressSlider.value = progress;
    //设置播放时间
    NSString *str = [NSString stringWithFormat:@"%02d:%02d",(int)progress/60,((int)progress%60)];
    self.beginLabel.text = str;
    //获取总时长
    ListModel *model = [[ListReuqestManger shareInstance]modelWinthIndex:_currentIndex];
    //设置剩余时间
     float res  =  [model.duration floatValue]/1000 - progress;
    NSString *str1 =  [NSString stringWithFormat:@"%02d:%02d",(int)res/60,((int)res%60)];
    self.endLbel.text = str1;
    //根据播放时间获取下标
    NSInteger index = [[LyricManager shareInstance]indexForProgress:progress];
    //让tableView 滚动到对应的行并选择选中
    NSIndexPath *indexPath1 =[NSIndexPath indexPathForRow:index inSection:0];
    [UIView animateWithDuration:3 animations:^{
       [self.lyricTableview selectRowAtIndexPath:indexPath1 animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }];
    }
/*
- (NSString *)transFormate:(float)progress{

    //计算多少分钟 设置为两列，不足的补0
    NSString *miniute = [NSString stringWithFormat:@"%02d",(int)progress/60];
    //计算秒数
    NSString *seconds = [NSString stringWithFormat:@"%02d",((int)progress%60)];
    //拼接
    NSString *str = [NSString stringWithFormat:@"%@:%@",miniute,seconds];
    //返回
    return str;
}
*/

- (void)viewWillAppear:(BOOL)animated{
    //判断要播放的歌曲和当前的歌曲是否是同一首歌
    if (self.index == self.currentIndex) {
        return;
    }
    self.currentIndex = self.index;
    [self exchangeMusic];
    
}
#pragma mark 切歌
- (void)exchangeMusic{

    //1.根据下标获取模型
    ListModel *model =[[ListReuqestManger shareInstance]modelWinthIndex:self.currentIndex];
    //2.设置唱片
    [[MusicPlayManger shareInstance]prePareToplayerWithModel:model];
    CGFloat duration = [model.duration floatValue]/1000;
    //设置时间最大值
    self.timeprogressSlider.maximumValue = duration;
    self.navigationItem.title = model.name;
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.font = [UIFont systemFontOfSize:20];
    self.detailLabel.text = model.singer;

    [self.playMusicButton setImage:[UIImage imageNamed:@"播放.png"] forState:UIControlStateNormal];
    [self.singerImgView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    //图片的自己适应 模式
    self.singerImgView.contentMode  = UIViewContentModeScaleAspectFill;
    //设置图片的起始角度
    self.singerImgView.transform = CGAffineTransformMakeRotation(0);
    [[MusicPlayManger shareInstance]play];
    
    //设置歌词
    [[LyricManager shareInstance]initLyricWithModel:model];
    [self.lyricTableview reloadData];
    
   

}


//播放时间进度条
- (IBAction)timeProgressSliderAction:(UISlider *)sender {
    
    [[MusicPlayManger shareInstance]seekTimeToPlay:sender.value];
    NSLog(@"%f",sender.value);
}
//声音进度条
- (IBAction)VoiceProgressSlider:(UISlider *)sender {
    [[MusicPlayManger shareInstance]setVloum:sender.value];
}
//上一首
- (IBAction)lastMusicAction:(UIButton *)sender {
    if (self.currentIndex ==0 ) {
       //如果是第一首歌曲，则切换到最后一首歌曲
        self.currentIndex = [[ListReuqestManger shareInstance]countOfArray] - 1;
        [self exchangeMusic];
        return;
    }
    self.currentIndex--;
    [self exchangeMusic];

    
}
//播放
- (IBAction)playMusicAction:(UIButton *)sender {
    //获取当前音乐播放器的状态
    BOOL state = [[MusicPlayManger shareInstance]state];
    
    if (state) {
        //处于播放状态
    [[MusicPlayManger shareInstance]pause];
    [self.playMusicButton setImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateNormal];
    
        NSLog(@"进入暂停状态");
    }
    else{
       //处于暂停状态
    [[MusicPlayManger shareInstance]play];
    [self.playMusicButton setImage:[UIImage imageNamed:@"播放.png"] forState:UIControlStateNormal];
     NSLog(@"进入播放状态");
    }

}
//下一首
- (IBAction)nextMusicAction:(UIButton *)sender {
    
    if (self.currentIndex ==[[ListReuqestManger shareInstance]countOfArray] - 1 ) {
        //如果是最后一首歌曲，则切换到第一首歌曲
        self.currentIndex = 0;
        [self exchangeMusic];
        return;
    }
    self.currentIndex++;
    [self exchangeMusic];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%-----ld", [[LyricManager shareInstance]countOfArray]);
  return   [[LyricManager shareInstance]countOfArray];
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"main_cell" forIndexPath:indexPath];
    LyricModel *model = [[LyricManager shareInstance]modelAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.numberOfLines = -1;
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text =[NSString stringWithFormat:@"%@",model.lyric];
    
    NSLog(@"%f",model.time);
    return cell;
 
}

- (IBAction)LoopAction:(UIButton *)sender {
    
    self.playStyle = playModeLoopStyle;
}

- (IBAction)OrderAction:(id)sender {
    self.playStyle = playModeOrderStyle;
}

- (IBAction)RandomAction:(id)sender {
    self.playStyle = playModeRandomStyle;
}

- (IBAction)moreAction:(id)sender {
    
      self.playStyle = playModeLoopStyle;
}





- (void)playEndTotime{
    
    [[MusicPlayManger shareInstance]pause];
    switch (self.playStyle) {
        case playModeLoopStyle:{
        [self exchangeMusic];
        }break;
            
        case playModeOrderStyle:{
           
            if (self.currentIndex ==[[ListReuqestManger shareInstance]countOfArray] - 1 ) {
                self.currentIndex = 0;
                [self exchangeMusic];
                return;
            }
            self.currentIndex++;
            [self exchangeMusic];
        
        }break;
    
        case playModeRandomStyle:{
        
            self.currentIndex = arc4random()%([[ListReuqestManger shareInstance]  countOfArray] -1);
            [self exchangeMusic];
        
        }break;
        default:break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
