/*******************************************************************************
 * Copyright (c) 2013, DigiDNA - www.digidna.net
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *  -   Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *  -   Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *  -   Neither the name of 'Jean-David Gadina' nor the names of its
 *      contributors may be used to endorse or promote products derived from
 *      this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
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
    bytes   = ( const char * )icoData.bytes;
    
    [ [ NSFileManager defaultManager ] removeItemAtPath: tiffFile error: NULL ];
    [ [ NSFileManager defaultManager ] removeItemAtPath: icoFile  error: NULL ];
    
    if( bytes != NULL && icoData.length > 22 )
    {
        size   = *( ( uint32_t * )( ( void * )( bytes + 14 ) ) );
        offset = *( ( uint32_t * )( ( void * )( bytes + 18 ) ) );
        
        return [ NSData dataWithBytes: bytes + offset length: size ];
    }
    
    return nil;
}

@end
