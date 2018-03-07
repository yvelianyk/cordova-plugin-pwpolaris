//
//  PolarisOffice.h
//  powwow
//
//  Created by Vadym Maslov on 10/2/17.
//  Copyright © 2017 powwowmobile. All rights reserved.
//

#import <Cordova/CDVPlugin.h>

@interface PolarisOffice : CDVPlugin

- (void)init:(CDVInvokedUrlCommand*)command;
- (void)openDocument:(CDVInvokedUrlCommand*)command;

@end
