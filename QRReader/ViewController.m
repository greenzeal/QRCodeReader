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
    
    self.qrReader = [[QRCodeReader alloc] init];
    self.qrReader.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)startStopReading:(id)sender{
    if([_startScanButton.titleLabel.text isEqualToString:@"Stop"]){
        [self.qrReader stopReading];
    }else{
        [self.qrReader startReadingInsideView:_viewPreview];
    }
    
    
}

#pragma mark - QRCodeReader delegates
- (void)QRCodeReadingStatus:(BOOL)isReading{
    if(isReading){
        [_startScanButton setTitle:@"Stop" forState:UIControlStateNormal];
        [_lblStatus setText:@"Scanning for QR Code..."];
    }else{
        [_startScanButton setTitle:@"Start reading" forState:UIControlStateNormal];
        [_lblStatus setText:@""];
    }
    
    
}


- (void)QRCodePermission:(BOOL)granted{
  
    if(!granted){
        //We don't have access to camere, let's ask again
        NSLog(@"%@", @"Denied camera access");
        
        NSString *alertText;
        NSString *alertButton;

        BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != nil);
        if (canOpenSettings)
        {
            alertText = @"It looks like your privacy settings are preventing us from accessing your camera to do barcode scanning. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Touch Privacy.\n\n3. Turn the Camera on.\n\n4. Open this app and try again.";
            
            alertButton = @"Go";
        }
        else
        {
            alertText = @"It looks like your privacy settings are preventing us from accessing your camera to do barcode scanning. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Touch Privacy.\n\n5. Turn the Camera on.\n\n6. Open this app and try again.";
            
            alertButton = @"OK";
        }
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Camera Permission Denided" message:alertText preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:alertButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (canOpenSettings){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }
            
        }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];

    
    
    } else {
       
        NSLog(@"COOL EVERYTHING IS OK, LET'S SCAN!");
        
    }

}


- (void)QRCodeReadResult:(NSString *)resultString{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lblStatus.text = resultString;
    });
}



@end
