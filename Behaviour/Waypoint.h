//
//  Waypoint.h
//  BasicCocos2D
//
//  Created by Ian Fan on 16/10/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "WaypointSingleton.h"

@interface Waypoint : NSObject
{
}

@property (nonatomic,retain) CCSprite *mainSprite;
@property int waypointIndex;

@property float maxSpeed;

-(id)initStandardWithMainPosition:(CGPoint)mainPos;
-(id)initWithMainPosition:(CGPoint)mainPos mainRotation:(float)mainRota maxSpeed:(float)maxSpee;

-(void)update;

-(void)addVisibilityToParent:(CCLayer*)parentLay;
-(void)removeVisibilityFromParent:(CCLayer*)parentLay;

@end
