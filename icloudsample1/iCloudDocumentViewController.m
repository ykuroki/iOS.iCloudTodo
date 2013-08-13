//
//  iCloudDocumentViewController.m
//  icloudsample1
//
//  Created by 黒木 裕貴 on 13/01/20.
//  Copyright (c) 2013年 ykuroki. All rights reserved.
//

#import "iCloudDocumentViewController.h"

@interface iCloudDocumentViewController ()

@end

@implementation iCloudDocumentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ファイル一覧表示
    [self displayFileList];
    
    // ドキュメント生成
    SimpleDocument *doc = [self createDocumentForFileName:self.fileName];
    
    // 開くもしくはリロード
    [self openDocument:doc];
    
    // テキスト入力
    doc.text = @"araara";
    
    // セーブ
    [self saveDocument:doc];
    
    // 閉じる
    [doc closeWithCompletionHandler:^(BOOL success) {
        NSLog(@"close %d", success);
    }];    
}

/*
 * ファイル保存先のディレクトリ取得
 */
- (NSString *)directryStr
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex:0];
}

/*
 * ファイルが存在するか
 */
- (BOOL)isFileExistForPathString:(NSString *)filePathStr
{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:filePathStr];
    return isExist;
}

/*
 * ファイル名からURLStringを取得
 */
- (NSString *)getURLStringForFileName:(NSString *)fileName
{
    //url作成
    NSString *filePathStr = [NSString stringWithFormat:@"%@/%@",self.directryStr,fileName];
    return filePathStr;
}

/*
 * ファイル名から URLを取得
 */
- (NSURL *)getURLforFileName:(NSString *)fileName
{
    NSURL *url = [NSURL fileURLWithPath:[self getURLStringForFileName:fileName]];
    return url;
}

//ファイル名
- (NSString *)fileName
{
    return @"mone.txt";
}

//ファイルのURL
- (NSURL *)url
{
    return [self getURLforFileName:[self fileName]];
}

/*
 * セーブ
 */
- (void)saveDocument:(SimpleDocument *)doc
{
    [doc saveToURL:doc.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        NSLog(@"create save %d",success);
    }];
}

/*
 * ドキュメント生成
 */
-(SimpleDocument *)createDocumentForFileName: (NSString *)fileName
{
    //urlにファイルがあるか
    BOOL isExist = [self isFileExistForPathString:[self getURLStringForFileName:fileName]];
    
    SimpleDocument *doc = [[SimpleDocument alloc] initWithFileURL:self.url];
    
    if (!isExist) {
        // テキスト入力
        doc.text = @"new text";
        
        // 新規保存
        [self saveDocument:doc];
    }
    return doc;
}

/*
 * ドキュメントを開く
 */
- (void)openDocument:(SimpleDocument *)doc
{
    [doc openWithCompletionHandler:^(BOOL success) {
        NSLog(@"open = %@",doc.text);
    }];
}

/*
 * ファイルリストのログ表示
 */
- (void)displayFileList
{
    NSLog(@"=fileName=");
    for (NSString *documentPath in self.localDocumentPaths) {
        NSString *fileName = documentPath.lastPathComponent;
        NSLog(@"%@",fileName);
    }
    NSLog(@"==========");
}

/*
 * ローカルでファイルを保存する場所を取得
 */
- (NSArray *)localDocumentPaths
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *localDocumentPaths = [fm contentsOfDirectoryAtPath:self.directryStr error:nil];
    return localDocumentPaths;
}

@end
