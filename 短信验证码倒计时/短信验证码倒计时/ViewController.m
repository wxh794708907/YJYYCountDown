//
//  ViewController.m
//  短信验证码倒计时
//
//  Created by 远洋 on 16/2/20.
//  Copyright © 2016年 yuayang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong)IBOutlet UIButton * getIdentifyBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)startTime{
    __block int timeout= 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_getIdentifyBtn setTitle:@"重新发送验证码" forState:UIControlStateNormal];
                _getIdentifyBtn.userInteractionEnabled = YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_getIdentifyBtn setTitle:[NSString stringWithFormat:@"%zd秒后重新发送",timeout] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _getIdentifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
