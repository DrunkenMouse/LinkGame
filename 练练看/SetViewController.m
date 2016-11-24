//
//  SetViewController.m
//  练练看
//
//  Created by 王奥东 on 16/11/23.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController {
    
    IBOutlet UIButton *_simpleButton;
    
    IBOutlet UIButton *_troubleButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_simpleButton setHidden:YES];
    [_troubleButton setHidden:YES];
    
    [self performSelector:@selector(buttonAnimation) withObject:self afterDelay:0.2];
}

-(void)buttonAnimation{

    
    
    CATransition *transion = [CATransition animation];
    transion.type = kCATransitionMoveIn;
    transion.duration = 2.0;
    [_simpleButton setHidden:NO];
    [_simpleButton.layer addAnimation:transion forKey:@"simpleButton"];
    
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionMoveIn;
    anima.subtype = kCATransitionFromRight;
    anima.duration = 2.0;
    [_troubleButton setHidden:NO];
    [_troubleButton.layer addAnimation:anima forKey:@"troubleButton"];
    
}



@end
