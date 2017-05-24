//
//  ViewController.m
//  QRReader
//
//  Created by David on 5/24/17.
//  Copyright © 2017 David. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *startScanButton;

- (IBAction)startStopReading:(id)sender;

@property (strong, nonatomic) QRCodeReader *qrReader;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isReading = NO;
    
    self.qrReader = [[QRCodeReader alloc] init];
    self.qrReader.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopReading:(id)sender{
    if (!_isReading) {
        if ([self.qrReader startReadingInsideView:_viewPreview]) {
            
            [_startScanButton setTitle:@"Stop" forState:UIControlStateNormal];
            [_lblStatus setText:@"Scanning for QR Code..."];
        }
    }
    else{
        [self.qrReader stopReading];
        [_startScanButton setTitle:@"Start!" forState:UIControlStateNormal];
    }
    
    _isReading = !_isReading;
}

#pragma mark - QRCodeReader delegates
- (void)QRCodeReadResult:(NSString *)resultString{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lblStatus.text = resultString;
        _isReading = NO;
        
    
    });
}



@end
