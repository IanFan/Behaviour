//
//  TargetSingleton.h
//  BasicCocos2D
//
//  Created by Ian Fan on 16/10/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TargetSingleton : NSObject

@property (nonatomic,retain) CCSprite *targetSprite;
@property float targetMaxSpeed;

+(id)sharedInstance;

-(void)setStandardWithTargetPosition:(CGPoint)targetPos;
-(void)setWithTargetPosition:(CGPoint)targetPos targetRotation:(float)targetRota targetMaxSpeed:(float)targetMaxSpee;

-(void)update;

-(void)addVisibilityToParent:(CCLayer*)parentLay;
-(void)removeVisibilityFromParent:(CCLayer*)parentLay;

@end
