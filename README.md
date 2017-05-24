# QRCodeReader
Simple QR code reader for Objective C, Just import one class and implement delegate. If you need you can change Beep.wav also.


iOS 10 --->> add key to Info.plist "NSCameraUsageDescription"

This code was created with help of AppCoda tutorial.

    #import "QRCodeReader.h"

set property

    @property (strong, nonatomic) QRCodeReader *qrReader;


to connect outlets with UIView where camera will be shown


in ViewDidload

    self.qrReader = [[QRCodeReader alloc] init];
    self.qrReader.delegate = self;


to Start Reading

    [self.qrReader startReadingInsideView:_viewPreview];

to Stop Reading

    [self.qrReader stopReading];

implement delegate to receive result

    - (void)QRCodeReadResult:(NSString *)resultString{
    
        dispatch_async(dispatch_get_main_queue(), ^{
        
            ///Set the UILabel text or what ever you need
    
        });
    }
