//
//  WaypointSingleton.h
//  BasicCocos2D
//
//  Created by Ian Fan on 16/10/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface WaypointSingleton : NSObject

@property (nonatomic,retain) NSMutableArray *visibilityArray;

+(id)sharedInstance;

-(void)setStandardWaypoint;
//-(void)setWithPointArray:(NSArray*)pointArray;

-(void)addNewWayPoint:(CGPoint)point;
//NSValue* point = [NSValue valueWithCGPoint:points[i]];

//-(void)update;

-(void)addVisibilityToParent:(CCLayer*)parentLay;
-(void)removeVisibilityFromParent:(CCLayer*)parentLay;

@end
