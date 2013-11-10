//
//  WaypointSingleton.m
//  BasicCocos2D
//
//  Created by Ian Fan on 16/10/12.
//
//

#import "WaypointSingleton.h"

@implementation WaypointSingleton
@synthesize visibilityArray;

+(id)sharedInstance {
  static id shared = nil;
  if (shared == nil) shared= [[WaypointSingleton alloc]init];
  
  return shared;
}

#pragma mark -
#pragma mark Visibility

-(void)addVisibilityToParent:(CCLayer *)parentLay {
  if ([visibilityArray count] <=0) return;
  
  for (id idOj in self.visibilityArray) {
    if ([[parentLay children] containsObject:idOj] == NO) [parentLay addChild:idOj];
  }
}

-(void)removeVisibilityFromParent:(CCLayer *)parentLay {
  for (CCSprite *sprite in self.visibilityArray) {
    [sprite removeFromParentAndCleanup:NO];
  }
  
  [self.visibilityArray removeAllObjects];
}

#pragma mark -
#pragma mark Set

-(void)addSpriteToVisibilityArrayWithPosition:(CGPoint)point {
  CCSprite *sprite = [CCSprite spriteWithFile:@"target.png"];
  sprite.position = point;
  [self.visibilityArray addObject:sprite];
  
  NSString *numberString = [NSString stringWithFormat:@"%d",[visibilityArray count]];
  CCLabelTTF *label = [CCLabelTTF labelWithString:numberString fontName:@"Helvetica" fontSize:20];
  label.position = ccp(5, 15);
  [sprite addChild:label];
}

-(void)addNewWayPoint:(CGPoint)point {
  [self addSpriteToVisibilityArrayWithPosition:point];
}

-(void)setStandardWaypoint {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  CGPoint point = ccp(winSize.width/2, winSize.height/2);
  
  [self addSpriteToVisibilityArrayWithPosition:point];
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
