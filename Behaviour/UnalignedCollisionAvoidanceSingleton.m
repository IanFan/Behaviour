//
//  UnalignedCollisionAvoidanceSingleton.m
//  BasicCocos2D
//
//  Created by Ian Fan on 18/10/12.
//
//

#import "UnalignedCollisionAvoidanceSingleton.h"

@implementation UnalignedCollisionAvoidanceSingleton
@synthesize visibilityArray;

+(id)sharedInstance {
  static id shared = nil;
  if (shared == nil) shared = [[UnalignedCollisionAvoidanceSingleton alloc]init];
  
  return shared;
}

/*
 public function unalignedAvoidance(vehicles:Array):void {
 for(var i:int = 0; i < vehicles.length; i++) { //check each vehicle
 var forward:Vector2D = velocity.cloneVector().normalize(); //get the forward vector
 var diff:Vector2D = vehicles[i].position.cloneVector().add(vehicles[i].velocity.cloneVector().normalize().multiply(checkLength)).subtract(position);

 var dotProd:Number = diff.dotProduct(forward);//dot product between forward and difference
 if(dotProd > 0) {//they may meet in the future
 var ray:Vector2D = forward.cloneVector().multiply(checkLength); //cast a ray in the forward direction
 var projection:Vector2D = forward.cloneVector().multiply(dotProd); //project the forward vector
 var dist:Number = projection.cloneVector().subtract(diff).length; //get the distance
 
 if(dist < vehicles[i].radius + width && projection.length < ray.length) { //they will meet in the future, we need to fix it
 var force:Vector2D = forward.cloneVector().multiply(maxSpeed);//get the maximum change
 force.angle += diff.sign(velocity) * Math.PI / 4;//rotate it away from the site of the collision
 force.multiply(1 - projection.length / ray.length);//scale it based on the distance between the position and collision site
 velocity.add(force);//adjust the velocity
 velocity.multiply(projection.length / ray.length);//scale the velocity
 */

#pragma mark -
#pragma mark Update

-(void)update {
  for (CCSprite *mainSprite in visibilityArray) {
    float checkLength = 80;
    
    float mainRadians = CC_DEGREES_TO_RADIANS(-mainSprite.rotation);
    CGPoint mainDirection = ccpNormalize(ccp(cosf(mainRadians), sinf(mainRadians)));
    CGPoint mainVelocity = ccpMult(mainDirection, self.mainMaxSpeed);
    
    for (CCSprite *obstacleSprite in visibilityArray) {
      if (mainSprite != obstacleSprite) {
        float obstacleRadians = CC_DEGREES_TO_RADIANS(-obstacleSprite.rotation);
        CGPoint obstacleDirection = ccpNormalize(ccp(cosf(obstacleRadians), sinf(obstacleRadians)));
        CGPoint difference = ccpSub(ccpAdd(ccpMult(obstacleDirection, checkLength), obstacleSprite.position), mainSprite.position);
        float dotProduct = ccpDot(difference, mainDirection);
        
//        if (dotProduct > 0) {
          CGPoint ray = ccpMult(mainDirection, checkLength);
          CGPoint projection = ccpMult(mainDirection, dotProduct);
          float distance = ccpLength(ccpSub(projection, difference));
          
          if (distance < (20 + 20) && ccpLength(projection) <= ccpLength(ray)) {
            CGPoint force = ccpMult(mainDirection, self.mainMaxSpeed);
            float forceRadians = ccpToAngle(force);
            forceRadians +=  ccpAngleSigned(difference, mainVelocity);
            force = ccpMult(ccp(cosf(forceRadians), sinf(forceRadians)), ccpLength(force));
            force = ccpMult(force,(1- ccpLength(projection)/ccpLength(ray)));
            
            mainVelocity = ccpAdd(mainVelocity, force);
            mainDirection = ccpMult(mainVelocity, ccpLength(projection)/ccpLength(ray));
          }
//        }
      
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

-(void)addNewMainWithPosition:(CGPoint)pos {
  CCSprite *sprite = [CCSprite spriteWithFile:@"circleYellow.png"];
  sprite.position = pos;
  sprite.rotation = 360*CCRANDOM_0_1();
  
  [self.visibilityArray addObject:sprite];
}

-(void)setStandard {
  self.mainMaxSpeed = 2.0f;
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  for (int i=0; i<10; i++) {
    CGPoint point = ccp(winSize.width*CCRANDOM_0_1(), winSize.height*CCRANDOM_0_1());
    [self addNewMainWithPosition:point];
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
