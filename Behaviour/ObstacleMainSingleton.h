//
//  ObstacleMainSingleton.h
//  BasicCocos2D
//
//  Created by Ian Fan on 17/10/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ObstacleAvoidanceSingleton.h"

@interface ObstacleMainSingleton : NSObject

@property (nonatomic,retain) NSMutableArray *mainArray;
@property (nonatomic,retain) CCSprite *targetSprite;
@property CGPoint targetPosition;
@property float mainMaxSpeed;

+(id)sharedInstance;

-(void)setStandard;

-(void)update;

-(void)addVisibilityToParent:(CCLayer*)parentLay;
-(void)removeVisibilityFromParent:(CCLayer*)parentLay;

@end
