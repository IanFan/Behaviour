//
//  UnalignedCollisionAvoidanceSingleton.h
//  BasicCocos2D
//
//  Created by Ian Fan on 18/10/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface UnalignedCollisionAvoidanceSingleton : NSObject

@property (nonatomic,retain) NSMutableArray *visibilityArray;
@property float mainMaxSpeed;

+(id)sharedInstance;

-(void)setStandard;

-(void)addNewMainWithPosition:(CGPoint)pos;

-(void)update;

-(void)addVisibilityToParent:(CCLayer*)parentLay;
-(void)removeVisibilityFromParent:(CCLayer*)parentLay;

@end
