//
//  Tag.h
//  VoicePrototype
//
//  Created by Eldar Khalyknazarov on 1/16/14.
//  Copyright (c) 2014 FlowTelligent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recording;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Recording *recording;

@end
