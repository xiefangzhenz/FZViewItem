//
//  ListViewController.m
//  图片排列
//
//  Created by 谢方振 on 15/12/2.
//  Copyright © 2015年 谢方振. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()
{
    NSMutableArray* _dataList;
}
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    UITableView* tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
}
-(instancetype)init{

    if (self = [super init]) {
        
        NSArray* arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"viewItemData"];
        
        if (!arr) {
            
            arr = @[@{@"title":@"农业银行",@"imageName":@"ABC"},
                    @{@"title":@"交通银行",@"imageName":@"BCM"},
                    @{@"title":@"中国银行",@"imageName":@"BOC"},
                    @{@"title":@"建设银行",@"imageName":@"CCB"},
                    @{@"title":@"光大银行",@"imageName":@"CEB"},
                    @{@"title":@"招商银行",@"imageName":@"CMB"},
                    @{@"title":@"民生银行",@"imageName":@"CMBC"},
                    @{@"title":@"中信银行",@"imageName":@"CNCB"},
                    @{@"title":@"浙商银行",@"imageName":@"CZB"},
                    @{@"title":@"恒丰银行",@"imageName":@"EVERGROWING"},
                    @{@"title":@"广东发展银行",@"imageName":@"GDB"},
                    @{@"title":@"华夏银行",@"imageName":@"HXB"},
                    @{@"title":@"工商银行",@"imageName":@"ICBC"},
                    @{@"title":@"深圳发展银行",@"imageName":@"SDB"},
                    @{@"title":@"浦东发展银行",@"imageName":@"SPDB"}
                    ];

            
            
        }
        [[NSUserDefaults standardUserDefaults]setObject:arr forKey:@"viewItemData"];
        
        _dataList = [[NSMutableArray alloc]initWithArray:arr];
    }

    return self;
}
-(void)setCurrentList:(NSMutableArray *)currentList{


    _currentList = currentList;
    
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",_currentList];
    
    _dataList = [[NSMutableArray alloc]initWithArray:[_dataList filteredArrayUsingPredicate:filterPredicate]];
    
    

}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.block) {
        
        self.block(_dataList[indexPath.row]);
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _dataList.count;


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _dataList[indexPath.row][@"title"];
    cell.imageView.image = [UIImage imageNamed:_dataList[indexPath.row][@"imageName"]];
    
    return cell;


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
