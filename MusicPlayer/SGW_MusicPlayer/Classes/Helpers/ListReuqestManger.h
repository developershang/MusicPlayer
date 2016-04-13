//
//  ListReuqestManger.h
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/13.
//  Copyright © 2016年 shang. All rights reserved.
//

/*
 * 用来管理音乐列表的页面数据请求和处理
 */


#import <Foundation/Foundation.h>
#import "ListModel.h"
@interface ListReuqestManger : NSObject


+(instancetype)shareInstance;

/**
 *@param  NSString url 数据接口 
 *@return void
 **/

#pragma mark - 通过网址解析数据,解析完毕 进行完成回调
-(void)requestWithUrl:(NSString *)url didFinsh:(void(^)())finish;


/*
 * 返回数组个数@return
 */
#pragma mark - 返回解析完之后数组的个数 
-(NSInteger)countOfArray;


/**
 *@param  index 下标
 *@return model 歌曲模型
 */
#pragma mark - 通过下标索引获取model
- (ListModel *)modelWinthIndex:(NSInteger)index;

@end
