//
//  iCloudSampleViewController.m
//  icloudsample1
//
//  Created by 黒木 裕貴 on 12/12/14.
//  Copyright (c) 2012年 ykuroki. All rights reserved.
//

#import "iCloudSampleViewController.h"

@interface iCloudSampleViewController ()

@end

@implementation iCloudSampleViewController

- (void)ubiquitousDataDidChange:(NSNotification *)notification
{
    //NSDictionary *dic = [notification userInfo];
    
    NSUbiquitousKeyValueStore *icscore = [NSUbiquitousKeyValueStore defaultStore];
    toDoList = (NSMutableArray *)[[icscore arrayForKey:@"toDoList"] mutableCopy];
    [self.mainTableView reloadData];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"リストが更新されました"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // リスト初期化
    toDoList = [[NSMutableArray alloc] init];

    // iCloud からデータの変更通知を受ける設定
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ubiquitousDataDidChange:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:nil];

    NSUbiquitousKeyValueStore *icscore = [NSUbiquitousKeyValueStore defaultStore];
    toDoList = (NSMutableArray *)[[icscore arrayForKey:@"toDoList"] mutableCopy];
    
    // 取得した値がからのときは初期化
    if (!toDoList) {
        toDoList = [[NSMutableArray alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [toDoList count];
}


// セルの生成が必要な際に、UITableViewController が呼び出すメソッドです。
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // ここで、カスタムセルのレイアウト時に設定した Reuse Identifier を指定します。
    static NSString* CellIdentifier = @"ToDoListTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *toDo = [toDoList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [toDo objectForKey:@"description"];

    // カスタムセルを返します。
    return cell;
}

- (IBAction)postBtnAction:(id)sender {
    
    // 画面遷移
    iCloudPostViewController *postVC = [self.storyboard instantiateViewControllerWithIdentifier:@"iCloudPostViewController"];
    postVC.delegate = self;
    
    postVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:postVC animated:YES completion:nil];
    [postVC.postTxtArea becomeFirstResponder];
}

- (IBAction)addDocumentAction:(id)sender {

    iCloudDocumentViewController *docVC = [self.storyboard instantiateViewControllerWithIdentifier:@"iCloudDocumentViewController"];
    
    docVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:docVC animated:YES completion:nil];
}

/*
 * キャンセルボタン押下したとき
 */
- (void)iCloudPostViewControllerDidFinish
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 * リストに追加
 */
- (void)addToDoList:(NSString *)message
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSUbiquitousKeyValueStore *icstore = [NSUbiquitousKeyValueStore defaultStore];
    
    // 値とキー値を指定した生成例
    NSDictionary *dic = [NSDictionary dictionaryWithObject:message forKey:@"description"];
    [toDoList addObject:dic];
        
    // iCloudへ追加
    [icstore setArray:toDoList forKey:@"toDoList"];
    [icstore synchronize];
    
    // 自身のテーブルviewも更新する
    [self.mainTableView reloadData];

}

/*
 * 編集モード時のコールバック
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// 該当するデータを削除する
		[self deleteDataSource:indexPath.row];
		
		// テーブルから該当セルを削除する
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
 * リストから削除する
 */
-(void)deleteDataSource:(NSInteger)row
{
    [toDoList removeObjectAtIndex:row];
    
    NSUbiquitousKeyValueStore *icstore = [NSUbiquitousKeyValueStore defaultStore];
    
    // iCloudへ追加
    [icstore setArray:toDoList forKey:@"toDoList"];
    [icstore synchronize];    
}

/*
 * リストから選択された場合の分岐
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mainTableView reloadData];
    
    [super viewDidLoad];
}


@end
