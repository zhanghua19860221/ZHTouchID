//
//  ViewController.m
//  ZHTouchID
//
//  Created by zhanghua0221 on 17/2/24.
//  Copyright © 2017年 zhanghua0221. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()
@property(nonatomic ,strong)LAContext  *context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self TouchIDTestSuccess:^
     {
         NSLog(@"       Touch ID     ");
         UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"  message:@"恭喜，您通过了Touch ID身份验证" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction * cancel= [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
         [alert addAction:cancel];
         [self presentViewController:alert animated:YES completion:nil];
     } Failure:^(NSError *error)
     {
         
         NSLog(@"        Touch ID     \n\(error)");
         UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"  message:@"抱歉，您未能通过Touch ID身份验证"  preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction * cancel= [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
         [alert addAction:cancel];
         [self presentViewController:alert animated:YES completion:nil];
         
     } Unvilabe:^(NSError *error)
     {
         NSLog(@"        Touch ID     \n\(error)");
         UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"  message:@"抱歉，Touch ID不可用"  preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction * cancel= [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
         [alert addAction:cancel];
         [self presentViewController:alert animated:YES completion:nil];
     }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

/**
 判断系统是否支持 TouchID识别功能

 */
- (BOOL)canEvaluatePolicy
{
    
    _context = [[LAContext alloc] init];
    NSError *error;
    return [_context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
}
/**
 调用指纹识别功能 方法
 
 */
-(void)TouchIDTestSuccess:(void(^)())successed Failure:(void(^)(NSError * error))failured  Unvilabe:(void(^)(NSError * error))Unvilabe
{
    NSError *error;
    BOOL isTouchAvalible = [self canEvaluatePolicy];
    if (isTouchAvalible)
    {
        [_context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error)
         {
             if (success)
             {
                 if (successed)
                 {
                     successed();
                 }
             }
             else
             {
                 if (failured)
                 {
                     failured(error);
                 }
             }
         }];
    } else
    {
        if (Unvilabe)
        {
            Unvilabe(error);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
