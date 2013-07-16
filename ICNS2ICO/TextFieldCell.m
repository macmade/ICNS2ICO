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

#import "TextFieldCell.h"

@implementation TextFieldCell

- ( void )drawWithFrame: ( NSRect )frame inView: ( NSView * )view
{
    NSString            * text;
    NSMutableDictionary * attributes;
    CGFloat               fontSize;
    NSRect                textRect;
    NSSize                size;
    
    ( void )view;
    
    if( [ self.objectValue isKindOfClass: [ NSString class ] ] == NO )
    {
        return;
    }
    
    attributes  = [ NSMutableDictionary dictionaryWithCapacity: 10 ];
    fontSize    = [ NSFont systemFontSize ];
    
    if( self.backgroundStyle == NSBackgroundStyleDark )
    {
        [ attributes setObject: [ NSColor whiteColor ] forKey: NSForegroundColorAttributeName ];
    }
    else
    {
        [ attributes setObject: [ NSColor textColor ] forKey: NSForegroundColorAttributeName ];
    }
    
    [ attributes setObject: [ NSFont systemFontOfSize: fontSize ]   forKey: NSFontAttributeName ];
    [ attributes setObject: [ NSColor clearColor ]                  forKey: NSBackgroundColorAttributeName ];
    
    text                  = ( NSString * )( self.objectValue );
    size                  = [ text sizeWithAttributes: attributes ];
    textRect              = frame;
    textRect.origin.y    += ( frame.size.height - size.height ) / ( CGFloat )2;
    textRect.size.height -= ( frame.size.height - size.height ) / ( CGFloat )2;
    
    [ text drawInRect: textRect withAttributes: attributes ];
}

@end
