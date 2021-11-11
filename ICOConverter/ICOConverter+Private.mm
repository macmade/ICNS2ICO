/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2013, DigiDNA - www.digidna.net

 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

/*!
 * @file        
 * @copyright   (c) 2013, DigiDNA - www.digidna.net
 * @author      Jean-David Gadina <macmade@digidna.net>
 * @abstract    ...
 */

#import "ICOConverter+Private.h"
#import <iostream>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpedantic"
#pragma clang diagnostic ignored "-Wsign-conversion"
#pragma clang diagnostic ignored "-Wold-style-cast"
#pragma clang diagnostic ignored "-Wignored-qualifiers"
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wimplicit-int-float-conversion"

#define MAGICKCORE_QUANTUM_DEPTH    32
#define MAGICKCORE_HDRI_ENABLE      0

#import <Magick++.h>

#pragma clang diagnostic pop

#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation ICOConverter( Private )

- ( NSData * )convertTIFFDataToBMPData: ( NSData * )tiffData
{
    NSString      * tiffFile;
    NSString      * icoFile;
    NSData        * icoData;
    const char    * bytes;
    uint32_t        size;
    uint32_t        offset;
    Magick::Image   image;
    
    tiffFile = [ [ NSString stringWithCString: tmpnam( NULL ) encoding: NSUTF8StringEncoding ] stringByAppendingPathExtension: @"tiff" ];
    icoFile  = [ [ NSString stringWithCString: tmpnam( NULL ) encoding: NSUTF8StringEncoding ] stringByAppendingPathExtension: @"ico" ];
    
    [ tiffData writeToFile: tiffFile atomically: YES ];
    
    try
    {
        image.read( tiffFile.UTF8String );
        image.magick( "ICO" );
        image.write( icoFile.UTF8String );
    }
    catch( ... )
    {}
    
    icoData = [ [ NSFileManager defaultManager ] contentsAtPath: icoFile ];
    bytes   = static_cast< const char * >( icoData.bytes );
    
    [ [ NSFileManager defaultManager ] removeItemAtPath: tiffFile error: NULL ];
    [ [ NSFileManager defaultManager ] removeItemAtPath: icoFile  error: NULL ];
    
    if( bytes != NULL && icoData.length > 22 )
    {
        size   = *( reinterpret_cast< uint32_t * >( const_cast< char * >( bytes + 14 ) ) );
        offset = *( reinterpret_cast< uint32_t * >( const_cast< char * >( bytes + 18 ) ) );
        
        return [ NSData dataWithBytes: bytes + offset length: size ];
    }
    
    return nil;
}

@end
