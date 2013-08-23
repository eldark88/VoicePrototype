//
//  Recording.h
//  VoicePrototype
//
//  Created by Bastion on 8/22/13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recording : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;

@end
