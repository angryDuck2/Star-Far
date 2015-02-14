//
//  STFMyScene.m
//  Star Farts
//
//  Created by Aggelos Papageorgiou on 14/4/14.
//  Copyright (c) 2014 Aggelos. All rights reserved.
//

#import "STFMyScene.h"
static const uint32_t shipCategory =  0x1 << 0;
static const uint32_t obstacleCategory =  0x1 << 1;
static const float BG_VELOCITY = 100.0;
static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}
@implementation STFMyScene {
    SKSpriteNode *ship;
    SKCropNode *cropNode;
    
    SKAction *actionMoveUp;
    SKAction *actionMoveDown;
    NSTimeInterval _dt;
    NSTimeInterval _lastUpdateTime;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor=[UIColor blackColor];
        [self addShip];
        
        
        
        
        
        [self cropNodes];
        
        //Making self delegate of physics World
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
    }
    
    return self;
}



-(void)addShip
{
    //initalizing spaceship node
    ship = [SKSpriteNode new];
    ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship.png"];
    [ship setScale:0.2];
    ship.zRotation = - M_PI / 2;
    
    //Adding SpriteKit physicsBody for collision detection
    ship.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(ship.size.height/3,ship.size.width/3)];
    ship.physicsBody.categoryBitMask = shipCategory;
    ship.physicsBody.dynamic = YES;
    ship.physicsBody.contactTestBitMask = obstacleCategory;
    ship.physicsBody.collisionBitMask = 0;
    ship.name = @"ship";
    ship.position = CGPointMake(120,160);
    ship.zPosition=2;
    
    
    actionMoveUp = [SKAction moveByX:0 y:30 duration:.2];
    actionMoveDown = [SKAction moveByX:0 y:-30 duration:.2];
    [self addChild:ship];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene]; //1
    if(touchLocation.y >ship.position.y){ //2
        if(ship.position.y < 270){ //3
            [ship runAction:actionMoveUp]; //4
        }
    }else{
        if(ship.position.y > 50){
            [ship runAction:actionMoveDown]; //5
        }
    }
}


- (void) cropNodes
{
    // the parent node i will add to screen
    SKSpriteNode *picFrame = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(960,640)];
    picFrame.position = CGPointMake(120, 160);
    picFrame.name=@"PicFrame";
    
    // the part I want to run action on
    SKSpriteNode *pic = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Spaceship"]];
    pic.name = @"PictureNode";
    [pic setScale:0.2];
    pic.zRotation=-M_PI/2;
    
    SKShapeNode *circleMask = [[SKShapeNode alloc ]init];
    CGMutablePathRef circle = CGPathCreateMutable();
    CGPathAddArc(circle, NULL, CGRectGetMidX(cropNode.frame), CGRectGetMidY(cropNode.frame), 25, 0, M_PI*2, YES); // replace 50 with HALF the desired radius of the circle
    circleMask.path = circle;
    circleMask.lineWidth = 50; // replace 100 with DOUBLE the desired radius of the circle
    circleMask.strokeColor = [SKColor blueColor];
    circleMask.name=@"circleMask";
    
    cropNode = [SKCropNode node];
    [cropNode addChild:pic];
    [cropNode setMaskNode:circleMask];
    [picFrame addChild:cropNode];
    [self addChild:picFrame];
    
    // run action in this scope
    //[pic runAction:[SKAction moveBy:CGVectorMake(30, 30) duration:10]];
    
    // outside scope - pass its parent
    
}

- (void) moveTheThing:(SKNode *) theParent
{
    // the child i want to move
    
    SKSpriteNode *moveThisThing = (SKSpriteNode *)[theParent   childNodeWithName:@"PicFrame"];
    [moveThisThing setAnchorPoint:ship.anchorPoint];
   
    [moveThisThing runAction:[SKAction moveTo:CGPointMake(ship.position.x,ship.position.y)duration:.2]];
}



-(void)update:(CFTimeInterval)currentTime {
    
    if (_lastUpdateTime)
    {
        _dt = currentTime - _lastUpdateTime;
    }
    else
    {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    [self moveTheThing:self];
}
@end
