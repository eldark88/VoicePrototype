//
//  Recording.h
//  VoicePrototype
//
//  Created by Bastion on 8/25/13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

@interface Recording : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSOrderedSet *tags;
@end

@interface Recording (CoreDataGeneratedAccessors)

- (void)insertObject:(Tag *)value inTagsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTagsAtIndex:(NSUInteger)idx;
- (void)insertTags:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTagsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTagsAtIndex:(NSUInteger)idx withObject:(Tag *)value;
- (void)replaceTagsAtIndexes:(NSIndexSet *)indexes withTags:(NSArray *)values;
- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSOrderedSet *)values;
- (void)removeTags:(NSOrderedSet *)values;
@end
