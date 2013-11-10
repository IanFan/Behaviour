//
//  FlowFieldFollowingSingleton.m
//  BasicCocos2D
//
//  Created by Ian Fan on 19/10/12.
//
//

#import "FlowFieldFollowingSingleton.h"

@implementation FlowFieldFollowingSingleton
@synthesize visibilityArray,mainArray;

+(id)sharedInstance {
  static id shared = nil;
  if (shared == nil) shared = [[FlowFieldFollowingSingleton alloc]init];
  
  return shared;
}

#pragma mark -
#pragma mark Update

-(void)update {
  for (CCSprite *mainSprite in self.mainArray) {
    float mainRadians = CC_DEGREES_TO_RADIANS(-mainSprite.rotation);
    CGPoint mainDirection = ccpNormalize(ccp(cosf(mainRadians), sinf(mainRadians)));
    CGPoint mainVelocity = ccpMult(mainDirection, self.mainMaxSpeed);
    
    for (CCSprite *fieldSprite in self.visibilityArray) {
      if (CGRectContainsPoint(CGRectMake(fieldSprite.position.x-32, fieldSprite.position.y-32, 64, 64), mainSprite.position) == YES) {
        float fieldRadians = CC_DEGREES_TO_RADIANS(-fieldSprite.rotation);
        CGPoint fieldDirection = ccpNormalize(ccp(cosf(fieldRadians), sinf(fieldRadians)));
        CGPoint fieldVelocity = ccpMult(fieldDirection, self.mainMaxSpeed);
        
        CGPoint steeringForce = ccpSub(fieldVelocity, mainVelocity);
        steeringForce = ccpMult(steeringForce, 0.1);
        
        mainVelocity = ccpAdd(mainVelocity, steeringForce) ;
      }
    }
    
    mainSprite.rotation = -CC_RADIANS_TO_DEGREES(ccpToAngle(mainVelocity));
    mainSprite.position = ccpAdd(mainSprite.position, mainVelocity);
    [self wrapAroundWithSprite:mainSprite];
  }
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
  if ([self.visibilityArray count] > 0) {
    for (id idOj in self.visibilityArray) {if ([[parentLay children] containsObject:idOj] == NO) [parentLay addChild:idOj];}
  }
  
  if ([self.mainArray count] > 0) {
    for (id idOj in self.mainArray) {if ([[parentLay children] containsObject:idOj] == NO) [parentLay addChild:idOj];}
  }
}

-(void)removeVisibilityFromParent:(CCLayer *)parentLay {
  for (id idOj in self.visibilityArray) {[idOj removeFromParentAndCleanup:NO];}
  [self.visibilityArray removeAllObjects];
  
  for (id idOj in self.mainArray) {[idOj removeFromParentAndCleanup:NO];}
  [self.mainArray removeAllObjects];
}

#pragma mark -
#pragma mark Set

-(void)addNewWithPosition:(CGPoint)pos {
  CCSprite *sprite = [CCSprite spriteWithFile:@"circleGreen.png"];
  sprite.position = pos;
  sprite.rotation = 360*CCRANDOM_0_1();
  
  [self.mainArray addObject:sprite];
}

-(void)setStandard {
  self.mainMaxSpeed = 2.0f;
  self.checkLength = 50;
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  for (int i=0; i<192; i++) {
        
    CCSprite *sprite = [CCSprite spriteWithFile:@"circleWhite.png"];
    
    int random = arc4random();
    if ((int)random%3 == 2) {
      sprite.rotation = 0;
    }else if ((int)random%3 == 1) {
      sprite.rotation = 45;
    }else if ((int)random%3 == 0) {
      sprite.rotation = 90;
    }
    
    float length = 64;
    int rowAmount = 16;
    CGPoint point = ccp(0.5*length+length*(i%rowAmount), 0.5*length+length*(i/rowAmount));
    sprite.position = point;
    sprite.opacity = 80;
    sprite.scale = 1.6;
    
    [self.visibilityArray addObject:sprite];
  }
  
  for (int i=0; i<100; i++) {
    if ((i/2)%2 == 0) {
      CCSprite *sprite = [CCSprite spriteWithFile:@"circleGreen.png"];
      sprite.position = ccp((float)winSize.width*0.1*(i%10), (float)(i/10.0f)*winSize.height*0.1);
      sprite.rotation = 360*CCRANDOM_0_1();
      
      [self.mainArray addObject:sprite];
    }
    
  }
}


#pragma mark -
#pragma mark Init

-(id)init {
  if ((self = [super init])) {
    self.visibilityArray = [[NSMutableArray alloc]init];
    self.mainArray = [[NSMutableArray alloc]init];
  }
  
  return self;
}

@end
