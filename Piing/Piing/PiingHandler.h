//
//  PiingHandler.h
//  Piing
//
//  Created by Piing on 10/23/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PiingHandler : NSObject

+(instancetype) sharedHandler;

@property (nonatomic, assign) AppDelegate *appDel;
@property (nonatomic, strong) NSArray *userAddress;
@property (nonatomic, strong) NSArray *userSavedCards;

@end
