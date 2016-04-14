//
//  YLWCollectionViewCell.m
//  推库iOS
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import "YLWCollectionViewCell.h"
#import "YLWContentTableViewController.h"
@interface YLWCollectionViewCell()

@property (nonatomic,strong) YLWContentTableViewController *ContentTableViewController;

@end
@implementation YLWCollectionViewCell

-(YLWContentTableViewController *)ContentTableViewController{

    if (_ContentTableViewController == nil) {
        _ContentTableViewController = [[YLWContentTableViewController alloc]init];
    }
    return _ContentTableViewController;
}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        
        
        
    }
    return self;
}

-(void)setUrlstring:(NSString *)urlstring{

    _urlstring = urlstring;

    

}

-(void)setTitle:(NSString *)title{

    _title = title;
    self.ContentTableViewController.titlename = title;
    self.ContentTableViewController.urlstring = _urlstring;
    
    self.ContentTableViewController.tableView.frame = self.bounds;
    [self.contentView addSubview:self.ContentTableViewController.tableView];

}

@end
