//
//  Seek.h
//  BasicCocos2D
//
//  Created by Ian Fan on 15/10/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Seek : NSObject
{
}

@property (nonatomic,retain) CCSprite *mainSprite;
@property (nonatomic,retain) CCSprite *targetSprite;

@property float maxSpeed;

-(id)initStandardWithMainPosition:(CGPoint)mainPos;
-(id)initWithMainPosition:(CGPoint)mainPos mainRotation:(float)mainRota maxSpeed:(float)maxSpee targetPosition:(CGPoint)targetPos;

-(void)update;

-(void)addVisibilityToParent:(CCLayer*)parentLay;
-(void)removeVisibilityFromParent:(CCLayer*)parentLay;

@end
