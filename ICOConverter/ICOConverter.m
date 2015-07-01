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


#import "ICOConverter.h"
#import "ICOConverter+Private.h"

@implementation ICOConverter

@synthesize destinationDirectory = _destinationDirectory;
@synthesize icoFormat            = _icoFormat;

- ( id )initWithDestinationDirectory: ( NSString * )path
{
    BOOL isDir;
    
    if( ( self = [ super init ] ) )
    {
        _destinationDirectory = [ path copy ];
        
        if( _destinationDirectory.length == 0 || [ [ NSFileManager defaultManager ] fileExistsAtPath: _destinationDirectory isDirectory: &isDir ] == NO || isDir == NO )
        {
            [ self release ];
            
            return nil;
        }
    }
    
    return self;
}

- ( id )init
{
    [ self release ];
    
    return nil;
}

- ( BOOL )convertImageAtPath: ( NSString * )path
{
    BOOL               isDir;
    NSString         * destinationFile;
    NSImage          * image;
    NSMutableArray   * representations;
    NSMutableArray   * bitmapDataObjects;
    NSImageRep       * rep;
    NSBitmapImageRep * bitmapRep;
    NSMutableData    * icoData;
    NSData           * bitmapData;
    uint8_t            width;
    uint8_t            height;
    uint8_t            colors;
    uint8_t            reserved;
    uint16_t           planes;
    uint16_t           bits;
    uint32_t           size;
    uint32_t           dataOffset;
    uint16_t           type;
    uint16_t           num;
    
    if( _icoFormat == ICOConverterFormatUnknown )
    {
        return NO;
    }
    
    if( _destinationDirectory.length == 0 || [ [ NSFileManager defaultManager ] fileExistsAtPath: _destinationDirectory isDirectory: &isDir ] == NO || isDir == NO )
    {
        return NO;
    }
    
    if( path.length == 0 || [ [ NSFileManager defaultManager ] fileExistsAtPath: path isDirectory: &isDir ] == NO || isDir == YES )
    {
        return NO;
    }
    
    image = [ [ [ NSImage alloc ] initWithContentsOfFile: path ] autorelease ];
    
    if( image == nil || image.size.width == 0 || image.size.height == 0 )
    {
        return NO;
    }
    
    representations     = [ [ [ NSMutableArray alloc ] init ] autorelease ];
    bitmapDataObjects   = [ [ [ NSMutableArray alloc ] init ] autorelease ];
    
    for( rep in image.representations.reverseObjectEnumerator.allObjects )
    {
        if( [ rep isKindOfClass: [ NSBitmapImageRep class ] ] == NO )
        {
            continue;
        }
        
        bitmapRep = ( NSBitmapImageRep * )rep;
        
        if( bitmapRep.pixelsWide > 256 || bitmapRep.pixelsHigh > 256 )
        {
            continue;
        }
        
        [ representations addObject: rep ];
    }
    
    if( representations.count == 0 )
    {
        return NO;
    }
    
    icoData     = [ [ [ NSMutableData alloc ] init ] autorelease ];
    reserved    = 0;
    type        = 1;
    num         = ( uint16_t )( representations.count );
    
    [ icoData appendBytes: &reserved length: 1 ];
    [ icoData appendBytes: &reserved length: 1 ];
    [ icoData appendBytes: &type     length: 2 ];
    [ icoData appendBytes: &num      length: 2 ];
    
    dataOffset = ( uint32_t )( ( 16 * representations.count ) + 6 );
    
    for( bitmapRep in representations )
    {
        if( _icoFormat == ICOConverterFormatPNG )
        {
            bitmapData = [ bitmapRep representationUsingType: NSPNGFileType properties: @{} ];
        }
        else
        {
            bitmapData = [ self convertTIFFDataToBMPData: [ bitmapRep representationUsingType: NSTIFFFileType properties: @{} ] ];
        }
        
        if( bitmapData != nil )
        {
            [ bitmapDataObjects addObject: bitmapData ];
        }
        
        width       = ( bitmapRep.pixelsWide == 256 ) ? 0 : ( unsigned char )( bitmapRep.pixelsWide );
        height      = ( bitmapRep.pixelsHigh == 256 ) ? 0 : ( unsigned char )( bitmapRep.pixelsHigh );
        colors      = 0;
        reserved    = 0;
        planes      = ( uint16_t )( bitmapRep.numberOfPlanes );
        bits        = ( uint16_t )( bitmapRep.bitsPerPixel );
        size        = ( uint32_t )( bitmapData.length );
        
        [ icoData appendBytes: &width       length: 1 ];
        [ icoData appendBytes: &height      length: 1 ];
        [ icoData appendBytes: &colors      length: 1 ];
        [ icoData appendBytes: &reserved    length: 1 ];
        [ icoData appendBytes: &planes      length: 2 ];
        [ icoData appendBytes: &bits        length: 2 ];
        [ icoData appendBytes: &size        length: 4 ];
        [ icoData appendBytes: &dataOffset  length: 4 ];
        
        dataOffset += size;
    }
    
    for( bitmapData in bitmapDataObjects )
    {
        [ icoData appendData: bitmapData ];
    }
    
    destinationFile = [ _destinationDirectory stringByAppendingPathComponent: [ path lastPathComponent ] ];
    destinationFile = [ [ destinationFile stringByDeletingPathExtension ] stringByAppendingPathExtension: @"ico" ];
    
    [ icoData writeToFile: destinationFile atomically: YES ];
    
    return [ [ NSFileManager defaultManager ] fileExistsAtPath: destinationFile ];
}

@end
