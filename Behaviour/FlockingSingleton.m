//
//  FlockingSingleton.m
//  BasicCocos2D
//
//  Created by Ian Fan on 19/10/12.
//
//

#import "FlockingSingleton.h"

@implementation FlockingSingleton
@synthesize visibilityArray;

+(id)sharedInstance {
  static id shared = nil;
  if (shared == nil) shared = [[FlockingSingleton alloc]init];
  
  return shared;
}

/*
 public function flock(vehicles:Array):void {
 var averageVelocity:Vector2D = velocity.cloneVector(); // used for alignment.
 //starting with the current vehicles velocity keeps the vehicles from stopping
 var averagePosition:Vector2D = new Vector2D(); //used for cohesion
 var counter:int = 0;//used for cohesion
 for(var i:int = 0; i < vehicles.length; i++) {//for each vehicle
 var vehicle:Vehicle = vehicles[i] as Vehicle;
 if(vehicle != this && isInSight(vehicle)) {//if it is not the current vehicle
 //and it is in sight
 averageVelocity.add(vehicle.velocity); //add its velocity to the average velocity
 averagePosition.add(vehicle.position);//add its position to the average position
 if(isTooClose(vehicle)) {//if it is too close
 flee(vehicle.position);//flee it, this is separation
 }
 counter++;//increase the counter to use for finding the average
 }
 }
 if(counter > 0) {//if there are vehicles around
 averageVelocity.divide(counter);//divide to find average
 averagePosition.divide(counter);//divide to find average
 seek(averagePosition);//seek the average, this is cohesion
 velocity.add(averageVelocity.subtract(velocity).divide(mass).truncate(_maxForce));
 //add the average velocity to the velocity after adjusting the force
 //this is alignment
 }
 }
 */

//First, isInSight. This checks whether the vehicle is close to the current vehicle. If it is, we use it to find averages.
/*
 public function isInSight(vehicle:Vehicle):Boolean {
 if(position.distance(vehicle.position) > 120) {//this is changed based on the desired flocking style
 return false;//you are too far away, do nothing
 }
 var direction:Vector2D = velocity.cloneVector().normalize();//get the direction
 var difference:Vector2D = vehicle.position.cloneVector().subtract(position);//find the difference of the two positions
 var dotProd:Number = difference.dotProduct(direction);//dotProduct
 
 if(dotProd < 0) {
 return false;//you are too far away and not facing the right direction
 }
 return true;//you are in sight.
 }
 */

//The other function is isTooClose.
/*
 public function isTooClose(vehicle:Vehicle):Boolean {
 return position.distance(vehicle.position) < 80;
 }
 */

#pragma mark -
#pragma mark Update

-(void)update {
  for (CCSprite *mainSprite in visibilityArray) {
    float mainRadians = CC_DEGREES_TO_RADIANS(-mainSprite.rotation);
    CGPoint mainDirection = ccpNormalize(ccp(cosf(mainRadians), sinf(mainRadians)));
    CGPoint mainVelocity = ccpMult(mainDirection, self.mainMaxSpeed);
    
    CGPoint averageVelocity = mainVelocity;// used for alignment. //starting with the current vehicles velocity keeps the vehicles from stopping
    CGPoint averagePosition = mainSprite.position;//used for cohesion
    int counter = 1;//used for cohesion
    
    for (CCSprite *otherSprite in visibilityArray) {
      if (mainSprite != otherSprite && [self isInSightWithMainSprite:mainSprite otherSprite:otherSprite]==YES) {
        float otherRadians = CC_DEGREES_TO_RADIANS(-otherSprite.rotation);
        CGPoint otherDirection = ccpNormalize(ccp(cosf(otherRadians), sinf(otherRadians)));
        CGPoint otherVelocity = ccpMult(otherDirection, self.mainMaxSpeed);
        
        averageVelocity = ccpAdd(averageVelocity, otherVelocity);//add its velocity to the average velocity
        averagePosition = ccpAdd(averagePosition, otherSprite.position);//add its position to the average position
        counter ++;//increase the counter to use for finding the average
        
        if ([self isTooCloseWithMainSprite:mainSprite otherSprite:otherSprite] == YES) {
          //flee it, this is separation
          CGPoint fleeDirection = ccpNeg(ccpNormalize(ccpSub(otherSprite.position, mainSprite.position)));
          CGPoint fleeVelocity = ccpMult(fleeDirection, self.mainMaxSpeed);
          
          CGPoint fleeForce = ccpSub(fleeVelocity, mainVelocity);
//          float averageToMainDistance = ccpDistance(averagePosition, mainSprite.position);
          fleeForce = ccpMult(fleeForce, 0.05);
          mainVelocity = ccpAdd(mainVelocity, fleeForce) ;
        }
      
      }
    }
      
    if(counter > 1) {//if there are vehicles around
      averageVelocity = ccpMult(averageVelocity, 1.0f/(float)counter);//divide to find average
      averagePosition = ccpMult(averagePosition, 1.0f/(float)counter);//divide to find average
      {
      //seek the average, this is cohesion
      CGPoint seekDirection = ccpNormalize(ccpSub(averagePosition, mainSprite.position));
      CGPoint seekVelocity = ccpMult(seekDirection, self.mainMaxSpeed);
      
      CGPoint seekForce = ccpSub(seekVelocity, mainVelocity);
      seekForce = ccpMult(seekForce, 0.05);
      
      mainVelocity = ccpAdd(mainVelocity, seekForce) ;
      }
      
    }
    
    mainSprite.rotation = -CC_RADIANS_TO_DEGREES(ccpToAngle(mainVelocity));
    mainSprite.position = ccpAdd(mainSprite.position, mainVelocity);
    [self wrapAroundWithSprite:mainSprite];
  }
  
}

-(BOOL)isInSightWithMainSprite:(CCSprite*)mainSprit otherSprite:(CCSprite*)otherSprit {
  BOOL inSight = NO;
  
  float otherToMainDistance = ccpDistance(otherSprit.position, mainSprit.position);
  if (otherToMainDistance > 120) return inSight = NO;
  
  float otherRadians = CC_DEGREES_TO_RADIANS(-otherSprit.rotation);
  CGPoint otherDirection = ccpNormalize(ccp(cosf(otherRadians), sinf(otherRadians)));
  CGPoint difference = ccpSub(otherSprit.position, mainSprit.position);
  float dotProduction = ccpDot(difference, otherDirection);
  
  if (dotProduction <0) return  inSight = NO;
  else return inSight = YES;
  
  return inSight=YES;
}

-(BOOL)isTooCloseWithMainSprite:(CCSprite*)mainSprit otherSprite:(CCSprite*)otherSprit {
  BOOL tooClose = NO;
  
  float otherToMainDistance = ccpDistance(otherSprit.position, mainSprit.position);
  if (otherToMainDistance <= 0.5*mainSprit.boundingBox.size.width + 0.5*otherSprit.boundingBox.size.width) tooClose = YES;
  
  return tooClose;
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
  CCSprite *sprite = [CCSprite spriteWithFile:@"circleGreen.png"];
  sprite.position = pos;
  sprite.rotation = 360*CCRANDOM_0_1();
  
  [self.visibilityArray addObject:sprite];
}

-(void)setStandard {
  self.mainMaxSpeed = 2.0f;
  self.checkLength = 50;
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  int number = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 100:30;
  for (int i=0; i<number; i++) {
    CGPoint point = ccp((float)winSize.width*0.1*(i%10), (float)(i/10.0f)*winSize.height*0.1);
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
