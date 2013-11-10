//
//  Evade.m
//  BasicCocos2D
//
//  Created by Ian Fan on 16/10/12.
//
//

#import "Evade.h"

@implementation Evade
@synthesize mainMaxSpeed,mainSprite;

#pragma mark -
#pragma mark Update

/*
 1. Take both vehicles, find the distance between them.
 2. Take the distance and divide by the target’s maxSpeed.
 3. Take the target’s velocity, multiply it by T and add it to the target’s position.
 4. Seek that new position
 5. Update the vehicle
 
 public function pursue(target:Vehicle):void {
 var distance:Number = target.position.distance(position);
 var T:Number = distance / target._maxSpeed;
 var targetPosition:Vector2D = target.position.cloneVector().add(target.velocity.cloneVector().multiply(T));
 seek(targetPosition);
 }
 */

-(void)update {
  TargetSingleton *tOj = [TargetSingleton sharedInstance];
  
  float mainToTargetDis = ccpDistance(mainSprite.position, tOj.targetSprite.position);
//  if (mainToTargetDis < 0.5*mainSprite.boundingBox.size.width+0.5*tOj.targetSprite.boundingBox.size.width) {mainSprite.opacity = 0; return;}
  
  float targetDegree = -tOj.targetSprite.rotation;
  CGPoint targetDirection = ccpNormalize(ccp(cosf(CC_DEGREES_TO_RADIANS(targetDegree)),sinf(CC_DEGREES_TO_RADIANS(targetDegree))));
  CGPoint targetVelocity = ccpMult(targetDirection, tOj.targetMaxSpeed);
  float expectedTargetTime = mainToTargetDis/mainMaxSpeed;
  CGPoint expectedTargetPosition = ccpAdd(tOj.targetSprite.position, ccpMult(targetVelocity, expectedTargetTime));
  
  float mainDegree = -mainSprite.rotation;
  CGPoint direction = ccpNormalize(ccp(cosf(CC_DEGREES_TO_RADIANS(mainDegree)),sinf(CC_DEGREES_TO_RADIANS(mainDegree))));
  
  CGPoint velocity = ccpMult(direction, mainMaxSpeed);
  
  CGPoint desiredDirection = ccpNeg(ccpNormalize(ccpSub(expectedTargetPosition, mainSprite.position)));
  CGPoint desiredVelocity = ccpMult(desiredDirection, mainMaxSpeed);
  
  CGPoint steeringForce = ccpSub(desiredVelocity, velocity);
  steeringForce = ccpMult(steeringForce, 10.0/mainToTargetDis);
  
  velocity = ccpAdd(velocity, steeringForce) ;
  
  mainSprite.rotation = -CC_RADIANS_TO_DEGREES(ccpToAngle(velocity));
  mainSprite.position = ccpAdd(mainSprite.position, velocity);
  [self wrapAroundWithSprite:mainSprite];
}

#pragma mark -
#pragma mark Tool

-(float)randfrom:(float)start to:(float)end {
  return CCRANDOM_0_1()*(end-start) + start;
}

-(void)wrapAroundWithSprite:(CCSprite*)sprite {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  if (sprite.position.x>winSize.width ) sprite.position = ccp(sprite.position.x-winSize.width, sprite.position.y);
  if (sprite.position.x<0             ) sprite.position = ccp(sprite.position.x+winSize.width, sprite.position.y);
  if (sprite.position.y>winSize.height) sprite.position = ccp(sprite.position.x, sprite.position.y-winSize.height);
  if (sprite.position.y<0             ) sprite.position = ccp(sprite.position.x, sprite.position.y+winSize.height);
}

#pragma mark -
#pragma mark Visibility

-(void)addVisibilityToParent:(CCLayer*)parentLay {
  if ([[parentLay children] containsObject:mainSprite] == NO) [parentLay addChild:mainSprite];
}

-(void)removeVisibilityFromParent:(CCLayer*)parentLay {
  [parentLay removeChild:mainSprite cleanup:NO];
}

-(void)setVisibilityWithMainPosition:(CGPoint)mainPos mainRotation:(float)mainRota {
  self.mainSprite = [CCSprite spriteWithFile:@"circleYellow.png"];
  mainSprite.position = mainPos;
  mainSprite.rotation = mainRota;
}

#pragma mark -
#pragma mark Init

-(id)initStandardWithMainPosition:(CGPoint)mainPos {
  if ( (self = [super init]) ) {
    float mainDegree = 90.0f;
    self.mainMaxSpeed = 2.0f;
    
    [self setVisibilityWithMainPosition:mainPos mainRotation:-mainDegree];
  }
  
  return self;
}

-(id)initWithMainPosition:(CGPoint)mainPos mainRotation:(float)mainRota mainMaxSpeed:(float)mainMaxSpee {
  if ( (self = [super init]) ) {
    self.mainMaxSpeed = mainMaxSpee;
    
    [self setVisibilityWithMainPosition:mainPos mainRotation:mainRota];
  }
  
  return self;
}

- (void) dealloc {
  self.mainSprite = nil;
  
	[super dealloc];
}

@end
