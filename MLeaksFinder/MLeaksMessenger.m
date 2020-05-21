/**
 * Tencent is pleased to support the open source community by making MLeaksFinder available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 *
 * https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

#import "MLeaksMessenger.h"

@interface MLeaksMessenger ()
@property(nonatomic, strong) UIWindow * alertView;
@end

static __weak UIAlertController *alertController;

@implementation MLeaksMessenger

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    [self alertWithTitle:title message:message additionalButtonTitle:nil handler:nil];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message additionalButtonTitle:(NSString *)additionalButtonTitle handler:(void (^)(UIAlertAction *action))handler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    if (additionalButtonTitle == nil) {
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler]];
    } else {
        [alert addAction:[UIAlertAction actionWithTitle:additionalButtonTitle style:UIAlertActionStyleDefault handler:handler]];
    }
    MLeaksMessenger *manager = [[MLeaksMessenger alloc] init];
    [manager.alertView.rootViewController presentViewController:alert animated:YES completion:nil];
    NSLog(@"%@: %@", title, message);
}

- (UIWindow *)alertView {
    if (!_alertView) {
        _alertView = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _alertView.rootViewController = [[UIViewController alloc] init];

        id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
        // Applications that does not load with UIMainStoryboardFile might not have a window property:
        if ([delegate respondsToSelector:@selector(window)]) {
            // we inherit the main window's tintColor
            _alertView.tintColor = delegate.window.tintColor;
        }
        // window level is above the top window (this makes the alert, if it's a sheet, show over the keyboard)
        UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
        _alertView.windowLevel = topWindow.windowLevel + 1;

        [_alertView makeKeyAndVisible];
    }
    return _alertView;
}

@end
