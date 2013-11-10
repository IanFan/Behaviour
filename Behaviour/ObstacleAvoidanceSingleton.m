//
//  ObstacleAvoidanceSingleton.m
//  BasicCocos2D
//
//  Created by Ian Fan on 17/10/12.
//
//

#import "ObstacleAvoidanceSingleton.h"

@implementation ObstacleAvoidanceSingleton
@synthesize visibilityArray;

+(id)sharedInstance {
  static id shared = nil;
  if (shared == nil) shared = [[ObstacleAvoidanceSingleton alloc]init];
  
  return shared;
}

#pragma mark -
#pragma mark Update

-(void)update {
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
  if ([self.visibilityArray count] <=0) return;
  for (id idOj in self.visibilityArray) {
    if ([[parentLay children] containsObject:idOj] == NO) [parentLay addChild:idOj];
  }
}

-(void)removeVisibilityFromParent:(CCLayer *)parentLay {
  for (id idOj in self.visibilityArray) {
    [idOj removeFromParentAndCleanup:NO];
  }
  
  [self.visibilityArray removeAllObjects];
}

#pragma mark -
#pragma mark Set

-(void)addNewCricleWithPosition:(CGPoint)pos Radius:(float)radius {
  CCSprite *circleSprite = [CCSprite spriteWithFile:@"circle.png"];
  circleSprite.position = pos;
  circleSprite.scale = (float)radius/circleSprite.boundingBox.size.width*0.5;
  
  [self.visibilityArray addObject:circleSprite];
}

-(void)setStandard {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  int obstacleNumber = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 6:6;
  for (int i=0; i<obstacleNumber; i++) {
    CGPoint point = ccp(winSize.width*(0.2+0.8*CCRANDOM_0_1()), winSize.height*CCRANDOM_0_1());
    float radius = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 100+200*CCRANDOM_0_1():50+100*CCRANDOM_0_1();
    
    [self addNewCricleWithPosition:point Radius:radius];
  }
}


#pragma mark -
#pragma mark Init

-(id)init {
  if ((self = [super init])) {
    self.visibilityArray = [[NSMutableArray alloc]init];
  }
  
  return self;
}

@end
