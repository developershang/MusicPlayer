//
//  MusicListViewController.m
//  SGW_MusicPlayer
//
//  Created by shang on 16/1/13.
//  Copyright © 2016年 shang. All rights reserved.
//

#import "MusicListViewController.h"
#import "ListTableViewCell.h"
#import "ListHeader.h"
#import "ListReuqestManger.h"
#import "MusicPlayViewController.h"
//创建一个全局的重用标示符
static NSString *reuseIdenti = @"list";
@interface MusicListViewController ()<UITableViewDataSource, UITableViewDelegate>

//歌单列表
@property (nonatomic, strong)UITableView *listTable;
@property (nonatomic, strong)MusicPlayViewController *mvc ;
@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自动为滚动视图添加属性关闭
    self.automaticallyAdjustsScrollViewInsets = NO;
//    //设置导航栏为不透明
    self.navigationController.navigationBar.translucent = NO;    
    self.navigationItem.title = @"音乐列表";
    //初始化tableview
    self.listTable = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    //这里解决了多处一些的问题，还可以设置header的高度
    
    self.listTable.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.listTable];
    //设置代理
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    self.mvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PlayViewq"];
    self.listTable.separatorStyle = UITableViewCellSelectionStyleDefault;
    //注册cell
    
    [self.listTable registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdenti];
    
    
   [[ListReuqestManger shareInstance] requestWithUrl:kMusicUrl didFinsh:^{
       [self.listTable reloadData];  
   }];
    // Do any additional setup after loading the view.
}


#pragma mark - TableviewDelagate datasource

#pragma mark 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[ListReuqestManger shareInstance]countOfArray];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据需要直接去重用池取值
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdenti forIndexPath:indexPath];
    cell.model = [[ListReuqestManger shareInstance] modelWinthIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.mvc.index = indexPath.row;
   
    [self.navigationController pushViewController:self.mvc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
