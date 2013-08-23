//
//  RecordingDatabase.h
//  VoicePrototype
//
//  Created by Eldar Khalyknazarov on 17.06.12.
//  Copyright (c) 2012 Flowtelligent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RecordingDatabase : NSObject
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (RecordingDatabase*)sharedInstance;
@end
