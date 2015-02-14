//
//  STFViewController.m
//  Star Farts
//
//  Created by Aggelos Papageorgiou on 14/4/14.
//  Copyright (c) 2014 Aggelos. All rights reserved.
//

#import "STFViewController.h"
#import "STFMyScene.h"
#import "STFMyScene.h"
@implementation STFViewController

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [STFMyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
