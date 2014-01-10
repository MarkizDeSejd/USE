//
//  NSObject+Debugging.m
//  MatchPlayer
//
//  Created by Jakub Lawiki on 10/05/2012.
//  Copyright (c) 2012 AMT-SYBEX. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Debugging.h"

@implementation NSObject (Debugging)

- (NSString *)verboseDescription
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: %p>", NSStringFromClass([self class]), self];
    
    uint32_t ivarCount;
    Ivar *ivars = class_copyIvarList([self class], &ivarCount);
    
    if(ivars)
    {
        [description appendString:@"\n{"];
        
        for(uint32_t i=0; i<ivarCount; i++)
        {
            Ivar ivar = ivars[i];
            NSString* ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            [description appendFormat:@"\n   %@: %@", ivarName, [self valueForKey:ivarName]];
            
        }
        
        [description appendString:@"\n}"];
        free(ivars);
    }
    
    return description; 
}

@end
