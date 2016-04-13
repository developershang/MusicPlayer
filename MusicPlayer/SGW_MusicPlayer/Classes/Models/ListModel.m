//
//  ListModel.m
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/13.
//  Copyright © 2016年 shang. All rights reserved.
//

#import "ListModel.h"
@implementation ListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
  
    
    if ([key isEqualToString:@"id"]) {
        //这里赋值记得转换成那是NSString
        self.ID = [value stringValue];
        return;
    }
//   [super setValue:value forUndefinedKey:key];
    
}



@end
