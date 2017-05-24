//
//  ViewController.h
//  QRReader
//
//  Created by David on 5/24/17.
//  Copyright © 2017 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReader.h"

@interface ViewController : UIViewController <QRCodeReaderDelegate>

@property (nonatomic) BOOL isReading;


@end

