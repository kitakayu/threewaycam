//
//  ViewController.m
//  Cameramasa
//
//  Created by masahide on 2014/09/30.
//  Copyright (c) 2014年 masahide. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    IBOutlet UIImageView *aImageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doCamera:(id)sender {
    NSLog(@"カメラ");
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController
          isSourceTypeAvailable:sourceType]) {
        return;
    }
    
    //カメラ起動
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    [ipc setSourceType:sourceType];
    [ipc setDelegate:self];
    [ipc setAllowsEditing:YES];
    [self presentViewController:ipc animated:YES completion:^{
        //ステータスバーを隠す
        [UIApplication sharedApplication].statusBarHidden = YES;
    }];
}

//撮影ボタンを押したときによばれるUIImagePickerControllerDelegateメソッド
- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"撮影");
    //infoからUIImagePickerControllerEditedImageキーを持ってきてaImageインスタンスに格納
    UIImage *aImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [aImageView setImage:aImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        // ステータスバーを表示する
        [UIApplication sharedApplication].statusBarHidden = NO;
    }];
}

//キャンセルボタンが押されたとき
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"キャンセル");
    [picker dismissViewControllerAnimated:YES completion:^{
        //ステータスバーを表示する
        [UIApplication sharedApplication].statusBarHidden = NO;
    }];
}

- (IBAction)doFilter:(id)sender {
    NSLog(@"フィルタ");
    //アクションシートを表示させる
    UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:@"フィルターを選択"
                                                        delegate:self
                                               cancelButtonTitle:@"キャンセル"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"セピア",@"モノクロ",@"色反転", nil];
    
    [aSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [aSheet showInView:[self view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //ボタン１用
    if ( buttonIndex == 0 ) {
        NSLog(@"セピア");
        [self toSepia];
        //ボタン２用
    }else if ( buttonIndex == 1 ) {
        NSLog(@"モノクロ");
        [self toMono];
        //ボタン３用
    }else if ( buttonIndex == 2 ) {
        NSLog(@"色反転");
        [self toBlue];
        //キャンセル含めてそれ以外
    } else {
        NSLog(@"キャンセル含めてそれ以外");
    }
}


//セピアフィルター処理
-(void)toSepia {
    UIImage *orgImage = [aImageView image];
    
    //空だったときの処理
    if ( orgImage == nil ) {
        return;
    }
    
    // CIImageの作成
    CIImage *ciImage = [[CIImage alloc] initWithImage:orgImage];
    
    // CIFilterの作成
    CIFilter *ciFilter = [CIFilter filterWithName:@"CISepiaTone"
                                    keysAndValues:kCIInputImageKey, ciImage, //kCIInputImageKeyというキーにciImageという値
                          @"inputIntensity", [NSNumber numberWithFloat:0.8], //明るさの指定
                          nil
                          ];
    
    // フィルタをかけた画像をImage Viewに格納
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImgRef = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgImgRef scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(cgImgRef);
    [aImageView setImage:newImage];
}

//モノクロフィルター処理
- (void)toMono{
    UIImage *orgImage = [aImageView image];
    
    //空だったときの処理
    if ( orgImage == nil) {
        return;
    }
    
    //CIImageの作成
    CIImage *ciImage = [[CIImage alloc] initWithImage:orgImage];
    
    //CIFilterの作成
    CIFilter *ciFilter = [CIFilter filterWithName:@"CIColorMonochrome" //フィルター名
                                    keysAndValues:kCIInputImageKey, ciImage,
                          @"inputColor", [CIColor colorWithRed:0.75 green:0.75 blue:0.75], //パラメータ
                          @"inputIntensity", [NSNumber numberWithFloat:1.0], //パラメータ
                          nil
                          ];
    
    // フィルタをかけた画像をImage Viewに格納
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImgRef = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgImgRef scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(cgImgRef);
    [aImageView setImage:newImage];
    
}

//色反転フィルター処理
- (void)toBlue{
    UIImage *orgImage = [aImageView image];
    
    //空だったときの処理
    if ( orgImage == nil) {
        return;
    }
    
    //CIImageの作成
    CIImage *ciImage = [[CIImage alloc] initWithImage:orgImage];
    
    
    //CIFilterの作成
    CIFilter *ciFilter = [CIFilter filterWithName:@"CIColorInvert" //フィルター名
                                    keysAndValues:kCIInputImageKey, ciImage,
                          nil
                          ];
    
    // フィルタをかけた画像をImage Viewに格納
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImgRef = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgImgRef scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(cgImgRef);
    [aImageView setImage:newImage];
    
}



//保存ボタンが押されたときの処理
- (IBAction)doSave:(id)sender {
    NSLog(@"保存");
    UIImage *aImage = [aImageView image];
    if ( aImage == nil ) {
        return;
    }
    UIImageWriteToSavedPhotosAlbum(aImage,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
}

//保存の処理
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"保存終了");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存終了"
                                                    message:@"写真アルバムに画像を保存しました。"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
