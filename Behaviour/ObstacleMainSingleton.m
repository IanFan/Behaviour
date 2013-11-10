//
//  ObstacleMainSingleton.m
//  BasicCocos2D
//
//  Created by Ian Fan on 17/10/12.
//
//

#import "ObstacleMainSingleton.h"

@implementation ObstacleMainSingleton
@synthesize mainArray,targetSprite,targetPosition,mainMaxSpeed;

+(id)sharedInstance {
  static id shared = nil;
  if (shared == nil) shared = [[ObstacleMainSingleton alloc]init];
  
  return shared;
}

#pragma mark -
#pragma mark Update

/*
 private var checkLength:Number = 100;//the distance to look ahead for circles
 
 public function avoidObstacles(circles:Array):void {
 for(var i:int = 0; i &lt; circles.length; i++) {//loop through the array of obstacles
 var forward:Vector2D = velocity.cloneVector().normalize();//get the forward vector
 var diff:Vector2D = circles[i].position.cloneVector().subtract(position);//get the difference between the circle and the vehicle
 var dotProd:Number = diff.dotProduct(forward);//get the dot product
 //this will be used for projection
 //much like in the <a href="http://rocketmandevelopment.com/2010/05/19/separation-of-axis-theorem-for-collision-detection/">SAT</a>
 
 if(dotProd &gt; 0) { //if this object is in front of the vehicle
 var ray:Vector2D = forward.cloneVector().multiply(checkLength); //get the ray
 var projection:Vector2D = forward.cloneVector().multiply(dotProd); //project the forward vector
 var dist:Number = projection.cloneVector().subtract(diff).length; //get the distance between the circle and vehicle
 
 if(dist &lt; circles[i].radius + width &amp;&amp; projection.length &lt; ray.length) {
 //if the circle is in your path (radius+width to check the full size of the vehicle)
 //projection.length and ray.length make sure you are within the max distance
 var force:Vector2D = forward.cloneVector().multiply(maxSpeed); //get the max force
 force.angle += diff.sign(velocity) * Math.PI / 2; //rotate it away from the cirlce
 //PI / 2 is 90 degrees, vector's angles are in radians
 //sign returns whether the vector is to the right or left of the other vector
 force.multiply(1 - projection.length / ray.length); //scale the force so that a far off object
 //doesn't drastically change the velocity
 velocity.add(force);//change the velocity
 velocity.multiply(projection.length / ray.length);//and scale again
 }
 }
 }
 }
 */

-(void)update {
  float checkLength = 300.0f;
  ObstacleAvoidanceSingleton *obstacleOj = [ObstacleAvoidanceSingleton sharedInstance];
  
  for (CCSprite *mainSprite in self.mainArray) {
    float mainRadians = CC_DEGREES_TO_RADIANS(-mainSprite.rotation);
    CGPoint mainDirection = ccpNormalize(ccp(cosf(mainRadians), sinf(mainRadians)));
    CGPoint mainVelocity = ccpMult(mainDirection, self.mainMaxSpeed);
    
    CGPoint desiredDirection = ccpNormalize(ccpSub(targetSprite.position, mainSprite.position));
    CGPoint desiredVelocity = ccpMult(desiredDirection, self.mainMaxSpeed);
    
    CGPoint steeringForce = ccpSub(desiredVelocity, mainVelocity);
    steeringForce = ccpMult(steeringForce, 0.1);
    
    mainVelocity = ccpAdd(mainVelocity, steeringForce) ;
    
    for (CCSprite *obstacleSprite in obstacleOj.visibilityArray) {
      CGPoint difference = ccpSub(obstacleSprite.position, mainSprite.position);
      float dotProduct = ccpDot(difference, mainDirection);
      
      if (dotProduct > 0) {
        CGPoint ray = ccpMult(mainDirection, checkLength);
        CGPoint projection = ccpMult(mainDirection, dotProduct);
        float dis = ccpDistance(projection, difference);
        
        if (dis < (0.5*obstacleSprite.boundingBox.size.width + 20) && ccpLength(projection) < ccpLength(ray)) {
          CGPoint force = ccpMult(mainDirection, self.mainMaxSpeed);
          float forceRadians = ccpToAngle(force);
          forceRadians += ccpAngleSigned(difference, mainVelocity);
          force = ccpMult(ccp(cosf(forceRadians), sinf(forceRadians)), ccpLength(force));
          force = ccpMult(force,(1- ccpLength(projection)/ccpLength(ray)));
          
          mainVelocity = ccpAdd(mainVelocity, force);
          mainVelocity = ccpMult(mainVelocity, ccpLength(projection)/ccpLength(ray));
        }
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
  for (id idOj in self.mainArray) {
    if ([[parentLay children] containsObject:idOj] == NO) [parentLay addChild:idOj];
  }
  
  if ([[parentLay children] containsObject:targetSprite] == NO) [parentLay addChild:targetSprite];
}

-(void)removeVisibilityFromParent:(CCLayer *)parentLay {
  for (id idOj in self.mainArray) {
    [idOj removeFromParentAndCleanup:NO];
  }
  [self.mainArray removeAllObjects];
  
  [targetSprite removeFromParentAndCleanup:NO];
}

#pragma mark -
#pragma mark Set

-(void)setStandard {
  self.mainMaxSpeed = 2;
  
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  int number = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 10:5;
  for (int i=0; i<number; i++) {
    CCSprite *sprite = [CCSprite spriteWithFile:@"circleRed.png"];
    sprite.position = ccp(0, winSize.height*(0.05+1.0*i/number));
    [self.mainArray addObject:sprite];
  }
  
  self.targetSprite = [CCSprite spriteWithFile:@"circleWhite.png"];
  targetSprite.rotation = -90;
  targetSprite.position = ccp(winSize.width*1000, winSize.height/2);
}


#pragma mark -
#pragma mark Init

-(id)init {
  if ((self = [super init])) {
    self.mainArray = [[NSMutableArray alloc]init];
  }
  
  return self;
}

@end
