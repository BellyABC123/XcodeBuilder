//
//  XBBuilder.h
//  XcodeBuilder
//
//  Created by mini on 14-2-24.
//  Copyright (c) 2014年 mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCProject.h"
#import "XCGroup.h"
#import "XCSubProjectDefinition.h"
#import "XCClassDefinition.h"
#import "XCSourceFile.h"
#import "XCXibDefinition.h"
#import "XCTarget.h"
#import "XCFrameworkDefinition.h"
#import "XCSourceFileDefinition.h"

@interface XBBuilder : NSObject
-(void) initBuilder;
-(void) addCodeSource:(NSString*)folderPath groupPath:(NSString*)groupPath group:(XCGroup*)group;
-(void) addResource:(NSString*)folderPath group:(XCGroup*)group;
-(void) addMessage:(NSString*)folderPath group:(XCGroup*)group;
@end
