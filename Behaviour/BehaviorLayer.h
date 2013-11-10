//
//  BehaviorLayer.h
//  BasicCocos2D
//
//  Created by Ian Fan on 14/10/12.
//
//

#import "cocos2d.h"
#import "Wander.h"
#import "Seek.h"
#import "Flee.h"
#import "Pursuit.h"
#import "Evade.h"
#import "TargetSingleton.h"
#import "Arrival.h"
#import "WaypointSingleton.h"
#import "Waypoint.h"
#import "ObstacleAvoidanceSingleton.h"
#import "ObstacleMainSingleton.h"
#import "UnalignedCollisionAvoidanceSingleton.h"
#import "FlockingSingleton.h"
#import "FlowFieldFollowingSingleton.h"

typedef enum {
  Behavior_None,
  
  Behavior_Wander,
  Behavior_Seek,
  Behavior_Flee,
  Behavior_Pursuit,
  Behavior_Evade,
  Behavior_Arrival,
  Behavior_Waypoint,
  Behavior_ObstacleAvoidance,
  Behavior_UnalignedCollisionAvoidance,
  Behavior_Flocking,
  Behavior_FlowFieldFollowing,
} BehaviorStatus;

@interface BehaviorLayer : CCLayer
{
  NSMutableArray *updateArray;
}

+(CCScene *) scene;

@property BehaviorStatus behaviorStatus;

@end
