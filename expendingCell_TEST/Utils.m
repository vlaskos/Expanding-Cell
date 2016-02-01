//
//  Utils.m
//  expendingCell_TEST
//
//  Created by vlaskos on 31.01.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (instancetype)sharedInstance{
    static Utils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Utils alloc] init];
    });
    return sharedInstance;
}

@end
