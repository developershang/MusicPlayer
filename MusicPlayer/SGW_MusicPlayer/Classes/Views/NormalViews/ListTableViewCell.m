//
//  ListTableViewCell.m
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/13.
//  Copyright © 2016年 shang. All rights reserved.
//

#import "ListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ListModel.h"
@implementation ListTableViewCell



-(UIImageView *)photoView{
    _photoView.layer.masksToBounds = YES;
    [_photoView layoutIfNeeded];

    _photoView.layer.cornerRadius =_photoView.frame.size.height/2;

    return _photoView;
}

-(UILabel *)nameMusic{
    
    _nameMusic.backgroundColor = [UIColor whiteColor];
    
    return _nameMusic;
    
}

- (UILabel *)name_Artist{
    
    
    _name_Artist.backgroundColor = [UIColor whiteColor];
    return _name_Artist;
}



- (void)setModel:(ListModel *)model{
    
   // _model = model;
    //控件的值   
    //歌名
   // self.nameMusic.text =model.name;
    self.nameMusic.text = [NSString stringWithFormat:@"     %@",model.name];
    //作者
    //self.name_Artist.text = model.artists_name;
    self.name_Artist.text = [NSString stringWithFormat:@"      %@",model.artists_name];
    //图片
     [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:nil];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
