//
//  PiingHandler.m
//  Piing
//
//  Created by Piing on 10/23/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "PiingHandler.h"

static PiingHandler *sharedHandler = nil;

@implementation PiingHandler

+(instancetype) sharedHandler {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHandler = [[PiingHandler alloc] init];
    });
    
    return sharedHandler;
}

@end
