//
//  QRCodeReader.m
//  QRReader
//
//  Created by David on 5/24/17.
//  Copyright © 2017 David. All rights reserved.
//

#import "QRCodeReader.h"

@interface QRCodeReader() <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
-(void)loadBeepSound;


@end

@implementation QRCodeReader
@synthesize delegate;
- (id)init
{
    if ((self = [super init])) {
    //Init values
        _captureSession = nil;
        [self loadBeepSound];
    
    }
    
    return self;
}


- (void)startReadingInsideView:(UIView *)view{
    
    
    [self checkPermission:^(BOOL granted) {
       
        if(granted){
            dispatch_async(dispatch_get_main_queue(), ^{
                
           
                if([delegate respondsToSelector:@selector(QRCodePermission:)]){
                        [delegate QRCodePermission:YES];
                    }
            
            [self startReading:view];
         });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if([delegate respondsToSelector:@selector(QRCodePermission:)]){
                    [delegate QRCodePermission:NO];
                }
            });
            
        }
        
    }];
    
    
  
    
    
}

- (void)startReading:(UIView *)view{
    
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        
        if([delegate respondsToSelector:@selector(QRCodeReadingFailed:)]){
            [delegate QRCodeReadingFailed:error];
        }
        return;
    }

    
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:view.layer.bounds];
    [view.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    if([delegate respondsToSelector:@selector(QRCodeReadingStatus:)]){
        [delegate QRCodeReadingStatus:YES];
    }
    
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            if([delegate respondsToSelector:@selector(QRCodeReadResult:)]){
                [delegate QRCodeReadResult:[metadataObj stringValue]];
            }
            if([delegate respondsToSelector:@selector(QRCodeReadingStatus:)]){
                [delegate QRCodeReadingStatus:NO];
            }
            
            _isReading = NO;
            
            if (_audioPlayer) {
                [_audioPlayer play];
            }
            
        }
    }
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
    
    if([delegate respondsToSelector:@selector(QRCodeReadingStatus:)]){
        [delegate QRCodeReadingStatus:NO];
    }
}


-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
    }
}

- (void)checkPermission:(void (^)(BOOL granted))completion{
    
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            // Will get here on both iOS 7 & 8 even though camera permissions weren't required
            // until iOS 8. So for iOS 7 permission will always be granted.
            // Permission received. Use dispatch_async for any UI updating
            // code because this block may be executed in a thread.
            completion(granted);
            
        }];
    } else {
            completion(YES);
    }

}

@end
