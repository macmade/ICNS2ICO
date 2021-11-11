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
