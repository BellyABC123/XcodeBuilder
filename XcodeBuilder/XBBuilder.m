//
//  XBBuilder.m
//  XcodeBuilder
//
//  Created by mini on 14-2-24.
//  Copyright (c) 2014年 mini. All rights reserved.
//

#import "XBBuilder.h"


@implementation XBBuilder
{
    XCProject* _project;
    //XCTarget* _target;
}

-(void) initBuilder
{
    // 执行准备shell
    system("/Users/mini/xiaoairen_prepare.sh");
    
    _project = [[XCProject alloc] initWithFilePath:@"/Users/mini/Documents/SVN/xiaoairen/程序/XARClinet/Project/Qin.xcodeproj"];
    
    // 消息文件添加
    XCGroup* messageGroup = [_project groupWithPathFromRoot:@"Xar/Message"];
    [messageGroup removeFromParentGroup];
    messageGroup = [_project groupWithPathFromRoot:@"Xar"];
    messageGroup = [messageGroup addGroupWithPath:@"Message"];
    [self addMessage:@"/Users/mini/Documents/SVN/xiaoairen/Message/" group:messageGroup];
    
    // 代码文件添加
    XCGroup* codeGroup = [_project groupWithPathFromRoot:@"Xar/Classes"];
    NSArray* codeChildren = [codeGroup members];
    for (XCGroup* child in codeChildren) {
        [child removeFromParentGroup];
    }
    [self addCodeSource:@"/Users/mini/Documents/SVN/xiaoairen/程序/XARClinet/Project/Qin/Classes/" groupPath:@"Xar/Classes" group:codeGroup];
    
    // 资源文件添加(大包)
    XCGroup* resourceGroup = [_project groupWithPathFromRoot:@"Xar/Resources/Big"];
    [resourceGroup removeFromParentGroup];
    resourceGroup = [_project groupWithPathFromRoot:@"Xar/Resources"];
    resourceGroup = [resourceGroup addGroupWithPath:@"Big"];
    [self addResource:@"/Users/mini/Documents/SVN/xiaoairen/Resources/" group:resourceGroup];
    [_project save];
    
    // 执行结束shell
    system("/Users/mini/xiaoairen_finish.sh");
    NSLog(@"打包结束！！！");
}

-(void) addCodeSource:(NSString*)folderPath groupPath:(NSString*)groupPath group:(XCGroup*)group
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* pathHome = [folderPath stringByExpandingTildeInPath];
    // 该函数回递归遍历子文件夹
    //NSDirectoryEnumerator* direnum = [fileManager enumeratorAtPath:pathHome];
    NSArray* pathArray = [fileManager contentsOfDirectoryAtPath:pathHome error:nil];
    
    NSString* fileName  = nil;
    XCGroup* childGroup = nil;
    //while (fileName = [direnum nextObject]) {
    for (fileName in pathArray) {
        
        // 特殊文件过滤
        NSRange range = [fileName rangeOfString:@"/"];
        if (range.location != NSNotFound || [fileName isEqualToString:@".DS_Store"] || [fileName isEqualToString:@"updateGlobal.h"] || [fileName isEqualToString:@"updateGlobal.cpp"]) {
            continue;
        }
        
        NSString* fileType = [fileName pathExtension];
        XCSourceFileDefinition* codeSource = nil;
        XcodeSourceFileType sourceType = FileTypeNil;
        
        // 文件夹＝分组
        if ([fileType isEqualTo:@""]){
            childGroup = [group addGroupWithPath:fileName];
            NSString* childFolderPath = [NSString stringWithFormat:@"%@%@/", folderPath, fileName];
            NSString* childGroupPath = [NSString stringWithFormat:@"%@/%@", groupPath, fileName];
            [self addCodeSource:childFolderPath groupPath:childGroupPath group:childGroup];
            continue;
        }
        
        // 代码文件
        if ([fileType isEqualTo:@"h"] || [fileType isEqualTo:@"hpp"]){
            codeSource = [[XCSourceFileDefinition alloc] initWithName:fileName text:@"this is a bug!!" type:SourceCodeHeader];
            [group addSourceFile:codeSource];
            continue;
        }
        else if ([fileType isEqualTo:@"c"]){
            sourceType = SourceCodeC;
        }
        else if ([fileType isEqualTo:@"cpp"]){
            sourceType = SourceCodeCPlusPlus;
        }
        else if ([fileType isEqualTo:@"mm"]){
            sourceType = SourceCodeObjCPlusPlus;
        }
        else if ([fileType isEqualTo:@"m"]){
            sourceType = SourceCodeObjC;
        }
        else{
            NSLog(@"%@:%@", fileName, @"未知文件");
            continue;
        }
        
        // 将代码文件加入对应的Group和Targets
        codeSource = [[XCSourceFileDefinition alloc] initWithName:fileName text:@"this is a bug!!" type:sourceType];
        [group addSourceFile:codeSource];
        XCSourceFile* sourceFile= [_project fileWithName:fileName];
        [group addSourceFile:sourceFile toTargets:[_project targets]];
    }
    
}

-(void) addResource:(NSString*)folderPath group:(XCGroup*)group
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* pathHome = [folderPath stringByExpandingTildeInPath];
    NSArray* pathArray = [fileManager contentsOfDirectoryAtPath:pathHome error:nil];
    
    NSString* fileName  = nil;
    for (fileName in pathArray) {
        if ([fileName isEqualToString:@".DS_Store"] || [fileName isEqualToString:@"server"]) {
            continue;
        }
        
        NSString* fileType = [fileName pathExtension];
        // 文件夹＝分组
        if ([fileType isEqualTo:@""]){
            XCSourceFileDefinition* resource = [[XCSourceFileDefinition alloc] initWithName:fileName text:@"this is a bug!!" type:Folder];
            [group addSourceFile:resource];
            XCSourceFile* sourceFile= [_project fileWithName:fileName];
            [sourceFile setPath:[NSString stringWithFormat:@"%@%@", folderPath, fileName]];
            [group addSourceFile:sourceFile toTargets:[_project targets]];
        }
    }
}

-(void) addMessage:(NSString*)folderPath group:(XCGroup*)group
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* pathHome = [folderPath stringByExpandingTildeInPath];
    NSArray* pathArray = [fileManager contentsOfDirectoryAtPath:pathHome error:nil];
    
    NSString* fileName  = nil;
    for (fileName in pathArray) {
        if ([fileName isEqualToString:@".DS_Store"]) {
            continue;
        }
        NSString* fileType = [fileName pathExtension];
        XCSourceFileDefinition* codeSource = nil;
        XcodeSourceFileType sourceType = FileTypeNil;
        
        // 代码文件
        if ([fileType isEqualTo:@"h"]){
            codeSource = [[XCSourceFileDefinition alloc] initWithName:fileName text:@"this is a bug!!" type:SourceCodeHeader];
            [group addSourceFile:codeSource];
            XCSourceFile* sourceFile= [_project fileWithName:fileName];
            [sourceFile setPath:[NSString stringWithFormat:@"%@%@", folderPath, fileName]];
            continue;
        }
        else if ([fileType isEqualTo:@"cc"]){
            sourceType = SourceCodeCPlusPlus;
        }
        else{
            NSLog(@"%@:%@", fileName, @"未知文件");
            continue;
        }
        
        // 将代码文件加入对应的Group和Targets
        codeSource = [[XCSourceFileDefinition alloc] initWithName:fileName text:@"this is a bug!!" type:sourceType];
        [group addSourceFile:codeSource];
        XCSourceFile* sourceFile= [_project fileWithName:fileName];
        [sourceFile setPath:[NSString stringWithFormat:@"%@%@", folderPath, fileName]];
        [group addSourceFile:sourceFile toTargets:[_project targets]];
    }
}

@end
