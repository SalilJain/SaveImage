//
//  SaveScreenshot.m
//  SaveScreenshot
//
//  Created by Salil on 6/5/12.
//  Copyright (c) 2012 SaachiTech. All rights reserved.
//


#import "FlashRuntimeExtensions.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
FREObject openInstagram(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    if(argc >= 2)
    {
        uint32_t string1Length;
        const uint8_t *file;
        FREGetObjectAsUTF8(argv[0], &string1Length, &file);
        
        uint32_t string2Length;
        const uint8_t *caption;
        FREGetObjectAsUTF8(argv[1], &string2Length, &caption);
        NSMutableDictionary * annotation=[[NSMutableDictionary alloc] init];
        [annotation setObject:[NSString stringWithUTF8String:(char *)caption] forKey:@"InstagramCaption"];
        
        UIWindow *keyWindow= [[UIApplication sharedApplication] keyWindow];
        UIViewController *mainController = [keyWindow rootViewController];
        NSURL *igImageHookFile = [NSURL fileURLWithPath:[NSString stringWithUTF8String:(char *)file]]; 
        [igImageHookFile retain];
        NSLog(@"File url %@",[igImageHookFile absoluteString]);
        UIDocumentInteractionController *docController = [UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
        [docController retain];
        docController.UTI = @"com.instagram.exclusivegram";
        docController.annotation=annotation;
        CGRect rectDocC = CGRectMake(800, 0, 0, 0);
        [docController presentOptionsMenuFromRect:rectDocC inView:mainController.view  animated:YES];
        
    }
    
    FREObject retVal;
    FRENewObjectFromInt32( 0, &retVal );
    return retVal;
    
}
FREObject openPDF(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) 
{
    UIWindow *keyWindow= [[UIApplication sharedApplication] keyWindow];
    
    UIViewController *mainController = [keyWindow rootViewController];
    
    
    
    NSString *epubFileName= [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
    
    [epubFileName retain];
    
    
    
    NSURL *url = [NSURL fileURLWithPath:epubFileName];
    
    [url retain];
    
    
    
    UIDocumentInteractionController *docController = [UIDocumentInteractionController interactionControllerWithURL:url];
    
    [docController retain];
    
    
    
    CGRect rectDocC = CGRectMake(0, 0, 0, 0);
    
    [docController presentOptionsMenuFromRect:rectDocC inView:mainController.view animated:YES];
    FREObject retVal;
    FRENewObjectFromInt32( 0, &retVal );
    return retVal;
}
FREObject getScreenShotPNG(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    if(argc >= 2)
    {
        uint32_t string1Length;
        const uint8_t *file;
        FREGetObjectAsUTF8(argv[0], &string1Length, &file);
        
        
        
        FREObject       objectBitmapData = argv[ 1 ];
        FREBitmapData2  bitmapData;
        
        FREAcquireBitmapData2( objectBitmapData, &bitmapData );
        
        int width       = bitmapData.width;
        int height      = bitmapData.height;
        int stride      = bitmapData.lineStride32 * 4;
        uint32_t* input = bitmapData.bits32;
        
        // make data provider from buffer
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData.bits32, (width * height * 4), NULL);
        
        // set up for CGImage creation
        int                     bitsPerComponent    = 8;
        int                     bitsPerPixel        = 32;
        int                     bytesPerRow         = 4 * width;
        CGColorSpaceRef         colorSpaceRef       = CGColorSpaceCreateDeviceRGB();    
        CGBitmapInfo            bitmapInfo;
        
        if( bitmapData.hasAlpha )
        {
            if( bitmapData.isPremultiplied )
                bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst; 
            else
                bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaFirst;            
        }
        else
        {
            bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;  
        }
        
        CGColorRenderingIntent  renderingIntent     = kCGRenderingIntentDefault;
        CGImageRef              imageRef            = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
        
        // make UIImage from CGImage
        UIImage *image = [UIImage imageWithCGImage:imageRef];    
        // NSData* jpgData  = UIImageJPEGRepresentation( image, 0.9 );  
        NSLog(@"Saving");
        [UIImagePNGRepresentation(image)  writeToFile:[NSString stringWithUTF8String:(char *)file] atomically:YES];
        FREReleaseBitmapData( objectBitmapData );
        
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(imageRef);
        CGDataProviderRelease(provider);    
        
        FREObject retVal;
        FRENewObjectFromInt32( -12, &retVal );
        return retVal;
        
    }
    
    FREObject retVal;
    FRENewObjectFromInt32( -1, &retVal );
    return retVal;
}
FREObject getScreenShotJPEG(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // Configure Chartboost
    if(argc >= 3)
    {
        uint32_t string1Length;
        const uint8_t *file;
        FREGetObjectAsUTF8(argv[0], &string1Length, &file);
        
        uint32_t string2Length;
        const uint8_t *quality;
        FREGetObjectAsUTF8(argv[1], &string2Length, &quality);
        
        FREObject       objectBitmapData = argv[ 2 ];
        FREBitmapData2  bitmapData;
        
        FREAcquireBitmapData2( objectBitmapData, &bitmapData );
        
        int width       = bitmapData.width;
        int height      = bitmapData.height;
        int stride      = bitmapData.lineStride32 * 4;
        uint32_t* input = bitmapData.bits32;
        
        // make data provider from buffer
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData.bits32, (width * height * 4), NULL);
        
        // set up for CGImage creation
        int                     bitsPerComponent    = 8;
        int                     bitsPerPixel        = 32;
        int                     bytesPerRow         = 4 * width;
        CGColorSpaceRef         colorSpaceRef       = CGColorSpaceCreateDeviceRGB();    
        CGBitmapInfo            bitmapInfo;
        
        if( bitmapData.hasAlpha )
        {
            if( bitmapData.isPremultiplied )
                bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst; 
            else
                bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaFirst;            
        }
        else
        {
            bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;  
        }
        
        CGColorRenderingIntent  renderingIntent     = kCGRenderingIntentDefault;
        CGImageRef              imageRef            = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
        
        // make UIImage from CGImage
        UIImage *image = [UIImage imageWithCGImage:imageRef];    
        NSLog(@"Saving");
        [UIImageJPEGRepresentation(image, [[NSString stringWithUTF8String:(char *)quality] floatValue])  writeToFile:[NSString stringWithUTF8String:(char *)file] atomically:YES];
        FREReleaseBitmapData( objectBitmapData );
        
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(imageRef);
        CGDataProviderRelease(provider);    
       
        FREObject retVal;
        FRENewObjectFromInt32( -12, &retVal );
        return retVal;
        
    }
    
    FREObject retVal;
    FRENewObjectFromInt32( -2, &retVal );
    return retVal;
}


// A native context instance is created
void ScreenshotContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
	*numFunctionsToTest = 4;
	FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction)*4);
	func[0].name = (const uint8_t*)"getScreenShotPNG";
	func[0].functionData = NULL;
	func[0].function = &getScreenShotPNG;
	
	func[1].name = (const uint8_t*)"getScreenShotJPEG";
	func[1].functionData = NULL;
	func[1].function = &getScreenShotJPEG;
    
    func[2].name = (const uint8_t*)"openInstagram";
	func[2].functionData = NULL;
	func[2].function = &openInstagram;
    
    func[3].name = (const uint8_t*)"openPDF";
	func[3].functionData = NULL;
	func[3].function = &openPDF;
    
    
	*functionsToSet = func;
}

// A native context instance is disposed
void ScreenshotContextFinalizer(FREContext ctx) {
	return;
}

// Initialization function of each extension
void ScreenshotExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
	*extDataToSet = NULL;
	*ctxInitializerToSet = &ScreenshotContextInitializer;
	*ctxFinalizerToSet = &ScreenshotContextFinalizer;
}

// Called when extension is unloaded
void ScreenshotExtFinalizer(void* extData) {
	return;
}
