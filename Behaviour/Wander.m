//
//  Wander.m
//  BasicCocos2D
//
//  Created by Ian Fan on 15/10/12.
//
//

#import "Wander.h"

@implementation Wander

@synthesize mainToCircleDistance,maxSpeed,mainSprite,circleRadius,circleDegreeNoise,circleSprite,targetSprite;

#pragma mark -
#pragma mark Update

-(void)update {
  CGPoint direction = ccpNormalize(ccpSub(targetSprite.position, mainSprite.position));
  CGPoint velocity = ccpMult(direction, maxSpeed);
  
  circleSprite.position = ccpAdd(mainSprite.position, ccpMult(velocity, mainToCircleDistance));
  
  wanderDegree += [self randfrom:-circleDegreeNoise to:circleDegreeNoise];
  CGPoint desiredDirection = ccp(cosf(CC_DEGREES_TO_RADIANS(wanderDegree)), sinf(CC_DEGREES_TO_RADIANS(wanderDegree)));
  targetSprite.position = ccpAdd(circleSprite.position, ccpMult(desiredDirection, circleRadius));

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
//  if ([[parentLay children] containsObject:circleSprite] == NO) [parentLay addChild:circleSprite];
//  if ([[parentLay children] containsObject:targetSprite] == NO) [parentLay addChild:targetSprite z:1];
}

-(void)removeVisibilityFromParent:(CCLayer*)parentLay {
  [parentLay removeChild:mainSprite cleanup:NO];
//  [parentLay removeChild:circleSprite cleanup:NO];
//  [parentLay removeChild:targetSprite cleanup:NO];
}

-(void)setVisibilityWithMainPosition:(CGPoint)mainPos mainRotation:(float)mainRota{
  self.mainSprite = [CCSprite spriteWithFile:@"circleBlue.png"];
  mainSprite.position = mainPos;
  mainSprite.rotation = mainRota;
  
  CGPoint direction = ccp(cosf(CC_DEGREES_TO_RADIANS(wanderDegree)), sinf(CC_DEGREES_TO_RADIANS(wanderDegree)));
  
  self.circleSprite = [CCSprite spriteWithFile:@"circle.png"];
  CGPoint relaBirdCirclePoint = ccpMult(direction, mainToCircleDistance);
  circleSprite.position = ccpAdd(mainSprite.position, relaBirdCirclePoint);
  circleSprite.scale = (float)circleRadius/(0.5*circleSprite.boundingBox.size.width);
  
  self.targetSprite = [CCSprite spriteWithFile:@"target.png"];
  CGPoint relaCircleTargetPoint = ccpMult(direction, circleRadius);
  targetSprite.position = ccpAdd(circleSprite.position, relaCircleTargetPoint);
}

#pragma mark -
#pragma mark Init

-(id)initStandardWithMainPosition:(CGPoint)mainPos{
  if ( (self = [super init]) ) {
    wanderDegree = 0;
    self.maxSpeed = 2.0f;
    self.mainToCircleDistance = 100.0f;
    self.circleRadius = 50.0f;
    self.circleDegreeNoise = 10.0f;
    
    [self setVisibilityWithMainPosition:mainPos mainRotation:-wanderDegree];
  }
  
  return self;
}

-(id)initWithMainPosition:(CGPoint)mainPos mainRoration:(float)mainRota maxSpeed:(float)maxSpee mainToCircleDistance:(float)mainToCircleDis circleRaduis:(float)circleRadiu circleDegreeNoise:(float)circleDegreeNois {
  if ( (self = [super init]) ) {
    wanderDegree = -mainRota;
    self.maxSpeed = maxSpee;
    self.mainToCircleDistance = mainToCircleDis;
    self.circleRadius = circleRadiu;
    self.circleDegreeNoise = circleDegreeNois;
    
    [self setVisibilityWithMainPosition:mainPos mainRotation:mainRota];
  }
  
  return self;
}

- (void) dealloc {
  self.mainSprite = nil;
  self.circleSprite = nil;
  self.targetSprite = nil;
  
	[super dealloc];
}

@end
