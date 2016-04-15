//
//  SeminarSonViewController.h
//  teachingliteApple
//
//  Created by admin on 15/9/25.
//  Copyright (c) 2015年 com.futian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeminarSonViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *seminarSonTableView;
@property (weak, nonatomic) IBOutlet UITextView *seminarSon_content;
@property (weak, nonatomic) IBOutlet UIImageView *seminarSon_bg;

@property (strong, nonatomic) IBOutlet UIButton *deletePhotoBtn;
@property (weak, nonatomic) IBOutlet UIView *sendBarView;
@property (strong, nonatomic) IBOutlet UIImageView *photoView;

- (IBAction)seminarSon_send:(id)sender;
- (IBAction)getSeminarSonPhoto:(id)sender;
- (IBAction)deletePhoto:(id)sender;


@end
