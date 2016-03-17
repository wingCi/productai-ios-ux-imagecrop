//
//  CustomLayerDemo.m
//  MLImageCropDemo
//
//  Created by Haihan Wang on 16/3/2.
//  Copyright © 2016年 Malong Tech. All rights reserved.
//

#import "CustomLayerDemo.h"
#import "MLImageCropController.h"
#import "MLShadeView.h"
#import "ViewController.h"

/**
 *  custom view to be added
 */
@interface CustomView : UIView <MLCustomViewDelegate>
@property (nonatomic, strong) MLImageCropController *controller;
@property (nonatomic, strong) UIButton *btn;
@end
@implementation CustomView
- (instancetype)init {
    self = [super init];
    if (self) {
        _btn = [ViewController buttonCreator:@"Change Color"
                                      target:self
                                      action:@selector(changeColor:)
                                       frame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:_btn];
    }
    return self;
}
- (void)setSuperViewFrame:(CGRect)superViewFrame controller:(MLImageCropController *)controller {

    self.frame = CGRectMake(superViewFrame.origin.x, superViewFrame.origin.y + 50, superViewFrame.size.width,
                            superViewFrame.size.height - 50);
    // superViewFrame is the bounds of current crop controller
    CGRect btnFrame = CGRectMake(superViewFrame.origin.x + superViewFrame.size.width / 2 - 100,
                                 superViewFrame.origin.y + superViewFrame.size.height / 2 - 50 - 25, 200, 50);
    _btn.frame = btnFrame;
    _controller = controller;
}
- (void)changeColor:(UIButton *)sender {

    // you can customize the crop box by set the property of shadeView
    _controller.shadeView.cropBorderColor = [CustomView getRandomColor];
    _controller.shadeView.pointColor = [CustomView getRandomColor];
    _controller.shadeView.cropAreaColor = [CustomView getRandomColor];
    _controller.shadeView.cropMaskColor = [CustomView getRandomColor];
    _controller.shadeView.cropBorderColor = [CustomView getRandomColor];

    _controller.shadeView.cropBorderWidth = arc4random() % 10;
    _controller.shadeView.pointRadius = arc4random() % 10;

    [_controller.shadeView setNeedsDisplay];
}
+ (UIColor *)getRandomColor {
    return [UIColor colorWithRed:(arc4random() % 10) / 10.0f
                           green:(arc4random() % 10) / 10.0f
                            blue:(arc4random() % 10) / 10.0f
                           alpha:(arc4random() % 10) / 10.0f];
}
@end

// demo:
@interface CustomLayerDemo () <MLImageCropControllerDelegate>

@end
@implementation CustomLayerDemo
- (void)run:(UIImage *)image {

    // step 1: init controller with image and set delegate
    MLImageCropController *cropController = [[MLImageCropController alloc] initWithImage:image];
    cropController.delegate = self;

    // step 2: set the custom view
    cropController.customView = [[CustomView alloc] init];

    // step 3: show it by present or push into navigation controller
    UIViewController *currentController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navController = [[UINavigationController alloc] init];
    [currentController presentViewController:navController
                                    animated:NO
                                  completion:^{
                                      // push controller into navigation controller
                                      [navController pushViewController:cropController animated:YES];
                                  }];
}

// step 4: handle the delegate of done,cancle and crop box changed(option).
#pragma mark - ImageCropViewControllerDelegate
- (void)MLImageCropDone:(MLImageCropController *)controller
           croppedImage:(UIImage *)croppedImage
            croppedRect:(CGRect)croppedRect {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)MLImageCropCancel:(MLImageCropController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)MLImageCropAreaChanged:(MLImageCropController *)controller croppedRect:(CGRect)croppedRect {
}
@end
