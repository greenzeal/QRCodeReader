//
//  QRCodeReader.h
//  QRReader
//
//  Created by David on 5/24/17.
//  Copyright © 2017 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol QRCodeReaderDelegate <NSObject>

@optional
- (void)QRCodeReadingStatus:(BOOL)isReading;
- (void)QRCodeReadResult:(NSString *)resultString;

@end


@interface QRCodeReader : NSObject

@property (weak, nonatomic) id <QRCodeReaderDelegate> delegate;
@property (nonatomic) BOOL isReading;

- (BOOL)startReadingInsideView:(UIView *)view;
- (void)stopReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;


@end
