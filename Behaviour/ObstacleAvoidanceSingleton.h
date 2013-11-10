//
//  ObstacleAvoidanceSingleton.h
//  BasicCocos2D
//
//  Created by Ian Fan on 17/10/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ObstacleAvoidanceSingleton : NSObject

@property (nonatomic,retain) NSMutableArray *visibilityArray;

+(id)sharedInstance;

-(void)setStandard;

-(void)addNewCricleWithPosition:(CGPoint)pos Radius:(float)radius;

-(void)update;

-(void)addVisibilityToParent:(CCLayer*)parentLay;
-(void)removeVisibilityFromParent:(CCLayer*)parentLay;

@end
