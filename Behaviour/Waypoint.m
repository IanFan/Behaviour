//
//  Waypoint.m
//  BasicCocos2D
//
//  Created by Ian Fan on 16/10/12.
//
//

#import "Waypoint.h"

@implementation Waypoint
@synthesize maxSpeed,mainSprite,waypointIndex;

#pragma mark -
#pragma mark Update

/*
 1. desiredVelocity = position-target truncated normalized then multiplied by maxSpeed(this gets the desired velocity going to the target as fast as it can).
 2. steeringForce = desiredVelocity – velocity
 3. acceleration = steeringForce / mass
 4. velocity += acceleration
 5. Then the update function is called
 */

-(void)update {
  WaypointSingleton *waypointSingleton = [WaypointSingleton sharedInstance];
  NSArray *waypointSpriteArray = waypointSingleton.visibilityArray;
  CCSprite *targetSprite;
  
  if (waypointIndex >= [waypointSpriteArray count]) return;
  
  targetSprite = [waypointSpriteArray objectAtIndex:waypointIndex];
  
  float mainToTargetDis = ccpDistance(mainSprite.position, targetSprite.position);
  if (mainToTargetDis < 20) waypointIndex ++;
  
  float mainDegree = -mainSprite.rotation;
  CGPoint direction = ccpNormalize(ccp(cosf(CC_DEGREES_TO_RADIANS(mainDegree)),sinf(CC_DEGREES_TO_RADIANS(mainDegree))));
  CGPoint velocity = ccpMult(direction, maxSpeed);
  
  CGPoint desiredDirection = ccpNormalize(ccpSub(targetSprite.position, mainSprite.position));
  CGPoint desiredVelocity = ccpMult(desiredDirection, maxSpeed);
  
  CGPoint steeringForce = ccpSub(desiredVelocity, velocity);
  steeringForce = ccpMult(steeringForce, 0.05);
  
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
  if ([[parentLay children] containsObject:mainSprite] == NO) [parentLay addChild:mainSprite z:1];
}

-(void)removeVisibilityFromParent:(CCLayer*)parentLay {
  [parentLay removeChild:mainSprite cleanup:NO];
}

-(void)setVisibilityWithMainPosition:(CGPoint)mainPos mainRotation:(float)mainRota {
  self.mainSprite = [CCSprite spriteWithFile:@"circleGreen.png"];
  mainSprite.position = mainPos;
  mainSprite.rotation = mainRota;
}

#pragma mark -
#pragma mark Init

-(id)initStandardWithMainPosition:(CGPoint)mainPos {
  if ( (self = [super init]) ) {
    float mainDegree = 90.0f;
    self.maxSpeed = (float)2.0;
    
    [self setVisibilityWithMainPosition:mainPos mainRotation:-mainDegree];
  }
  
  return self;
}

-(id)initWithMainPosition:(CGPoint)mainPos mainRotation:(float)mainRota maxSpeed:(float)maxSpee {
  if ( (self = [super init]) ) {
    self.maxSpeed = maxSpee;
    
    [self setVisibilityWithMainPosition:mainPos mainRotation:mainRota];
  }
  
  return self;
}

- (void) dealloc {
  self.mainSprite = nil;
  
	[super dealloc];
}

@end
