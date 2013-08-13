//
//  iCloudPostViewController.h
//  icloudsample1
//
//  Created by 黒木 裕貴 on 12/12/15.
//  Copyright (c) 2012年 ykuroki. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol iCloudPostViewControllerDelegate
@optional
- (void)iCloudPostViewControllerDidFinish;
- (void)addToDoList:(NSString *)message;
@end

@interface iCloudPostViewController : UIViewController

@property(assign, nonatomic) id<iCloudPostViewControllerDelegate> delegate;
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)addBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *postTxtArea;

@end
