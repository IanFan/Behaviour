//
//  Wander.h
//  BasicCocos2D
//
//  Created by Ian Fan on 15/10/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Wander : NSObject
{
  float wanderDegree;
}

@property (nonatomic,retain) CCSprite *mainSprite;
@property (nonatomic,retain) CCSprite *circleSprite;
@property (nonatomic,retain) CCSprite *targetSprite;

@property float maxSpeed;
@property float mainToCircleDistance;
@property float circleRadius;
@property float circleDegreeNoise;

-(id)initStandardWithMainPosition:(CGPoint)mainPos;
-(id)initWithMainPosition:(CGPoint)mainPos mainRoration:(float)mainRota maxSpeed:(float)maxSpee mainToCircleDistance:(float)mainToCircleDis circleRaduis:(float)circleRadiu circleDegreeNoise:(float)circleDegreeNois;

-(void)update;

-(void)addVisibilityToParent:(CCLayer*)parentLay;
-(void)removeVisibilityFromParent:(CCLayer*)parentLay;

@end
