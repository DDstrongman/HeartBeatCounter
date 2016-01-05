//
//  MainViewController.m
//  HeartBeats
//
//  Created by Christian Roman on 30/08/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import "MainViewController.h"

static int averageHeartRate=0;
static float tempNumber=0;
static int   countNumber=0;
static float timeNumber=0;
static int   heartRate=0;

@interface MainViewController ()

{
    AVCaptureSession *session;
    CALayer* imageLayer;
    NSMutableArray *points;
}

@property (nonatomic,strong) NSArray *dataSource;


@end

@implementation MainViewController


- (HeartLive *)translationMoniterView
{
    if (!_translationMoniterView) {
        CGFloat xOffset = 10;
//        _translationMoniterView = [[HeartLive alloc] initWithFrame:CGRectMake(xOffset, CGRectGetHeight(self.view.frame)/3*2-xOffset, CGRectGetWidth(self.view.frame) - 2 * xOffset, CGRectGetHeight(self.view.frame)/3)];
        _translationMoniterView = [[HeartLive alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-300)/2,CGRectGetHeight(self.view.frame)/3*2-xOffset, 300, CGRectGetHeight(self.view.frame)/3)];
        _translationMoniterView.backgroundColor = [UIColor blackColor];
    }
    return _translationMoniterView;
}

-(UIView *)translationMoniterBackGroundView
{
    if (!_translationMoniterBackGroundView) {
        CGFloat xOffset = 10;
        _translationMoniterBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, ViewHeight/3*2-2*xOffset, CGRectGetWidth(self.view.frame) , ViewHeight/3+2*xOffset)];
        _translationMoniterBackGroundView.backgroundColor = [UIColor grayColor];
    }
    return _translationMoniterBackGroundView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.view addSubview:self.translationMoniterBackGroundView];
    [self.view addSubview:self.translationMoniterView];

    [self performAnimation];
    [self startProgress];
    
    void (^createData)(void) = ^{
        NSString *tempString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        
        NSMutableArray *tempData = [[tempString componentsSeparatedByString:@","] mutableCopy];
        [tempData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *tempDataa = @(-[obj integerValue] + 2048);
            [tempData replaceObjectAtIndex:idx withObject:tempDataa];
        }];
        self.dataSource = tempData;
        [self createWorkDataSourceWithTimeInterval:0.01];
    };
    createData();

    
    [self setupAVCapture];
    
    delayTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(stopAVCaptureSuccess) userInfo:nil repeats:NO];
}

- (void)setupAVCapture
{
    // Get the default camera device
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if([device isTorchModeSupported:AVCaptureTorchModeOn]) {
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

-(void)setHeartBeatNumber:(NSString *)heartNumber
{
    [_resultButton setTitle:heartNumber forState:NO];
}

-(void)setRemind:(NSString *)remind
{
    _remindLabel.text=@"";
}

- (void)stopAVCaptureSuccess
{
    [session stopRunning];
    session = nil;
    points = nil;
    NSNumber *myNumber = [NSNumber numberWithInt:averageHeartRate];
    [self addIntoDataSource:myNumber];
    [delayTimer invalidate];
    delayTimer = nil;
    
    [timer invalidate];
    timer = nil;
    _myAppDelegate.SucessOrNot=YES;
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"RootView"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)stopAVCaptureFail
{
    [session stopRunning];
    session = nil;
    points = nil;
    [delayTimer invalidate];
    delayTimer = nil;
    
    [timer invalidate];
    timer = nil;
    
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
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    uint8_t *buf = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
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
        float h,s,v;
        RGBtoHSV(r, g, b, &h, &s, &v);
        static float lastH = 0;
        float highPassValue = h - lastH;
        lastH = h;
        float lastHighPassValue = 0;
        float lowPassValue = (lastHighPassValue + highPassValue) / 2;
        lastHighPassValue = highPassValue;
        
        
        if(tempNumber<lowPassValue)
        {
            tempNumber=lowPassValue;
            countNumber++;
        }
        else
        {
            if(countNumber!=0)
            {
                timeNumber=countNumber*0.1*2;
                heartRate=60/timeNumber;
                countNumber=0;
            }
            tempNumber=lowPassValue;
        }
        if(heartRate>149)
        {
            
        }
        else if(heartRate>90&&heartRate<150)
        {
            averageHeartRate=(averageHeartRate+heartRate*0.7)/2;
        }
        else if(heartRate<50)
        {
            averageHeartRate=(averageHeartRate+heartRate*1.5)/2;
        }
        else
        {
            averageHeartRate=(averageHeartRate+heartRate)/2;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
            _remindLabel.text=NSLocalizedString(@"remindMeasuring", @"");
            _myAppDelegate.HeartRateOrNot=YES;
            [self setHeartBeatNumber:[[NSString alloc] initWithFormat:@"%d",averageHeartRate]];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            _remindLabel.text=NSLocalizedString(@"remindFingers", @"");
            _myAppDelegate.HeartRateOrNot=NO;
        });

    }
}

- (void)render:(CGContextRef)context value:(NSNumber *)value
{
    if(!points)
        points = [NSMutableArray new];
    [points insertObject:value atIndex:0];
    CGRect bounds = imageLayer.bounds;
	while(points.count > bounds.size.width / 2)
		[points removeLastObject];
    if(points.count == 0)
        return;
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 2);
    CGContextBeginPath(context);
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    // Flip coordinates from UIKit to Core Graphics
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, .0f, bounds.size.height);
    CGContextScaleCTM(context, scale, scale);
    
    float xpos = bounds.size.width * scale;
    float ypos = [[points objectAtIndex:0] floatValue];
    
    CGContextMoveToPoint(context, xpos, ypos);//出错
    //Assertion failed: (CGFloatIsValid(x) && CGFloatIsValid(y)), function void CGPathMoveToPoint(CGMutablePathRef, const CGAffineTransform *, CGFloat, CGFloat), file Paths/CGPath.cc, line 254.
    for(int i = 1; i < points.count; i++) {
        xpos -= 5;
        float ypos = [[points objectAtIndex:i] floatValue];
        CGContextAddLineToPoint(context, xpos, bounds.size.height / 2 + ypos * bounds.size.height / 2);
    }
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v ) {
	float min, max, delta;
	min = MIN( r, MIN(g, b ));
	max = MAX( r, MAX(g, b ));
	*v = max;
	delta = max - min;
	if( max != 0 )
		*s = delta / max;
	else {
		*s = 0;
		*h = -1;
		return;
	}
	if( r == max )
		*h = ( g - b ) / delta;
	else if( g == max )
		*h = 2 + (b - r) / delta;
	else
		*h = 4 + (r - g) / delta;
	*h *= 60;
	if( *h < 0 )
		*h += 360;
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

- (void)addIntoDataSource:(NSNumber *)BeatsNumber
{
    HeartBeatsInfo* hbi=(HeartBeatsInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"HeartBeatsInfo" inManagedObjectContext:self.myAppDelegate.managedObjectContext];
    [hbi setBeats:BeatsNumber];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timetemp=[dateformatter stringFromDate:senddate];
    [hbi setTime:timetemp];
    NSError* error;
    BOOL isSaveSuccess=[_myAppDelegate.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
    }

}

-(IBAction)cancel:(id)sender
{
    [self stopAVCaptureFail];
}

#pragma mark -
#pragma mark - 哟

- (void)createWorkDataSourceWithTimeInterval:(NSTimeInterval )timeInterval
{
    timer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerTranslationFun) userInfo:nil repeats:YES];
}
//平移方式绘制
- (void)timerTranslationFun
{
    [[PointContainer sharedContainer] addPointAsTranslationChangeform:[self bubbleTranslationPoint]];
    
    [self.translationMoniterView fireDrawingWithPoints:[[PointContainer sharedContainer] translationPointContainer] pointsCount:[[PointContainer sharedContainer] numberOfTranslationElements]];
    
}

#pragma mark -
#pragma mark - DataSource


- (CGPoint)bubbleTranslationPoint
{
    static NSInteger dataSourceCounterIndex = -1;
    dataSourceCounterIndex ++;
    dataSourceCounterIndex %= [self.dataSource count];
    
    
    NSInteger pixelPerPoint = 1;
    static NSInteger xCoordinateInMoniter = 0;
    
    CGPoint targetPointToAdd = (CGPoint){xCoordinateInMoniter,[self.dataSource[dataSourceCounterIndex] integerValue] * 0.5 + 120};
    xCoordinateInMoniter += pixelPerPoint;
    xCoordinateInMoniter %= (int)(CGRectGetWidth(self.translationMoniterView.frame));
//    NSLog(@"%ld",(long)xCoordinateInMoniter);
    return targetPointToAdd;
}

#pragma mark - Cleanup

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)performAnimation
{
    
    [_resultButton pop_removeAllAnimations];
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    
    if (self.animated) {
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    }else{
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1.1, 1.1)];
    }
    
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    self.animated = !self.animated;
    
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
            [self performAnimation];
        }
    };
    
    [_resultButton.layer pop_addAnimation:anim forKey:@"Animation"];
}

/*进度条每次加0.01 */
-(void)timerChanged:(id)sender
{
    self.progress.progress +=0.01/15;
}

-(void)startProgress
{
    timer=[NSTimer scheduledTimerWithTimeInterval:0.01f
                                           target:self
                                         selector:@selector(timerChanged:)
                                         userInfo:nil
                                          repeats:YES];
}
@end
