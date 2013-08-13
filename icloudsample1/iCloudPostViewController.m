//
//  iCloudPostViewController.m
//  icloudsample1
//
//  Created by 黒木 裕貴 on 12/12/15.
//  Copyright (c) 2012年 ykuroki. All rights reserved.
//

#import "iCloudPostViewController.h"

@interface iCloudPostViewController ()

@end

@implementation iCloudPostViewController
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"icould post view ");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * キャンセル
 */
- (IBAction)cancelBtnAction:(id)sender {
    [_delegate iCloudPostViewControllerDidFinish];
}

/*
 * 追加
 */
- (IBAction)addBtnAction:(id)sender {
    [_delegate addToDoList:self.self.postTxtArea.text];
}
@end
