//
//  TargetSingleton.m
//  BasicCocos2D
//
//  Created by Ian Fan on 16/10/12.
//
//

#import "TargetSingleton.h"

@implementation TargetSingleton
@synthesize targetSprite,targetMaxSpeed;

+(id)sharedInstance {
  static id shared = nil;
  if (shared == nil) shared = [[TargetSingleton alloc]init];
  
  return shared;
}

#pragma mark -
#pragma mark Update

-(void)update {
  float targetDegree = -targetSprite.rotation;
  CGPoint direction = ccpNormalize(ccp(cosf(CC_DEGREES_TO_RADIANS(targetDegree)), sinf(CC_DEGREES_TO_RADIANS(targetDegree))));
  CGPoint velocity = ccpMult(direction, targetMaxSpeed);
  
  CGPoint steeringForce = ccp(0, 0);
  velocity = ccpAdd(velocity, steeringForce);
  
  targetSprite.rotation = -CC_RADIANS_TO_DEGREES(ccpToAngle(velocity));
  targetSprite.position = ccpAdd(targetSprite.position, velocity);
  [self wrapAroundWithSprite:targetSprite];
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

-(void)addVisibilityToParent:(CCLayer *)parentLay {
  if ([[parentLay children] containsObject:targetSprite] == NO) [parentLay addChild:targetSprite z:1];
}

-(void)removeVisibilityFromParent:(CCLayer *)parentLay {
  [targetSprite removeFromParentAndCleanup:NO];
}

#pragma mark -
#pragma mark Set

-(void)setStandardWithTargetPosition:(CGPoint)targetPos {
  float targetRotation = -60.0f;
  self.targetMaxSpeed = 2.0f;
  
  [self setVisibilityWithTargetPosition:targetPos targetRotation:targetRotation];
}

-(void)setWithTargetPosition:(CGPoint)targetPos targetRotation:(float)targetRota targetMaxSpeed:(float)targetMaxSpee {
  self.targetMaxSpeed = targetMaxSpeed;
  
  [self setVisibilityWithTargetPosition:targetPos targetRotation:targetRota];
}

-(void)setVisibilityWithTargetPosition:(CGPoint)targetPos targetRotation:(float)targetRota {
  self.targetSprite = [CCSprite spriteWithFile:@"circleWhite.png"];
  targetSprite.position = targetPos;
  targetSprite.rotation = targetRota;
}

#pragma mark -
#pragma mark Init

-(id)init {
  if ((self = [super init])) {
  }
  
  return self;
}

@end
