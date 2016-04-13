//
//  ListTableViewCell.h
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/13.
//  Copyright © 2016年 shang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListModel;
@interface ListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *nameMusic;
@property (weak, nonatomic) IBOutlet UILabel *name_Artist;


@property (nonatomic, strong)ListModel *model;
@end
