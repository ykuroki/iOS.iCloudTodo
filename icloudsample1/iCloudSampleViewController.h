//
//  iCloudSampleViewController.h
//  icloudsample1
//
//  Created by 黒木 裕貴 on 12/12/14.
//  Copyright (c) 2012年 ykuroki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCloudPostViewController.h"
#import "iCloudDocumentViewController.h"

@interface iCloudSampleViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
iCloudPostViewControllerDelegate
>
{
    NSMutableArray *toDoList;
}
@property (retain, nonatomic) IBOutlet UITableView *mainTableView;
- (IBAction)postBtnAction:(id)sender;
- (IBAction)addDocumentAction:(id)sender;

@end
