//
//  XBAppDelegate.h
//  XcodeBuilder
//
//  Created by mini on 14-2-24.
//  Copyright (c) 2014年 mini. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XBAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
