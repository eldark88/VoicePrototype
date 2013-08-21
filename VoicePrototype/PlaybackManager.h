//
//  PlaybackManager.h
//  VoicePrototype
//
//  Created by Bastion on 8/19/13.
//  Copyright (c) 2013 FlowTelligent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaybackManager : NSObject

+ (id)sharedManager;
- (void)playWithURL:(NSURL*)url;
- (void)pause;
- (void)stop;

@end
