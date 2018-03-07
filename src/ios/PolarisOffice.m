//
//  PolarisOffice.m
//  powwow
//
//  Created by Vadym Maslov on 10/2/17.
//  Copyright © 2017 powwowmobile. All rights reserved.
//

#import "PolarisOffice.h"
#import <QuickLook/QuickLook.h>
#import <PolarisOfficeSDK/CPolarisHelper.h>
#import <PolarisOfficeSDK/CPolarisCaster.h>
#import <PolarisOfficeSDK/CFileData.h>
#import <PolarisOfficeSDK/COptionData.h>
#import <PolarisOfficeSDK/CDefineCommon.h>
#import "PWEventActionExecutor.h"

@interface PolarisOffice ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate>

@property (retain, nonatomic) __block UIViewController *polarisEditorViewController;
@property (nonatomic, strong) NSString *licenseKey;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *callbackID;
@property (nonatomic, strong) UIDocumentInteractionController *docController;

@end

@implementation PolarisOffice

- (void)init:(CDVInvokedUrlCommand *)command
{
    self.licenseKey = [command.arguments firstObject][@"key"];
    NSLog(@"%s licenseKey:%@", __FUNCTION__, self.licenseKey);
    [[PWEventActionExecutor eventExecutor] registerObject:self
                                                forEvents:@[[PWSelectorHolder holderWithSelector:@selector(completeClose)
                                                                                        forEvent:@"polarisOfficeDidClose"]]];
}

- (void)openDocument:(CDVInvokedUrlCommand *)command
{
    NSString *filePath      = [command.arguments firstObject][@"fileUri"];
    NSLog(@"%s filePath:%@", __FUNCTION__, filePath);
    BOOL isPreviewEnabled   = [[command.arguments firstObject][@"isPreview"] boolValue];
    self.callbackID         = command.callbackId;
    [self openFile:filePath withPreview:isPreviewEnabled];
}

- (void)openFile:(NSString *)filePath withPreview:(BOOL)isPreviewEnabled
{
    self.filePath = filePath;
    
    if (self.licenseKey.length > 0) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            [[CPolarisHelper sharedPolarisHelper] OpenDocument:[filePath substringFromIndex:7]
                                                              :nil
                                                              :(id)self
                                           completedController:^(UIViewController *editorViewController) {
                                               if(editorViewController != nil) {
                                                   self.polarisEditorViewController = editorViewController;
                                                   [self.viewController presentViewController:editorViewController
                                                                                     animated:NO
                                                                                   completion:nil];
                                               }}];
        }];
    } else {
        if (isPreviewEnabled) {
            QLPreviewController *previewController   = [[QLPreviewController alloc] init];
            previewController.dataSource             = self;
            previewController.delegate               = self;
            
            [self.viewController presentViewController:previewController
                                              animated:YES
                                            completion:nil];
        } else {
            self.docController          = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.filePath]];
            self.docController.delegate = self;
            [self.docController presentOpenInMenuFromRect:self.viewController.view.bounds
                                                   inView:self.viewController.view
                                                 animated:YES];
        }
    }
}

#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return 1;
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    return [NSURL fileURLWithPath:self.filePath];
}

#pragma mark - Polar office

- (NSString*)setLicenseKey
{
    return self.licenseKey;
}

- (void)completeClose
{
    [self.polarisEditorViewController dismissViewControllerAnimated:NO completion:^(){
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                          messageAsString:self.filePath];
        [self.commandDelegate sendPluginResult:pluginResult
                                    callbackId:self.callbackID];
    }];
}

@end
