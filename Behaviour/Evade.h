//
//  Evade.h
//  BasicCocos2D
//
//  Created by Ian Fan on 16/10/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TargetSingleton.h"

@interface Evade : NSObject
{
}

@property (nonatomic,retain) CCSprite *mainSprite;

@property float mainMaxSpeed;

-(id)initStandardWithMainPosition:(CGPoint)mainPos;
-(id)initWithMainPosition:(CGPoint)mainPos mainRotation:(float)mainRota mainMaxSpeed:(float)mainMaxSpee;

-(void)update;

-(void)addVisibilityToParent:(CCLayer*)parentLay;
-(void)removeVisibilityFromParent:(CCLayer*)parentLay;

@end
