//
//  MainViewController.m
//  HeartBeats
//
//  Created by Christian Roman on 30/08/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "StartCameraViewController.h"

@interface StartCameraViewController ()

{
    AVCaptureSession *session;
    NSMutableArray *points;
    UIImageView *remindPicture;
}

@end

@implementation StartCameraViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _titleLabel.text=NSLocalizedString(@"startTitle", @"");
    remindPicture=[[UIImageView alloc]initWithFrame:CGRectMake((ViewWidth-300)/2, ViewHeight/3, 300, ViewHeight/3)];
    UIImage *pic = [UIImage imageNamed:@"howToPlaceFinger22.jpg"];
    [remindPicture setImage:pic];
    [self.view addSubview:remindPicture];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self setupAVCapture];
}

- (void)setupAVCapture
{
    // Get the default camera device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([device isTorchModeSupported:AVCaptureTorchModeOn])
    {
        [device lockForConfiguration:nil];
        device.torchMode=AVCaptureTorchModeOn;
        [device setTorchMode:AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
    
    // Create the AVCapture Session
    session = [[AVCaptureSession alloc]init];
    [session beginConfiguration];
    
    // Create a AVCaptureDeviceInput with the camera device
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error %d", (int)[error code]]
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        //[self teardownAVCapture];
        return;
    }
    
    if ([session canAddInput:deviceInput])
        [session addInput:deviceInput];
    
    // AVCaptureVideoDataOutput
    
    AVCaptureVideoDataOutput *videoDataOutput = [AVCaptureVideoDataOutput new];
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    
    if ([session canAddOutput:videoDataOutput])
        [session addOutput:videoDataOutput];
    AVCaptureConnection* connection = [videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    [device setActiveVideoMinFrameDuration:CMTimeMake(1, 10)];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    [session commitConfiguration];
    [session startRunning];
}

-(void)setRemindBeat:(NSString *)remind
{
    _remindBeatLabel.text=remind;
}

- (void)stopAVCapture
{
    [session stopRunning];
    session = nil;
    points = nil;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"TestView"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)stopAVCaptureFail
{
    [session stopRunning];
    session = nil;
    points = nil;
    _myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    _myAppDelegate.SucessOrNot=NO;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"RootView"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    uint8_t *buf = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    float r = 0, g = 0,b = 0;
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width * 4; x += 4) {
            b += buf[x];
            g += buf[x+1];
            r += buf[x+2];
        }
        buf += bytesPerRow;
    }
    r /= 255 * (float)(width * height);
    g /= 255 * (float)(width * height);
    b /= 255 * (float)(width * height);
    
    
    if([self CompareRGB:r*=255 Green:g*=255 Blue:b*=255])
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            [self stopAVCapture];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            [self setRemindBeat:NSLocalizedString(@"remindContent", @"")];
        });
        
    }
}

-(BOOL) CompareRGB:(float)r Green:(float)g Blue:(float)b
{
    if([self getInt:r Int:255]+[self getInt:g Int:12]+[self getInt:b Int:42]<100)
    {
        return YES;
    }
    return NO;
    
}

-(int)getInt:(int)a Int:(int)b
{
    if(a-b>0)
    {
        return a-b;
    }
    else
    {
        return b-a;
    }
}

-(IBAction)shutDownCamera:(id)sender
{
    [self stopAVCaptureFail];
}

@end
