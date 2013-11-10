//
//  Flee.m
//  BasicCocos2D
//
//  Created by Ian Fan on 15/10/12.
//
//

#import "Flee.h"

@implementation Flee
@synthesize maxSpeed,mainSprite,targetSprite;

#pragma mark -
#pragma mark Update

/*
 1. desiredVelocity = target – position
 2. desiredVelocity is normalized and multiplied by maxSpeed.
 3. desiredVelocity is multiplied by -1 to go away from the target
 4. steeringForce = desiredVelocity – velocity
 5. update the vehicle.
 */

-(void)update {
  float mainToTargetDis = ccpDistance(mainSprite.position, targetSprite.position);
//  if (mainToTargetDis < 0.5*mainSprite.boundingBox.size.width+0.5*targetSprite.boundingBox.size.width) {mainSprite.opacity = 0; return;}
  
  float mainDegree = -mainSprite.rotation;
  CGPoint direction = ccpNormalize(ccp(cosf(CC_DEGREES_TO_RADIANS(mainDegree)),sinf(CC_DEGREES_TO_RADIANS(mainDegree))));
  CGPoint velocity = ccpMult(direction, maxSpeed);
  
  CGPoint desiredDirection = ccpNeg(ccpNormalize(ccpSub(targetSprite.position, mainSprite.position)));
  CGPoint desiredVelocity = ccpMult(desiredDirection, maxSpeed);
  
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

-(void)setVisibilityWithMainPosition:(CGPoint)mainPos mainRotation:(float)mainRota targetPosition:(CGPoint)targetPos {
  self.mainSprite = [CCSprite spriteWithFile:@"circleYellow.png"];
  mainSprite.position = mainPos;
  mainSprite.rotation = mainRota;
  
  self.targetSprite = [CCSprite spriteWithFile:@"circleWhite.png"];
  targetSprite.position = targetPos;
  targetSprite.rotation = -90;
}

-(void)addVisibilityToParent:(CCLayer*)parentLay {
  if ([[parentLay children] containsObject:mainSprite] == NO) [parentLay addChild:mainSprite];
  if ([[parentLay children] containsObject:targetSprite] == NO) [parentLay addChild:targetSprite z:1];
}

-(void)removeVisibilityFromParent:(CCLayer*)parentLay {
  [parentLay removeChild:mainSprite cleanup:NO];
  [parentLay removeChild:targetSprite cleanup:NO];
}

#pragma mark -
#pragma mark Init

-(id)initStandardWithMainPosition:(CGPoint)mainPos {
  if ( (self = [super init]) ) {
    float mainDegree = 90.0f;
    self.maxSpeed = 2.0f;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint targetPosition = ccp(winSize.width/2, winSize.height/2);
    
    [self setVisibilityWithMainPosition:mainPos mainRotation:-mainDegree targetPosition:targetPosition];
  }
  
  return self;
}

-(id)initWithMainPosition:(CGPoint)mainPos mainRotation:(float)mainRota maxSpeed:(float)maxSpee targetPosition:(CGPoint)targetPos {
  if ( (self = [super init]) ) {
    self.maxSpeed = maxSpee;
    
    [self setVisibilityWithMainPosition:mainPos mainRotation:mainRota targetPosition:targetPos];
  }
  
  return self;
}

- (void) dealloc {
  self.mainSprite = nil;
  self.targetSprite = nil;
  
	[super dealloc];
}

@end
