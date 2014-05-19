//
//  TodoItem.h
//  QuickTODO
//
//  Created by Daniel Munoz on 3/12/14.
//  Copyright (c) 2014 GreenCraft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TodoItem : NSManagedObject

@property (nonatomic, retain) NSString * todoId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSNumber * completed;

@end
