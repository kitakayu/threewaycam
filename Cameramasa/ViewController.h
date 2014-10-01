//
//  ViewController.h
//  Cameramasa
//
//  Created by masahide on 2014/09/30.
//  Copyright (c) 2014年 masahide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface ViewController : UIViewController
<
UINavigationControllerDelegate, // カメラ用
UIImagePickerControllerDelegate, // カメラ用
UIActionSheetDelegate //アクションシート用
>

- (IBAction)doCamera:(id)sender;
- (IBAction)doFilter:(id)sender;
- (IBAction)doSave:(id)sender;

@end
